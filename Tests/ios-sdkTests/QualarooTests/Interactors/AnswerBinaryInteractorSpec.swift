//
//  AnswerBinaryInteractorSpec.swift
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

class AnswerBinaryInteractorSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("AnswerBinaryInteractor") {
      var interactor: AnswerBinaryInteractor!
      var builder: SingleSelectionAnswerResponseBuilder!
      var answerHandler: SurveyInteractorMock!
      beforeEach {
        let answers = [JsonLibrary.answer(id: 5),
                       JsonLibrary.answer(id: 9)]
        let question = try! QuestionFactory(with: JsonLibrary.question(id: 1,
                                                                       type: "binary",
                                                                       answerList: answers)).build()
        builder = SingleSelectionAnswerResponseBuilder(question: question)
        answerHandler = SurveyInteractorMock()
        interactor = AnswerBinaryInteractor(responseBuilder: builder,
                                            answerHandler: answerHandler)
      }
      it("passes first answer on selecting left button") {
        interactor.selectLeftAnswer()
        let response = answerHandler.answerChangedValue
        let answer = AnswerResponse(id: 5,
                                    alias: nil,
                                    text: nil)
        let model = QuestionResponse(id: 1,
                                     alias: nil,
                                     answerList: [answer])
        expect(response).to(equal(NodeResponse.question(model)))
      }
      it("passes second answer on selecting left button") {
        interactor.selectRightAnswer()
        let response = answerHandler.answerChangedValue
        let answer = AnswerResponse(id: 9,
                                    alias: nil,
                                    text: nil)
        let model = QuestionResponse(id: 1,
                                     alias: nil,
                                     answerList: [answer])
        expect(response).to(equal(NodeResponse.question(model)))
      }
      it("is not sending response if there is no such answer") {
        let answers = [JsonLibrary.answer(id: 5),
                       JsonLibrary.answer(id: 9)]
        let question = try! QuestionFactory(with: JsonLibrary.question(type: "binary",
                                                                       answerList: answers)).build()
        builder = SingleSelectionAnswerResponseBuilderMock(question: question)
        answerHandler = SurveyInteractorMock()
        interactor = AnswerBinaryInteractor(responseBuilder: builder,
                                            answerHandler: answerHandler)
        interactor.selectRightAnswer()
        expect(answerHandler.answerChangedValue).to(beNil())
        expect(answerHandler.goToNextNodeFlag).to(beFalse())
      }
        it("tries to show next node on selecting first button") {
        interactor.selectLeftAnswer()
        expect(answerHandler.goToNextNodeFlag).to(beTrue())
      }
      it("tries to show next node on selecting second button") {
        interactor.selectRightAnswer()
        expect(answerHandler.goToNextNodeFlag).to(beTrue())
      }
    }
  }
}
