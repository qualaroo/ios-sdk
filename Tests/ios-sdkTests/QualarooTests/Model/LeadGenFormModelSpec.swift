//
//  LeadGenFormModelSpec.swift
//  Qualaroo
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

class LeadGenFormModelSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("LeadGenForm") {
      context("equatable") {
        it("isn't equal to another form if have different description") {
          let first = JsonLibrary.leadGenForm(id: 2, description: "text1")
          let second = JsonLibrary.leadGenForm(id: 2, description: "text2")

          let firstForm = try! LeadGenFormFactory(with: first).build()
          let secondForm = try! LeadGenFormFactory(with: second).build()
          expect(firstForm).notTo(equal(secondForm))
        }
        it("isn't equal to another form if have different ID") {
          let first = JsonLibrary.leadGenForm(id: 1, description: "text1")
          let second = JsonLibrary.leadGenForm(id: 2, description: "text1")

          let firstForm = try! LeadGenFormFactory(with: first).build()
          let secondForm = try! LeadGenFormFactory(with: second).build()
          
          expect(firstForm).notTo(equal(secondForm))
        }
        it("is equal to another form if have the same ID and description") {
          let dict = JsonLibrary.leadGenForm(id: 1, description: "text1")
          
          let firstForm = try! LeadGenFormFactory(with: dict).build()
          let secondForm = try! LeadGenFormFactory(with: dict).build()
          
          expect(firstForm).to(equal(secondForm))
        }
      }
      context("init") {
        it("it is created from proper dict") {
          let dict = JsonLibrary.leadGenForm(id: 11,
                                             description: "test",
                                             sendText: "Send",
                                             nextMap: ["id": 12],
                                             questionIdList: [1, 2, 3])
          let factory = LeadGenFormFactory(with: dict)
          let questions = [try! QuestionFactory(with: JsonLibrary.question(id: 1)).build(),
                           try! QuestionFactory(with: JsonLibrary.question(id: 2)).build(),
                           try! QuestionFactory(with: JsonLibrary.question(id: 3)).build()]
          try! factory.inject(questions)
          
          let form = try! factory.build()
          
          expect(form.leadGenFormId).to(equal(11))
          expect(form.description).to(equal("test"))
          expect(form.questionList).to(equal(questions))
          expect(form.buttonText).to(equal("Send"))
          expect(form.nextNodeId).to(equal(12))
        }
        it("throws error when creating without id") {
          let dict = JsonLibrary.leadGenForm(id: nil)
          let factory = LeadGenFormFactory(with: dict)
          
          expect { try factory.build() }.to(throwError())
        }
        it("is created with empty description when there is none") {
          let dict = JsonLibrary.leadGenForm(description: nil)
          
          let form = try! LeadGenFormFactory(with: dict).build()
          
          expect(form.description).to(equal(""))
        }
        it("throws error when creating without question list") {
          let dict = JsonLibrary.leadGenForm(questionIdList: nil)
          let factory = LeadGenFormFactory(with: dict)
          
          expect { try factory.build() }.to(throwError())
        }
        it("throws error when there is no matching question while injecting") {
          let dict = JsonLibrary.leadGenForm(questionIdList: [1, 2, 3])
          let factory = LeadGenFormFactory(with: dict)
          let questions = [try! QuestionFactory(with: JsonLibrary.question(id: 1)).build(),
                           try! QuestionFactory(with: JsonLibrary.question(id: 2)).build()]
          
          expect { try factory.inject(questions) }.to(throwError())
        }
        it("throws error when there is no questions while building") {
          let dict = JsonLibrary.leadGenForm(questionIdList: [1, 2, 3])
          let factory = LeadGenFormFactory(with: dict)
          
          expect { try factory.build() }.to(throwError())
        }
      }
    }
  }
}
