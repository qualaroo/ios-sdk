//
//  AnswerTextInteractor.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import Foundation

class AnswerTextInteractor {
  
  private let responseBuilder: AnswerTextResponseBuilder
  private let validator: AnswerTextValidator
  private weak var buttonHandler: SurveyButtonHandler?
  private weak var answerHandler: SurveyAnswerHandler?
  
  init(responseBuilder: AnswerTextResponseBuilder,
       validator: AnswerTextValidator,
       buttonHandler: SurveyButtonHandler,
       answerHandler: SurveyAnswerHandler) {
    self.responseBuilder = responseBuilder
    self.validator = validator
    self.buttonHandler = buttonHandler
    self.answerHandler = answerHandler
    validateAnswer("")
  }
  
  private func validateAnswer(_ text: String) {
    let isValid = validator.isValid(text: text)
    if isValid {
      buttonHandler?.enableButton()
    } else {
      buttonHandler?.disableButton()
    }
  }

  func setAnswer(_ text: String) {
    validateAnswer(text)
    let response = responseBuilder.response(text: text)
    answerHandler?.answerChanged(response)
  }
}
