//
//  ActiveFilter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class ActiveFilter {
  
  private func shouldDisplay(isActive: Bool,
                             surveyId: Int) -> Bool {
    if !isActive {
      Qualaroo.log("""
        Not showing survey with id: \(surveyId).
        Survey should be activated first on dashboard.
        """)
    }
    return isActive
  }
}

extension ActiveFilter: FilterProtocol {
  func shouldShow(survey: Survey) -> Bool {
    return shouldDisplay(isActive: survey.isActive, surveyId: survey.surveyId)
  }
}
