//
//  AnswerListResponseBuilderSpec.swift
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

class AnswerListResponseBuilderSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("AnswerListResponseBuilder") {
      var builder: AnswerListResponseBuilder!
      beforeEach {
        let answerOne = JsonLibrary.answer(id: 11)
        let answerTwo = JsonLibrary.answer(id: 22)
        let dict = JsonLibrary.question(id: 1,
                                            alias: "alias",
                                            type: "radio",
                                            answerList: [answerOne, answerTwo])
        let question = try! QuestionFactory(with: dict).build()
        builder = AnswerListResponseBuilder(question: question)
      }
      context("creates response") {
        it("creates response with no option selected") {
          let model = QuestionResponse(id: 1,
                                       alias: "alias",
                                       answerList: [])
          let properResponse = NodeResponse.question(model)
          
          let response = builder.response(idsAndTexts: [])
          
          expect(response).to(equal(properResponse))
        }
        it("creates response with few options selected") {
          let answerOne = AnswerResponse(id: 11,
                                         alias: nil,
                                         text: "text1")
          let answerTwo = AnswerResponse(id: 22,
                                         alias: nil,
                                         text: "text2")
          let model = QuestionResponse(id: 1,
                                       alias: "alias",
                                       answerList: [answerOne, answerTwo])
          let properResponse = NodeResponse.question(model)
          
          let response = builder.response(idsAndTexts: [(0, "text1"), (1, "text2")])
          
          expect(response).to(equal(properResponse))
        }
        it("returns nil when one of selected option is out of range") {
          let response = builder.response(idsAndTexts: [(3, "text")])
          
          expect(response).to(beNil())
        }
      }
    }
  }
}
