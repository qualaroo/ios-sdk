//
//  AnswerListValidatorSpec.swift
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

class AnswerListValidatorSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("AnswerListValidator") {
      it("should always return true if question is not required") {
        let dict = JsonLibrary.question(type: "checkbox",
                                        answerList: [JsonLibrary.answer()],
                                        isRequired: false)
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerListValidator(question: question)
        var isValid = validator.isValid(idsAndTexts: [(1, "1")])
        expect(isValid).to(beTrue())
        isValid = validator.isValid(idsAndTexts: [])
        expect(isValid).to(beTrue())
      }
      it("should return true for non-empty answer if question is required") {
        let dict = JsonLibrary.question(type: "checkbox",
                                        answerList: [JsonLibrary.answer()],
                                        isRequired: true)
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerListValidator(question: question)
        let isValid = validator.isValid(idsAndTexts: [(1, "1")])
        expect(isValid).to(beTrue())
      }
      it("should return false for empty answer if question is required") {
        let dict = JsonLibrary.question(type: "checkbox",
                                        answerList: [JsonLibrary.answer()],
                                        isRequired: true)
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerListValidator(question: question)
        let isValid = validator.isValid(idsAndTexts: [])
        expect(isValid).to(beFalse())
      }
    }
  }
}
