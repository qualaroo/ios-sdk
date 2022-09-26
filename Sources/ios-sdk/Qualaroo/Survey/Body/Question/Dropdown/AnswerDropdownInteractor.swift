//
//  AnswerDropdownInteractor.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class AnswerDropdownInteractor {
  
  private let responseBuilder: SingleSelectionAnswerResponseBuilder
  private weak var answerHandler: SurveyAnswerHandler?
  private let question: Question

  init(responseBuilder: SingleSelectionAnswerResponseBuilder,
       buttonHandler: SurveyButtonHandler,
       answerHandler: SurveyAnswerHandler,
       question: Question) {
    self.responseBuilder = responseBuilder
    self.answerHandler = answerHandler
    self.question = question
    buttonHandler.enableButton()
  }
  
  func setAnswer(_ selectedIndex: Int) {
    passAnswer(selectedIndex)
    conductTransitionIfNeeded()
  }
  private func passAnswer(_ selectedIndex: Int) {
    guard let response = responseBuilder.response(selectedIndex: selectedIndex) else { return }
    answerHandler?.answerChanged(response)
  }
  private func conductTransitionIfNeeded() {
    if question.shouldShowButton == false {
      answerHandler?.goToNextNode()
    }
  }
}
