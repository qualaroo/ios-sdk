//
//  LeadGenResponse.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

struct LeadGenResponse {
  let id: NodeId
  let alias: String?
  let questionList: [QuestionResponse]
}

extension LeadGenResponse: Equatable {
  static func == (lhs: LeadGenResponse, rhs: LeadGenResponse) -> Bool {
    return lhs.id == rhs.id &&
           lhs.alias == rhs.alias &&
           lhs.questionList == rhs.questionList
  }
}
