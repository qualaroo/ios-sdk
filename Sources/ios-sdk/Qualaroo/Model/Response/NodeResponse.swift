//
//  NodeResponse.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

enum NodeResponse {
  case leadGen(LeadGenResponse)
  case question(QuestionResponse)
}

extension NodeResponse: Equatable {
  static func == (lhs: NodeResponse, rhs: NodeResponse) -> Bool {
    switch (lhs, rhs) {
    case (.leadGen(let responseOne), .leadGen(let responseTwo)):
      return responseOne == responseTwo
    case (.question(let responseOne), .question(let responseTwo)):
      return responseOne == responseTwo
    default:
      return false
    }
  }
}
