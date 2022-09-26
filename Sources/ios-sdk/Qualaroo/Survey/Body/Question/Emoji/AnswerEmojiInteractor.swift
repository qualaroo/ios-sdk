//
//  AnswerEmojiInteractor.swift
//  Qualaroo
//
//  Created by user181179 on 10/7/21.
//  Copyright © 2021 Mihály Papp. All rights reserved.
//

import UIKit


class AnswerEmojiInteractor {
  
  private let responseBuilder: SingleSelectionAnswerResponseBuilder
  private weak var answerHandler: SurveyAnswerHandler?

  init(responseBuilder: SingleSelectionAnswerResponseBuilder,
       answerHandler: SurveyAnswerHandler) {
    self.responseBuilder = responseBuilder
    self.answerHandler = answerHandler
  }

  func selectFirstEmoji() {
    setAnswer(0)
  }
    
  func selectSecondEmoji() {
    setAnswer(1)
  }
  
  func selectThirdEmoji() {
    setAnswer(2)
  }
    
  func selectFourthEmoji() {
    setAnswer(3)
  }
    
  func selectFifthEmoji() {
    setAnswer(4)
  }

  private func setAnswer(_ selectedIndex: Int) {
      NSLog("selected Index:%d",  selectedIndex);
    guard let response = responseBuilder.response(selectedIndex: selectedIndex) else {
      return
    }
    answerHandler?.answerChanged(response)
    answerHandler?.goToNextNode()
  }
}
