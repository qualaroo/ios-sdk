//
//  AnswerNpsInteractorSpec.swift
//  QualarooTests
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit
import Quick
import Nimble
@testable import Qualaroo

class AnswerNpsInteractorSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("AnswerNpsInteractorSpec") {
      var interactor: AnswerNpsInteractor!
      var builder: SingleSelectionAnswerResponseBuilder!
      var validator: AnswerNpsValidator!
      var buttonHandler: SurveyPresenterMock!
      var answerHandler: SurveyInteractorMock!
      var questionDict: [String: Any]!
      beforeEach {
        let answerList = Array(repeating: JsonLibrary.answer(), count: 11)
        questionDict = JsonLibrary.question(type: "nps",
                                            answerList: answerList)
        questionDict["nps_min_label"] = "Poor"
        questionDict["nps_max_label"] = "Awesome"
        let question = try! QuestionFactory(with: questionDict).build()
        validator = AnswerNpsValidator(question: question)
        builder = SingleSelectionAnswerResponseBuilder(question: question)
        buttonHandler = SurveyPresenterMock()
        answerHandler = SurveyInteractorMock()
        interactor = AnswerNpsInteractor(responseBuilder: builder,
                                         validator: validator,
                                         buttonHandler: buttonHandler,
                                         answerHandler: answerHandler,
                                         question: question)
      }
      it("disables button when starts") {
        expect(buttonHandler.disableButtonFlag).to(beTrue())
      }
      it("enables button with valid answer") {
        expect(buttonHandler.enableButtonFlag).to(beFalse())
        interactor.setAnswer(0)
        expect(buttonHandler.enableButtonFlag).to(beTrue())
      }
      it("not enabling button with invalid answer") {
        expect(buttonHandler.enableButtonFlag).to(beFalse())
        interactor.setAnswer(50)
        expect(buttonHandler.enableButtonFlag).to(beFalse())
      }
      it("passes answer to handler") {
        expect(answerHandler.answerChangedValue).to(beNil())
        interactor.setAnswer(0)
        expect(answerHandler.answerChangedValue).notTo(beNil())
      }
      it("doesn't try to show next node if there is 'Next' button") {
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
        interactor.setAnswer(0)
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
      }
      it("tries to show next node if there is no 'Next' button") {
        questionDict["always_show_send"] = false
        let question = try! QuestionFactory(with: questionDict).build()
        validator = AnswerNpsValidator(question: question)
        builder = SingleSelectionAnswerResponseBuilder(question: question)
        interactor = AnswerNpsInteractor(responseBuilder: builder,
                                         validator: validator,
                                         buttonHandler: buttonHandler,
                                         answerHandler: answerHandler,
                                         question: question)
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
        interactor.setAnswer(0)
        expect(answerHandler.goToNextNodeFlag).to(beTrue())
      }
    }
  }
}
