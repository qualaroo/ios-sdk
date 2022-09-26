//
//  AnswerTextResponseBuilderSpec.swift
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

class AnswerTextResponseBuilderSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("AnswerTextResponseBuilder") {
      it("returns wrapped response from text") {
        let question = try! QuestionFactory(with: JsonLibrary.question(id: 1, type: "text")).build()
        let builder = AnswerTextResponseBuilder(question: question)
        let response = builder.response(text: "test")
        let answer = AnswerResponse(id: nil,
                                    alias: "text",
                                    text: "test")
        let model = QuestionResponse(id: 1,
                                        alias: nil,
                                        answerList: [answer])
        let properResponse = NodeResponse.question(model)
        expect(response).to(equal(properResponse))
      }
    }
  }
}
