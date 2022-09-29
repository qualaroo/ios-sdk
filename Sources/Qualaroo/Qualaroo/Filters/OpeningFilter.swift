//
//  RevealFilter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

class OpeningFilter {
  
  init(withSeenSurveyStorage storage: SeenSurveyMemoryProtocol & FinishedSurveyMemoryProtocol) {
    self.storage = storage
  }
  
  /// Class that keeps persistent data.
  private let storage: SeenSurveyMemoryProtocol & FinishedSurveyMemoryProtocol

  private func shouldShowSurvey(withId surveyId: Int,
                                frequency: RequireMap.RevealSpecs) -> Bool {
      switch frequency {
      case .onlyOnce where storage.checkIfUserHaveSeen(surveyWithID: surveyId):
        Qualaroo.log("""
          Not showing survey with id: \(surveyId).
          User have already seen this survey, and it should be seen only once.
          """)
        return false
      case .untilAnswered where storage.checkIfUserHaveFinished(surveyWithID: surveyId):
        Qualaroo.log("""
          Not showing survey with id: \(surveyId).
          User have already finished this survey, \
          and it should be displayed only for user which didn't finish it.
          """)
        return false
      default:
        return true
      }
    
  }
}

extension OpeningFilter: FilterProtocol {
  func shouldShow(survey: Survey) -> Bool {
    return shouldShowSurvey(withId: survey.surveyId,
                            frequency: survey.requireMap.revealSpecs)
  }
}
