//
//  Survey.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class SurveyFactory {
  
  let dictionary: [String: Any]
  
  init(with dictionary: [String: Any]) {
    self.dictionary = dictionary
  }
  
  func build() throws -> Survey {
    return Survey(surveyId: try surveyId(),
                  isActive: isActive(),
                  name: try name(),
                  alias: try alias(),
                  nodeList: try nodeList(),
                  startMap: try startMap(),
                  languagesList: try languagesList(),
                  requireMap: try requireMap(),
                  mandatory: try mandatory(),
                  theme: try theme())
  }
  
  private func isActive() -> Bool {
    return (dictionary["active"] as? Bool) ?? false
  }
  
  private func surveyId() throws -> Int {
    guard let id = dictionary["id"] as? Int else { throw SurveyError.missingOrWrongId }
    return id
  }
  
  private func name() throws -> String {
    guard let name = dictionary["name"] as? String else { throw SurveyError.missingOrWrongName }
    return name
  }
  
  private func alias() throws -> String {
    guard
      let alias = dictionary["canonical_name"] as? String,
      !alias.isEmpty else { throw SurveyError.missingOrWrongAlias }
    return alias
  }
  
  private func nodeList() throws -> [Node] {
    let questions = try questionList() as [Node]
    let messages = try messageList() as [Node]
    let leadGenForms = try leadGenFormList() as [Node]
    return questions + messages + leadGenForms
  }
  
  private func questionList() throws -> [Question] {
    return try questionDicts().map { try QuestionFactory(with: $0).build() }
  }
  
  private func questionDicts() throws -> [[String: Any]] {
    guard let dicts = try spec()["question_list"] as? [String: [[String: Any]]] else {
      throw SurveyError.missingOrWrongQuestionList
    }
    return dicts.flatMap { $1 }
  }
  
  private func messageList() throws -> [Message] {
    return try messageDicts().map { try MessageFactory(with: $0).build() }
  }
  
  private func messageDicts() throws -> [[String: Any]] {
    guard let dicts = try spec()["msg_screen_list"] as? [String: [[String: Any]]] else {
      throw SurveyError.missingOrWrongMessageList
    }
    return dicts.flatMap { $1 }
  }
  
  private func leadGenFormList() throws -> [LeadGenForm] {
    let factories = try leadGenFormDicts().map { LeadGenFormFactory(with: $0) }
    try factories.forEach { try $0.inject(questionList()) }
    return try factories.map { try $0.build() }
  }
  
  private func leadGenFormDicts() throws -> [[String: Any]] {
    guard let dicts = try spec()["qscreen_list"] as? [String: [[String: Any]]] else {
      throw SurveyError.missingOrWrongLeadGenFormList
    }
    return dicts.flatMap { $1 }
  }
  
  private func languagesList() throws -> [String] {
    guard let list = try spec()["survey_variations"] as? [String] else { throw SurveyError.missingOrWrongLanguages }
    return list
  }
  
  private func startMap() throws -> [String: NodeId] {
    return try originalStartMap().mapValues { try simplifiedStartMapEntry($0) }
  }
  
  private func originalStartMap() throws -> [String: [String: Any]] {
    guard let dict = try spec()["start_map"] as? [String: [String: Any]] else {
      throw SurveyError.missingOrWrongStartMap
    }
    return dict
  }
  
  private func simplifiedStartMapEntry(_ value: [String: Any]) throws -> NodeId {
    guard let firstNode = (value["id"] as? NSNumber) as? NodeId else { throw SurveyError.missingOrWrongStartMap }
    return firstNode
  }
  
  private func requireMap() throws -> RequireMap {
    guard let dict = try spec()["require_map"] as? [String: Any] else { throw SurveyError.missingOrWrongRequireMap }
    return RequireMapFactory(with: dict).build()
  }
  
  private func theme() throws -> Theme {
    guard let theme = Theme.create(with: try themeMap(),
                                   logoUrlString: try logoUrl(),
                                   fullscreen: try fullscreen(),
                                   closeButtonVisible: try !mandatory(),
                                   progressBar: try progressBar()) else {
                                    throw SurveyError.notSupportedThemeConfiguration
    }
    return theme
  }
  
  private func themeMap() throws -> [String: Any] {
    guard let themeMap = try optionMap()["color_theme_map"] as? [String: Any] else {
      throw SurveyError.missingOrWrongThemeMap
    }
    return themeMap
  }
  
  private func mandatory() throws -> Bool {
    guard let isMandatory = try optionMap()["mandatory"] as? Bool else { return false }
    return isMandatory
  }
  
  private func logoUrl() throws -> String {
    return (try optionMap()["logo_url"] as? String) ?? ""
  }
  
  private func fullscreen() throws -> Bool {
    return (try optionMap()["show_full_screen"] as? Bool) ?? false
  }
  
  private func progressBar() throws -> String {
    return (try optionMap()["progress_bar"] as? String) ?? ""
  }
  
  private func optionMap() throws -> [String: Any] {
    guard let optionMap = try spec()["option_map"] as? [String: Any] else {
      throw SurveyError.missingOrWrongOptionMap
    }
    return optionMap
  }
  
  private func spec() throws -> [String: Any] {
    guard let spec = dictionary["spec"] as? [String: Any] else { throw SurveyError.missingOrWrongSpec }
    return spec
  }

}

enum SurveyError: Int, QualarooError {
  case surveyIsInactive = 1
  case missingOrWrongId = 2
  case missingOrWrongName = 3
  case missingOrWrongAlias = 4
  case missingOrWrongSpec = 5
  case missingOrWrongLanguages = 6
  case missingOrWrongStartMap = 7
  case missingOrWrongQuestionList = 8
  case missingOrWrongMessageList = 9
  case missingOrWrongLeadGenFormList = 10
  case missingOrWrongRequireMap = 11
  case missingOrWrongOptionMap = 12
  case missingOrWrongThemeMap = 13
  case notSupportedThemeConfiguration = 14
}

struct Survey {
    
  let surveyId: Int
  let isActive: Bool
  let name: String
  let alias: String
  let nodeList: [Node]
  let startMap: [String: NodeId]
  let languagesList: [String]
  let requireMap: RequireMap
  let mandatory: Bool
  var theme: Theme
  
}

extension Survey: Equatable {
  static func == (lhs: Survey, rhs: Survey) -> Bool {
    return lhs.surveyId == rhs.surveyId &&
    lhs.name == rhs.name &&
    lhs.alias == rhs.alias &&
    lhs.languagesList == rhs.languagesList &&
    lhs.requireMap == rhs.requireMap &&
    lhs.theme == rhs.theme &&
    lhs.mandatory == rhs.mandatory &&
    lhs.nodeList.count == rhs.nodeList.count
  }
}
