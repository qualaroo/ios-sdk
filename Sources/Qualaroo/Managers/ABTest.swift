//
//  SurveyPicker.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

class ABTest {
  typealias Memory = SamplePercentMemoryProtocol & FinishedSurveyMemoryProtocol
  
  private let surveys: [Survey]
  private let memory: Memory
  private let filters: FilterProtocol
  
  init(surveys: [Survey], memory: Memory, filters: FilterProtocol) {
    self.surveys = surveys
    self.memory = memory
    self.filters = filters
  }
  
  func show(on viewController: UIViewController? = nil,
            forced: Bool = false,
            delegate: SurveyDelegate? = nil) {
    guard let survey = correctSurvey(index: 0) else { return }
    guard Qualaroo.shared.shouldPresent(survey: survey, forced: forced, filters: filters) else { return }
    markAllSurveysAsFinished(except: survey)
    Qualaroo.shared.present(survey: survey, on: viewController, delegate: delegate)
  }
}

private extension ABTest {
  
  func surveyChainKey() -> String {
    let idsList = surveys.map { "\($0.surveyId)" }.sorted()
    return idsList.joined(separator: "-")
  }
  func getTestPercent() -> Int {
    if let random = memory.getSamplePercent(forSurveysChain: surveyChainKey()) {
      return random
    }
    return newRandomPercent()
  }
  func newRandomPercent() -> Int {
      let newNumber = Int(arc4random_uniform(100))
      memory.saveSamplePercent(newNumber, forSurveyChain: surveyChainKey())
      return newNumber
  }

  func correctSurvey(index: Int) -> Survey? {
    guard index < surveys.count else { return nil }
    let list = Array(surveys.prefix(through: index))
    let fullProcent = list.map { $0.requireMap.samplePercent }.reduce(0, +)
    if getTestPercent() > fullProcent {
      return correctSurvey(index: index + 1)
    }
    return list.last
  }
  
  func markAllSurveysAsFinished(except: Survey) {
    surveys.filter { $0 != except }.forEach { memory.saveUserHaveFinished(surveyWithID: $0.surveyId) }
  }
}
