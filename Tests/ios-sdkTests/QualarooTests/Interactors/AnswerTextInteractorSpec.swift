//
//  AnswerTextInteractorSpec.swift
//  QualarooTests
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit
import Quick
import Nimble
@testable import Qualaroo

class AnswerTextInteractorSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("AnswerTextInteractor") {
      var interactor: AnswerTextInteractor!
      var builder: AnswerTextResponseBuilder!
      var validator: AnswerTextValidator!
      var buttonHandler: SurveyPresenterMock!
      var answerHandler: SurveyInteractorMock!
      beforeEach {
        let question = try! QuestionFactory(with: JsonLibrary.question(type: "text")).build()
        builder = AnswerTextResponseBuilder(question: question)
        validator = AnswerTextValidator(question: question)
        buttonHandler = SurveyPresenterMock()
        answerHandler = SurveyInteractorMock()
        interactor = AnswerTextInteractor(responseBuilder: builder,
                                          validator: validator,
                                          buttonHandler: buttonHandler,
                                          answerHandler: answerHandler)
      }
      it("starts with button enabled for valid answer") {
        expect(buttonHandler.enableButtonFlag).to(beTrue())
      }
      it("starts with button disabled for required question") {
        let dict = JsonLibrary.question(type: "text",
                                        isRequired: true)
        let question = try! QuestionFactory(with: dict).build()
        builder = AnswerTextResponseBuilder(question: question)
        validator = AnswerTextValidator(question: question)
        buttonHandler = SurveyPresenterMock()
        interactor = AnswerTextInteractor(responseBuilder: builder,
                                          validator: validator,
                                          buttonHandler: buttonHandler,
                                          answerHandler: SurveyInteractorMock())
        expect(buttonHandler.disableButtonFlag).to(beTrue())
      }
      it("enables button for valid answer") {
        buttonHandler.enableButtonFlag = false
        interactor.setAnswer("valid")
        expect(buttonHandler.enableButtonFlag).to(beTrue())
      }
      it("disables button for invalid answer") {
        let dict = JsonLibrary.question(type: "text",
                                        isRequired: true)
        let question = try! QuestionFactory(with: dict).build()
        builder = AnswerTextResponseBuilder(question: question)
        validator = AnswerTextValidator(question: question)
        buttonHandler = SurveyPresenterMock()
        answerHandler = SurveyInteractorMock()
        interactor = AnswerTextInteractor(responseBuilder: builder,
                                          validator: validator,
                                          buttonHandler: buttonHandler,
                                          answerHandler: answerHandler)
        buttonHandler.disableButtonFlag = false
        interactor.setAnswer("")
        expect(buttonHandler.disableButtonFlag).to(beTrue())
      }
      it("passes answer to handler") {
        expect(answerHandler.answerChangedValue).to(beNil())
        interactor.setAnswer("test")
        expect(answerHandler.answerChangedValue).notTo(beNil())
      }
    }
  }
}
