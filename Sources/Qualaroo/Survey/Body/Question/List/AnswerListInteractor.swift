//
//  AnswerListInteractor.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class AnswerListInteractor {

  private let responseBuilder: AnswerListResponseBuilder
  private let validator: AnswerListValidator
  private weak var buttonHandler: SurveyButtonHandler?
  private weak var answerHandler: SurveyAnswerHandler?
  private let question: Question

  init(responseBuilder: AnswerListResponseBuilder,
       validator: AnswerListValidator,
       buttonHandler: SurveyButtonHandler,
       answerHandler: SurveyAnswerHandler,
       question: Question) {
    self.responseBuilder = responseBuilder
    self.validator = validator
    self.buttonHandler = buttonHandler
    self.answerHandler = answerHandler
    self.question = question
    validateAnswer([])
  }
  
  @discardableResult private func validateAnswer(_ idsAndTexts: [(Int, String?)]) -> Bool {
    let isValid = validator.isValid(idsAndTexts: idsAndTexts)
    if isValid {
      buttonHandler?.enableButton()
    } else {
      buttonHandler?.disableButton()
    }
    return isValid
  }

  func setAnswer(_ answers: [(Int, String?)]) {
    let isValid = validateAnswer(answers)
    if !isValid {
      return
    }
    passAnswer(answers)
    conductTransitionIfNeeded()
  }
  private func passAnswer(_ answers: [(Int, String?)]) {
    guard let response = responseBuilder.response(idsAndTexts: answers) else { return }
    answerHandler?.answerChanged(response)
  }
  private func conductTransitionIfNeeded() {
    if question.shouldShowButton == false {
      answerHandler?.goToNextNode()
    }
  }
}
