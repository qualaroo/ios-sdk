//
//  AnswerBinaryInteractor.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import Foundation

class AnswerBinaryInteractor {
  
  private let responseBuilder: SingleSelectionAnswerResponseBuilder
  private weak var answerHandler: SurveyAnswerHandler?

  init(responseBuilder: SingleSelectionAnswerResponseBuilder,
       answerHandler: SurveyAnswerHandler) {
    self.responseBuilder = responseBuilder
    self.answerHandler = answerHandler
  }

  func selectLeftAnswer() {
    setAnswer(0)
  }
  
  func selectRightAnswer() {
    setAnswer(1)
  }

  private func setAnswer(_ selectedIndex: Int) {
    guard let response = responseBuilder.response(selectedIndex: selectedIndex) else {
      return
    }
    answerHandler?.answerChanged(response)
    answerHandler?.goToNextNode()
  }
}
