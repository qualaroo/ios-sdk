//
//  LeadGenFormResponseBuilderSpec.swift
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

class LeadGenFormResponseBuilderSpec: QuickSpec {
  override func spec() {
    super.spec()
  
    describe("LeadGenFormResponseBuilder") {
      var builder: LeadGenFormResponseBuilder!
      context("creating response") {
        it("creates response with no texts") {
          builder = LeadGenFormResponseBuilder(id: 1,
                                               alias: "1",
                                               items: [])
          let response = builder.response(with: [])
          let leadGen = LeadGenResponse(id: 1,
                                         alias: "1",
                                         questionList: [])
          expect(response).to(equal(NodeResponse.leadGen(leadGen)))
        }
        it("creates response with one text") {
          let item = JsonLibrary.leadGenItem(id: 22, alias: "alias_22")
          builder = LeadGenFormResponseBuilder(id: 1,
                                               alias: "1",
                                               items: [item])
          let response = builder.response(with: ["test"])
          let answer = AnswerResponse(id: nil, alias: nil, text: "test")
          let question = QuestionResponse(id: 22, alias: "alias_22", answerList: [answer])
          let leadGen = LeadGenResponse(id: 1, alias: "1", questionList: [question])
          expect(response).to(equal(NodeResponse.leadGen(leadGen)))
        }
        it("creates response with few texts") {
          let itemOne = JsonLibrary.leadGenItem(id: 22, alias: "alias_22")
          let itemTwo = JsonLibrary.leadGenItem(id: 33, alias: "alias_33")
          builder = LeadGenFormResponseBuilder(id: 1,
                                               alias: "1",
                                               items: [itemOne, itemTwo])
          let response = builder.response(with: ["test1", "test2"])
          let answerOne = AnswerResponse(id: nil, alias: nil, text: "test1")
          let questionOne = QuestionResponse(id: 22, alias: "alias_22", answerList: [answerOne])
          let answerTwo = AnswerResponse(id: nil, alias: nil, text: "test2")
          let questionTwo = QuestionResponse(id: 33, alias: "alias_33", answerList: [answerTwo])
          let leadGen = LeadGenResponse(id: 1, alias: "1", questionList: [questionOne, questionTwo])
          expect(response).to(equal(NodeResponse.leadGen(leadGen)))
        }
        it("doesn't create response if text count is not equal to question count") {
          let itemOne = JsonLibrary.leadGenItem(id: 22, alias: "alias_22")
          let itemTwo = JsonLibrary.leadGenItem(id: 33, alias: "alias_33")
          builder = LeadGenFormResponseBuilder(id: 1,
                                               alias: "1",
                                               items: [itemOne, itemTwo])
          let response = builder.response(with: ["test1"])
          expect(response).to(beNil())
        }
      }
    }
  }
}
