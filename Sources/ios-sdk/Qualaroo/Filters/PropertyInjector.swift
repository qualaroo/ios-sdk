//
//  TextConverter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import UIKit

protocol TextConverter: class {
  func convert(_ text: String) -> String
}

class PropertyInjector {
  
  let customProperties: CustomProperties
  
  init(customProperties: CustomProperties) {
    self.customProperties = customProperties
  }
  
  private func check(survey: Survey) -> Bool {
    var missing = [String]()
    for node in survey.nodeList {
      missing.append(contentsOf: missingProperties(node: node))
    }
    if missing.count > 0 {
      Qualaroo.log("""
        Not showing survey with id: \(survey.surveyId).
        Missing custom properties: \(missing.joined(separator: ", "))
        """)
      return false
    }
    return true
  }
  
  private func missingProperties(node: Node) -> [String] {
    switch node {
    case let question as Question:
      var missing = missingProperties(question.title)
      missing.append(contentsOf: missingProperties(question.description))
      return  missing
    case let leadGen as LeadGenForm:
      return missingProperties(leadGen.description)
    case let message as Message:
      return missingProperties(message.description)
    default:
      return []
    }
  }
  private func missingProperties(_ text: String) -> [String] {
    var properties = findAllProperties(in: text)
    properties = properties.map { removeBrackets($0) }
    return customProperties.checkForMissing(withKeywords: properties)
  }
  
  private func injectProperties(_ text: String) -> String {
    var replacedText = text
    let properties = findAllProperties(in: text)
    for property in properties {
      let value = customProperties.dictionary[removeBrackets(property)] ?? ""
      replacedText = replacedText.replacingOccurrences(of: property,
                                                     with: value)
    }
    return replacedText
  }
    
  private func removeBrackets(_ text: String) -> String {
    let start = text.index(text.startIndex, offsetBy: 2)
    let end = text.index(before: text.endIndex)
    let range = start..<end
    return String(text[range])
  }
  
  private func findAllProperties(in text: String) -> [String] {
    let pattern = "\\$\\{.*?\\}"
    //swiftlint:disable:next force_try
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let matches = regex.matches(in: text,
                                options: [],
                                range: NSRange(location: 0,
                                               length: text.count))
    return matches.map { String(text[text.range(from: $0.range)]) }
  }
}

extension PropertyInjector: TextConverter {
  func convert(_ text: String) -> String {
    return injectProperties(text)
  }
}

extension PropertyInjector: FilterProtocol {
  func shouldShow(survey: Survey) -> Bool {
    return check(survey: survey)
  }
}
