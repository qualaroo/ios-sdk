//
//  SamplePercentFilter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class SamplePercentFilter {
  
  init(withSamplePercentStorage storage: SamplePercentMemoryProtocol) {
    self.storage = storage
  }
  
  /// Class that keeps persistent data.
  private let storage: SamplePercentMemoryProtocol

  private func isPartOfRandomGroup(surveyId: Int, withSamplePercent percent: Int) -> Bool {
    let isPartOfRandomGroup = getRandomNumber(forSurveyId: surveyId) < percent
    if isPartOfRandomGroup == false {
      Qualaroo.log("Not showing survey with id: \(surveyId). Survey should be displayed only for \(percent)% of users.")
      return false
    }
    return true
  }
  
  private func getRandomNumber(forSurveyId surveyId: Int) -> Int {
    if let randomNumber = storage.getSamplePercent(forSurveyId: surveyId) {
      return randomNumber
    }
    return newRandomNumber(forSurveyId: surveyId)
  }
  private func newRandomNumber(forSurveyId surveyId: Int) -> Int {
    let newNumber = Int(arc4random_uniform(100))
    storage.saveSamplePercent(newNumber, forSurveyId: surveyId)
    return newNumber
  }
}

extension SamplePercentFilter: FilterProtocol {
  func shouldShow(survey: Survey) -> Bool {
    return isPartOfRandomGroup(surveyId: survey.surveyId,
                               withSamplePercent: survey.requireMap.samplePercent)
  }
}
