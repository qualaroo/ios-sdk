//
//  AnswerListResponseBuilder.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

typealias ListSelection = (index: Int, text: String?)

class AnswerListResponseBuilder: AbstractAnswerResponseBuilder {
  func response(idsAndTexts: [(Int, String?)]) -> NodeResponse? {
    let answers = idsAndTexts.map { answer($0) }
    if answers.contains(where: { $0 == nil }) {
      return nil
    }
    let model = QuestionResponse(id: question.questionId,
                                 alias: question.alias,
                                 answerList: answers.removeNils())
    return NodeResponse.question(model)
  }
  private func answer(_ selection: ListSelection) -> AnswerResponse? {
    guard let answerIndex = answerId(forIndex: selection.index) else { return nil }
    let alias = answerAlias(forIndex: selection.index)
    return AnswerResponse(id: answerIndex,
                          alias: alias,
                          text: selection.text)
  }
}
