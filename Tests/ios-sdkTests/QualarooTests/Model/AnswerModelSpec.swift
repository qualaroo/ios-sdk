//
//  AnswerModelSpec.swift
//  Qualaroo
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

class AnswerModelSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("answer initialization") {
      context("answer") {
        it("is created form good dictionary") {
          let dict = JsonLibrary.answer(id: 2, title: "Title", nextMap: ["id": 5, "node_type": "question"])
          
          let answer = try! AnswerFactory(with: dict).build()
          
          expect(answer.answerId).to(equal(2))
          expect(answer.title).to(equal("Title"))
          expect(answer.nextNodeId).to(equal(5))
        }
        it("is created form good dictionary without next map") {
          let dict = JsonLibrary.answer(id: 3, title: "Title")
          
          let answer = try! AnswerFactory(with: dict).build()
          
          expect(answer.answerId).to(equal(3))
          expect(answer.title).to(equal("Title"))
          expect(answer.nextNodeId).to(beNil())
        }
        it("is not allowing freeform when there is no \"explain_type\" key") {
          let answer = try! AnswerFactory(with: JsonLibrary.answer()).build()
          
          expect(answer.isFreeformCommentAllowed).to(beFalse())
        }
        it("is not allowing freeform when there is empty \"explain_type\" key") {
          var dict = JsonLibrary.answer()
          dict["explain_type"] = ""
          
          let answer = try! AnswerFactory(with: dict).build()
          
          expect(answer.isFreeformCommentAllowed).to(beFalse())
        }
        it("has allow freeform when there is non-empty \"explain_type\" key") {
          var dict = JsonLibrary.answer()
          dict["explain_type"] = "short"
          
          let answer = try! AnswerFactory(with: dict).build()
          
          expect(answer.isFreeformCommentAllowed).to(beTrue())
        }
        it("throws error if there is no id") {
          let dict = JsonLibrary.answer(id: nil)
          let factory = AnswerFactory(with: dict)

          expect { try factory.build() }.to(throwError())
        }
        it("throws error if there is wrong id") {
          var dict = JsonLibrary.answer(id: nil)
          dict["id"] = "text"
          let factory = AnswerFactory(with: dict)
          
          expect { try factory.build() }.to(throwError())
        }
        it("throws error if there is no title") {
          let dict = JsonLibrary.answer(title: nil)
          let factory = AnswerFactory(with: dict)

          expect { try factory.build() }.to(throwError())
        }
      }
    }
  }
}
