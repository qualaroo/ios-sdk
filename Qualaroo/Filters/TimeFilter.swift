//
//  TimeFilter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class TimeFilter {
  
  private let minimumTimePassed: TimeInterval = 72 * 60 * 60
  
  init(withSeenSurveyStorage storage: SeenSurveyMemoryProtocol) {
    self.storage = storage
  }
  
  /// Class that keeps persistent data.
  private let storage: SeenSurveyMemoryProtocol

  /// Used to determine if user has seen survey with given id in last 72 hours.
  ///
  /// - Parameter surveyID: Unique identifier of survey we want to check.
  /// - Returns: True if user has seen survey recently, false if he didn't.
  private func enoughTimePassed(forSurveyId surveyId: Int) -> Bool {
    guard let lastSeenDate = storage.lastSeenDate(forSurveyWithID: surveyId) else { return true }
    let threeDaysAgo = Date(timeIntervalSinceNow: -minimumTimePassed)
    let enoughTimePassed = lastSeenDate <= threeDaysAgo
    if enoughTimePassed == false {
      Qualaroo.log("""
        Not showing survey with id: \(surveyId).
        At least 72 hours should pass before survey can be re-displayed.
        """)
      return false
    }
    return true
  }
  
}

extension TimeFilter: FilterProtocol {
  func shouldShow(survey: Survey) -> Bool {
    return enoughTimePassed(forSurveyId: survey.surveyId)
  }
}
