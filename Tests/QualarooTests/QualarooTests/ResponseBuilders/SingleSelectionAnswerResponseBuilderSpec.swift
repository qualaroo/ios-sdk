//
//  SingleSelectionAnswerResponseBuilderSpec.swift
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

class SingleSelectionAnswerResponseBuilderSpec: QuickSpec {
  override func spec() {
    super.spec()
  
    describe("SingleSelectionAnswerResponseBuilder") {
      var builder: SingleSelectionAnswerResponseBuilder!
      beforeEach {
        let answerOne = JsonLibrary.answer(id: 11)
        let answerTwo = JsonLibrary.answer(id: 22)
        let dict = JsonLibrary.question(id: 1,
                                        alias: "alias",
                                        type: "dropdown",
                                        answerList: [answerOne, answerTwo])
        let question = try! QuestionFactory(with: dict).build()
        builder = SingleSelectionAnswerResponseBuilder(question: question)
      }
      context("creating response") {
        it("creates proper one when index is in range") {
          let answer = AnswerResponse(id: 11, alias: nil, text: nil)
          let model = QuestionResponse(id: 1, alias: "alias", answerList: [answer])
          let properResponse = NodeResponse.question(model)
          
          let response = builder.response(selectedIndex: 0)
          
          expect(response).to(equal(properResponse))
        }
        it("returns nil if index is out of range") {
          let response = builder.response(selectedIndex: 3)
          
          expect(response).to(beNil())
        }
      }
    }
  }
}
