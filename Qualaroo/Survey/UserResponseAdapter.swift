//
//  UserResponseClient.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class UserResponseAdapter {
  func toUserResponse(_ response: NodeResponse) -> UserResponse? {
    switch response {
    case .leadGen(let model):
      return leadGenUserResponse(model)
    case .question(let model):
      return questionResponse(model)
    }
  }
  private func leadGenUserResponse(_ model: LeadGenResponse) -> UserResponse? {
    guard let alias = model.alias else { return nil }
    let answers = model.questionList.map { element(from: $0) }.removeNils()
    return UserResponse(questionAlias: alias, selectedAnswers: answers)
  }
  private func element(from question: QuestionResponse) -> UserResponse.UserAnswer? {
    guard let alias = question.alias,
          let answer = question.answerList.first else { return nil }
    return UserResponse.UserAnswer(answerAlias: alias, answerText: answer.text)
  }
  private func questionResponse(_ model: QuestionResponse) -> UserResponse? {
    guard let alias = model.alias else { return nil }
    let answers = model.answerList.map { element(from: $0) }.removeNils()
    return UserResponse(questionAlias: alias, selectedAnswers: answers)
  }
  
  private func element(from answer: AnswerResponse) -> UserResponse.UserAnswer? {
    guard let alias = answer.alias else { return nil }
    return UserResponse.UserAnswer(answerAlias: alias, answerText: answer.text)
  }
}
