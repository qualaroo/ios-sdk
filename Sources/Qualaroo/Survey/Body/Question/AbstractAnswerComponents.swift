//
//  AbstractAnswerComponents.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class AbstractAnswerViewValidator {
  let question: Question
  init(question: Question) {
    self.question = question
  }
}

class AbstractAnswerResponseBuilder {
  let question: Question
  init(question: Question) {
    self.question = question
  }

  func answerId(forIndex index: Int) -> AnswerId? {
    return question.answerList[safe: index]?.answerId
  }
  func answerAlias(forIndex index: Int) -> String? {
    return question.answerList[safe: index]?.alias
  }
}

class SingleSelectionAnswerResponseBuilder: AbstractAnswerResponseBuilder {
  func response(selectedIndex: Int) -> NodeResponse? {
    guard let id = answerId(forIndex: selectedIndex) else { return nil }
    let alias = answerAlias(forIndex: selectedIndex)
    let answer = AnswerResponse(id: id, alias: alias, text: nil)
    let model = QuestionResponse(id: question.questionId,
                                 alias: question.alias,
                                 answerList: [answer])
    return NodeResponse.question(model)
  }
}
