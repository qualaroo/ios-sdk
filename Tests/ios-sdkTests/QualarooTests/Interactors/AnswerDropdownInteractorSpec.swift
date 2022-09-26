//
//  AnswerDropdownInteractorSpec.swift
//  QualarooTests
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

inport UIKit
import Quick
import Nimble
@testable import Qualaroo

class AnswerDropdownInteractorSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("AnswerDropdownInteractor") {
      var builder: SingleSelectionAnswerResponseBuilder!
      var buttonHandler: SurveyPresenterMock!
      var answerHandler: SurveyInteractorMock!
      var interactor: AnswerDropdownInteractor!
      var questionDict: [String: Any]!
      beforeEach {
        let answerList = [JsonLibrary.answer(id: 111),
                          JsonLibrary.answer(id: 222)]
        questionDict = JsonLibrary.question(type: "dropdown",
                                            answerList: answerList)
        let question = try! QuestionFactory(with: questionDict).build()
        builder = SingleSelectionAnswerResponseBuilder(question: question)
        buttonHandler = SurveyPresenterMock()
        answerHandler = SurveyInteractorMock()
        interactor = AnswerDropdownInteractor(responseBuilder: builder,
                                              buttonHandler: buttonHandler,
                                              answerHandler: answerHandler,
                                              question: question)
      }
      it("always have button enabled") {
        expect(buttonHandler.enableButtonFlag).to(beTrue())
      }
      it("passes answer to handler") {
        expect(answerHandler.answerChangedValue).to(beNil())
        interactor.setAnswer(0)
        let answer = AnswerResponse(id: 111,
                                    alias: nil,
                                    text: nil)
        let model = QuestionResponse(id: 1,
                                     alias: nil,
                                     answerList: [answer])
        let response = NodeResponse.question(model)
        expect(answerHandler.answerChangedValue).to(equal(response))
      }
      it("is not passing non-existing answer") {
        expect(answerHandler.answerChangedValue).to(beNil())
        interactor.setAnswer(3)
        expect(answerHandler.answerChangedValue).to(beNil())
      }
      it("doesn't try to show next node if there is 'Next' button") {
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
        interactor.setAnswer(0)
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
      }
      it("tries to show next node if there is no 'Next' button") {
        questionDict["always_show_send"] = false
        let question = try! QuestionFactory(with: questionDict).build()
        builder = SingleSelectionAnswerResponseBuilder(question: question)
        interactor = AnswerDropdownInteractor(responseBuilder: builder,
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
