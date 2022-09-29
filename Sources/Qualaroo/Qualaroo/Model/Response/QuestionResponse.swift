//
//  QuestionResponse.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

struct QuestionResponse {
  let id: NodeId
  let alias: String?
  let answerList: [AnswerResponse]
}

extension QuestionResponse: Equatable {
  static func == (lhs: QuestionResponse, rhs: QuestionResponse) -> Bool {
    return lhs.id == rhs.id &&
           lhs.alias == rhs.alias &&
           lhs.answerList == rhs.answerList
  }
}
