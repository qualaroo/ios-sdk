//
//  Answer.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

typealias AnswerId = Int64

class AnswerFactory {
  
  let dictionary: [String: Any]
  
  init(with dictionary: [String: Any]) {
    self.dictionary = dictionary
  }
  
  func build() throws -> Answer {
  return Answer(answerId: try answerId(),
                alias: alias(),
                title: try title(),
                nextNodeId: nextNodeId(),
                isFreeformCommentAllowed: hasFreeformField())
  }
  
  private func answerId() throws -> AnswerId {
    guard let id = (dictionary["id"] as? NSNumber) as? AnswerId else {
      throw AnswerError.missingOrWrongId
    }
    return id
  }
  
  private func alias() -> String? {
    return dictionary["alias"] as? String
  }
  
  private func title() throws -> String {
    guard let title = dictionary["title"] as? String else {
      throw AnswerError.missingOrWrongTitle
    }
    return title
  }
  
  private func nextNodeId() -> NodeId? {
    let nextMap = dictionary["next_map"] as? [String: Any]
    return (nextMap?["id"] as? NSNumber) as? NodeId
  }
  
  private func hasFreeformField() -> Bool {
    if let explainTypeKey = dictionary["explain_type"] as? String {
      return !explainTypeKey.isEmpty
    }
    return false
  }
  
}

enum AnswerError: Int, QualarooError {
  case missingOrWrongId = 1
  case missingOrWrongTitle = 2
}

struct Answer {
  
  let answerId: AnswerId
  let alias: String?
  let title: String
  let nextNodeId: NodeId?
  let isFreeformCommentAllowed: Bool
  
}

extension Answer: Equatable {
  static func == (lhs: Answer, rhs: Answer) -> Bool {
    return lhs.answerId == rhs.answerId &&
           lhs.title == rhs.title &&
           lhs.nextNodeId == rhs.nextNodeId &&
           lhs.isFreeformCommentAllowed == rhs.isFreeformCommentAllowed
  }
}
