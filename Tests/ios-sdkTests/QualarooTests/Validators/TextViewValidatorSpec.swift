//
//  AnswerTextValidatorSpec.swift
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

class AnswerTextValidatorSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("AnswerTextValidator") {
      it("should always return true if question is not required") {
        let dict = JsonLibrary.question(type: "text",
                                        isRequired: false)
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerTextValidator(question: question)
        var isValid = validator.isValid(text: "text")
        expect(isValid).to(beTrue())
        isValid = validator.isValid(text: "")
        expect(isValid).to(beTrue())
      }
      it("should return true for non-empty answer if question is required") {
        let dict = JsonLibrary.question(type: "text",
                                        isRequired: true)
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerTextValidator(question: question)
        let isValid = validator.isValid(text: "text")
        expect(isValid).to(beTrue())
      }
      it("should return false for empty answer if question is required") {
        let dict = JsonLibrary.question(type: "text",
                                        isRequired: true)
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerTextValidator(question: question)
        let isValid = validator.isValid(text: "")
        expect(isValid).to(beFalse())
      }
    }
  }
}
