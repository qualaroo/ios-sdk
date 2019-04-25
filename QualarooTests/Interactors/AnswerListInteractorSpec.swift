//
//  AnswerListInteractorSpec.swift
//  QualarooTests
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import Quick
import Nimble
@testable import Qualaroo

class AnswerListInteractorSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("AnswerListInteractor") {
      var builder: AnswerListResponseBuilder!
      var validator: AnswerListValidator!
      var buttonHandler: SurveyPresenterMock!
      var answerHandler: SurveyInteractorMock!
      var interactor: AnswerListInteractor!
      var questionDict: [String: Any]!
      beforeEach {
        let answerList = [JsonLibrary.answer(id: 111),
                          JsonLibrary.answer(id: 222)]
        questionDict = JsonLibrary.question(type: "radio",
                                            answerList: answerList)
        let question = try! QuestionFactory(with: questionDict).build()
        builder = AnswerListResponseBuilder(question: question)
        validator = AnswerListValidator(question: question)
        buttonHandler = SurveyPresenterMock()
        answerHandler = SurveyInteractorMock()
        interactor = AnswerListInteractor(responseBuilder: builder,
                                          validator: validator,
                                          buttonHandler: buttonHandler,
                                          answerHandler: answerHandler,
                                          question: question)
      }
      it("starts with button disabled") {
        expect(buttonHandler.disableButtonFlag).to(beTrue())
      }
      it("enable button if gets valid answer") {
        expect(buttonHandler.enableButtonFlag).to(beFalse())
        let answer: (Int, String?) = (0, nil)
        interactor.setAnswer([answer])
        expect(buttonHandler.enableButtonFlag).to(beTrue())
      }
      it("disable button if gets invalid answer") {
        buttonHandler.disableButtonFlag = false
        interactor.setAnswer([])
        expect(buttonHandler.disableButtonFlag).to(beTrue())
      }
      it("passes answer to handler") {
        expect(answerHandler.answerChangedValue).to(beNil())
        let answer: (Int, String?) = (0, nil)
        interactor.setAnswer([answer])
        let answerModel = AnswerResponse(id: 111,
                                    alias: nil,
                                    text: nil)
        let model = QuestionResponse(id: 1,
                                     alias: nil,
                                     answerList: [answerModel])
        let response = NodeResponse.question(model)
        expect(answerHandler.answerChangedValue).to(equal(response))
      }
      it("not passing non-existing answer") {
        expect(answerHandler.answerChangedValue).to(beNil())
        let answer: (Int, String?) = (3, nil)
        interactor.setAnswer([answer])
        expect(answerHandler.answerChangedValue).to(beNil())
      }
      it("doesn't try to show next node if there is 'Next' button") {
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
        interactor.setAnswer([(0, nil)])
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
      }
      it("tries to show next node if there is no 'Next' button") {
        questionDict["always_show_send"] = false
        let question = try! QuestionFactory(with: questionDict).build()
        builder = AnswerListResponseBuilder(question: question)
        validator = AnswerListValidator(question: question)
        interactor = AnswerListInteractor(responseBuilder: builder,
                                          validator: validator,
                                          buttonHandler: buttonHandler,
                                          answerHandler: answerHandler,
                                          question: question)
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
        interactor.setAnswer([(0, nil)])
        expect(answerHandler.goToNextNodeFlag).to(beTrue())
      }
    }
  }
}
