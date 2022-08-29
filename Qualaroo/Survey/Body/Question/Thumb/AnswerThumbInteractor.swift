//
//  AnswerThumbInteractor.swift
//  Qualaroo
//
//  Created by Ajay Mandrawal on 09/06/22.
//  Copyright © 2022 Mihály Papp. All rights reserved.
//

import Foundation

class AnswerThumbInteractor {
    private let responseBuilder: SingleSelectionAnswerResponseBuilder
    private weak var answerHandler: SurveyAnswerHandler?

    init(responseBuilder: SingleSelectionAnswerResponseBuilder,
         answerHandler: SurveyAnswerHandler) {
      self.responseBuilder = responseBuilder
      self.answerHandler = answerHandler
    }

    func selectThumbUp() {
      setAnswer(0)
    }
      
    func selectThumbDown() {
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
