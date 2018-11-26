//
//  LeadGenFormInteractor.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import Foundation

class LeadGenFormInteractor {
  
  let responseBuilder: LeadGenFormResponseBuilder
  let validator: LeadGenFormValidator
  private weak var answerHandler: SurveyAnswerHandler?
  private weak var buttonHandler: SurveyButtonHandler?

  init(responseBuilder: LeadGenFormResponseBuilder,
       validator: LeadGenFormValidator,
       buttonHandler: SurveyButtonHandler,
       answerHandler: SurveyAnswerHandler) {
    self.responseBuilder = responseBuilder
    self.validator = validator
    self.answerHandler = answerHandler
    self.buttonHandler = buttonHandler
  }
  
  func lastAnswerWasFilled() {
    answerHandler?.goToNextNode()
  }
  
  func answerChanged(_ answers: [String]) {
    validateAnswers(answers)
    passResponse(answers)
  }
  private func validateAnswers(_ answers: [String]) {
    if validator.isValid(with: answers) {
      buttonHandler?.enableButton()
    } else {
      buttonHandler?.disableButton()
    }
  }
  private func passResponse(_ answers: [String]) {
    guard let response = responseBuilder.response(with: answers) else { return }
    answerHandler?.answerChanged(response)
  }
}
