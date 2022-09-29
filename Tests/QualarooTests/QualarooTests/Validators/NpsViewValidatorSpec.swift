//
//  AnswerNpsValidatorSpec.swift
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

class AnswerNpsValidatorSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("AnswerNpsValidator") {
      it("passes if question is not required") {
        let dict = JsonLibrary.question(type: "text",
                                        isRequired: false)
        
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerNpsValidator(question: question)
          var isValid = validator.isValid(selectedId: UISegmentedControl.noSegment)
        expect(isValid).to(beTrue())
        isValid = validator.isValid(selectedId: 1)
        expect(isValid).to(beTrue())
      }
      it("passes for non-empty answer if question is required") {
        let answers = [JsonLibrary.answer(), JsonLibrary.answer()]
        let dict = JsonLibrary.question(type: "dropdown",
                                        answerList: answers,
                                        isRequired: true)
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerNpsValidator(question: question)
        let isValid = validator.isValid(selectedId: 1)
        expect(isValid).to(beTrue())
      }
      it("failing for answer out of range if question is required") {
        let answers = [JsonLibrary.answer(), JsonLibrary.answer()]
        let dict = JsonLibrary.question(type: "dropdown",
                                        answerList: answers,
                                        isRequired: true)
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerNpsValidator(question: question)
        let isValid = validator.isValid(selectedId: 2)
        expect(isValid).to(beFalse())
      }
      it("failing for empty answer if question is required") {
        let dict = JsonLibrary.question(type: "text",
                                        isRequired: true)
        let question = try! QuestionFactory(with: dict).build()
        let validator = AnswerNpsValidator(question: question)
          let isValid = validator.isValid(selectedId: UISegmentedControl.noSegment)
        expect(isValid).to(beFalse())
      }
    }
  }
}
