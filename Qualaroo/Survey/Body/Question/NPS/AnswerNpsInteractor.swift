//
//  AnswerNpsInteractor.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import Foundation

class AnswerNpsInteractor {
  
  private let responseBuilder: SingleSelectionAnswerResponseBuilder
  private let validator: AnswerNpsValidator
  private weak var buttonHandler: SurveyButtonHandler?
  private weak var answerHandler: SurveyAnswerHandler?
  private let question: Question
  
  init(responseBuilder: SingleSelectionAnswerResponseBuilder,
       validator: AnswerNpsValidator,
       buttonHandler: SurveyButtonHandler,
       answerHandler: SurveyAnswerHandler,
       question: Question) {
    self.responseBuilder = responseBuilder
    self.validator = validator
    self.buttonHandler = buttonHandler
    self.answerHandler = answerHandler
    self.question = question
    buttonHandler.disableButton()
  }
  
  func setAnswer(_ selectedIndex: Int) {
    validateAnswer(selectedIndex)
    passResponse(selectedIndex)
    conductTransitionIfNeeded()
  }
  private func validateAnswer(_ selectedIndex: Int) {
    let isValid = validator.isValid(selectedId: selectedIndex)
    if isValid {
      buttonHandler?.enableButton()
    } else {
      buttonHandler?.disableButton()
    }
  }
  private func passResponse(_ selectedIndex: Int) {
    guard let response = responseBuilder.response(selectedIndex: selectedIndex) else { return }
    answerHandler?.answerChanged(response)
  }
  private func conductTransitionIfNeeded() {
    if question.shouldShowButton == false {
      answerHandler?.goToNextNode()
    }
  }
}
