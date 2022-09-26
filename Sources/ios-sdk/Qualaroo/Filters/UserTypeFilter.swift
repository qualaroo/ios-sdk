//
//  UserTypeFilter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

class UserTypeFilter {
  
  let clientId: String?
  
  init(clientId: String?) {
    self.clientId = clientId
  }
  
  private func shouldDisplay(forTargetType targetType: RequireMap.UserTargetType,
                             clientId: String?,
                             surveyId: Int) -> Bool {
    switch targetType {
    case .known where clientId == nil:
      Qualaroo.log("""
        Not showing survey with id: \(surveyId).
        Survey should be displayed only for known users.
        """)
      return false
    case .unknown where clientId != nil:
      Qualaroo.log("""
        Not showing survey with id: \(surveyId).
        Survey should be displayed only for unknown users.
        """)
      return false
    default:
      return true
    }
  }
}

extension UserTypeFilter: FilterProtocol {
  func shouldShow(survey: Survey) -> Bool {
    return shouldDisplay(forTargetType: survey.requireMap.targetUser,
                         clientId: clientId,
                         surveyId: survey.surveyId)
  }
}
