//
//  AnswerTextResponseBuilder.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

class AnswerTextResponseBuilder: AbstractAnswerResponseBuilder {
  func response(text: String) -> NodeResponse {
    let answer = AnswerResponse(id: nil,
                                alias: "text",
                                text: text)
    let model = QuestionResponse(id: question.questionId,
                                 alias: question.alias,
                                 answerList: [answer])
    return NodeResponse.question(model)
  }
}
