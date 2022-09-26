//
//  LeadGenFormInteractorSpec.swift
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

class LeadGenFormInteractorSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("LeadGenFormInteractor") {
      let builder = LeadGenFormResponseBuilder(id: 1,
                                               alias: nil,
                                               items: [])
      var validator: LeadGenFormValidatorMock!
      var buttonHandler: SurveyPresenterMock!
      var answerHandler: SurveyInteractorMock!
      var interactor: LeadGenFormInteractor!
      beforeEach {
        validator = LeadGenFormValidatorMock()
        buttonHandler = SurveyPresenterMock()
        answerHandler = SurveyInteractorMock()
        interactor = LeadGenFormInteractor(responseBuilder: builder,
                                           validator: validator,
                                           buttonHandler: buttonHandler,
                                           answerHandler: answerHandler)
      }
      it("goes to next question after filling last input") {
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
        interactor.lastAnswerWasFilled()
        expect(answerHandler.goToNextNodeFlag).to(beTrue())
      }
      it("enable button if gets valid answer") {
        validator.isValidValue = true
        expect(buttonHandler.enableButtonFlag).to(beFalse())
        interactor.answerChanged([])
        expect(buttonHandler.enableButtonFlag).to(beTrue())
      }
      it("disable button if gets invalid answer") {
        validator.isValidValue = false
        expect(buttonHandler.disableButtonFlag).to(beFalse())
        interactor.answerChanged([])
        expect(buttonHandler.disableButtonFlag).to(beTrue())
      }
      it("passes empty answer to handler") {
        expect(answerHandler.answerChangedValue).to(beNil())
        let answer = [String]()
        let emptyResponse = JsonLibrary.emptyLeadGenResponse()
        interactor.answerChanged(answer)
        let sentAnswers = answerHandler.answerChangedValue!
        expect(sentAnswers).to(equal(emptyResponse))
      }
      it("passes answer to handler") {
        let item = LeadGenFormItem(questionId: 1,
                                   canonicalName: nil,
                                   questionAlias: nil,
                                   title: "title",
                                   kayboardType: UIKeyboardType.alphabet,
                                   isRequired: false)
        let builder = LeadGenFormResponseBuilder(id: 333,
                                                 alias: nil,
                                                 items: [item])
        interactor = LeadGenFormInteractor(responseBuilder: builder,
                                           validator: validator,
                                           buttonHandler: buttonHandler,
                                           answerHandler: answerHandler)
        expect(answerHandler.answerChangedValue).to(beNil())
        let answers = ["test"]
        let answer = AnswerResponse(id: nil, alias: nil, text: "test")
        let question = QuestionResponse(id: 1, alias: nil, answerList: [answer])
        let model = LeadGenResponse(id: 333, alias: nil, questionList: [question])
        interactor.answerChanged(answers)
        let sentAnswers = answerHandler.answerChangedValue!
        expect(sentAnswers).to(equal(NodeResponse.leadGen(model)))
      }
      it("not passing answer if it is incomplete") {
        let item = LeadGenFormItem(questionId: 1,
                                   canonicalName: nil,
                                   questionAlias: nil,
                                   title: "title",
                                   kayboardType: UIKeyboardType.alphabet,
                                   isRequired: false)
        let builder = LeadGenFormResponseBuilder(id: 1,
                                                 alias: nil,
                                                 items: [item])
        interactor = LeadGenFormInteractor(responseBuilder: builder,
                                           validator: validator,
                                           buttonHandler: buttonHandler,
                                           answerHandler: answerHandler)
        expect(answerHandler.answerChangedValue).to(beNil())
        let answer = ["test", "test2"]
        interactor.answerChanged(answer)
        expect(answerHandler.answerChangedValue).to(beNil())
      }
    }
  }
}
