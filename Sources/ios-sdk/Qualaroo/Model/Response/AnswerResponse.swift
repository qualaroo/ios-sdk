//
//  AnswerResponse.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

struct AnswerResponse {
  let id: AnswerId?
  let alias: String?
  let text: String?
}

extension AnswerResponse: Equatable {
  static func == (lhs: AnswerResponse, rhs: AnswerResponse) -> Bool {
    return lhs.id == rhs.id &&
           lhs.alias == rhs.alias &&
           lhs.text == rhs.text
  }
}
