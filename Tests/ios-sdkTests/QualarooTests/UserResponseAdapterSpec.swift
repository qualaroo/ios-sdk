//
//  UserResponseAdapterSpec.swift
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

class UserResponseAdapterSpec: QuickSpec {
  override func spec() {
    super.spec()
   
    describe("UserResponseAdapter") {
      let adapter = UserResponseAdapter()
      let answerOneModel = AnswerResponse(id: 111,
                                          alias: "answer_111_alias",
                                          text: "Answer111")
      let answerTwoModel = AnswerResponse(id: 222,
                                          alias: "answer_222_alias",
                                          text: "Answer222")
      let answerThreeModel = AnswerResponse(id: 333,
                                            alias: "answer_333_alias",
                                            text: "Answer333")
      let questionOneModel = QuestionResponse(id: 11,
                                              alias: "question_11_alias",
                                              answerList: [answerOneModel])
      let questionTwoModel = QuestionResponse(id: 11,
                                              alias: "question_22_alias",
                                              answerList: [answerTwoModel, answerThreeModel])
      let questionThreeModel = QuestionResponse(id: 33,
                                                alias: nil,
                                                answerList: [answerOneModel])
      context("LeadGenResponse") {
        it("creates UserResponse from leadGen response with one question") {
          let leadGenModel = LeadGenResponse(id: 1,
                                             alias: "leadGen_1_alias",
                                             questionList: [questionOneModel])
          let responseModel = NodeResponse.leadGen(leadGenModel)
          let userResponse = adapter.toUserResponse(responseModel)!
          expect(userResponse.getQuestionAlias()).to(equal("leadGen_1_alias"))
          expect(userResponse.getFilledElements()).to(equal(["question_11_alias"]))
          expect(userResponse.getElementText("question_11_alias")).to(equal("Answer111"))
        }
        it("creates UserResponse from leadGen response with two questions") {
          let leadGenModel = LeadGenResponse(id: 1,
                                             alias: "leadGen_1_alias",
                                             questionList: [questionOneModel, questionTwoModel])
          let responseModel = NodeResponse.leadGen(leadGenModel)
          let userResponse = adapter.toUserResponse(responseModel)!
          expect(userResponse.getQuestionAlias()).to(equal("leadGen_1_alias"))
          expect(userResponse.getFilledElements()).to(equal(["question_11_alias", "question_22_alias"]))
          expect(userResponse.getElementText("question_11_alias")).to(equal("Answer111"))
          expect(userResponse.getElementText("question_22_alias")).to(equal("Answer222"))
        }
        it("skips questions with no alias") {
          let leadGenModel = LeadGenResponse(id: 1,
                                             alias: "leadGen_1_alias",
                                             questionList: [questionOneModel, questionTwoModel, questionThreeModel])
          let responseModel = NodeResponse.leadGen(leadGenModel)
          let userResponse = adapter.toUserResponse(responseModel)!
          expect(userResponse.getQuestionAlias()).to(equal("leadGen_1_alias"))
          expect(userResponse.getFilledElements()).to(equal(["question_11_alias", "question_22_alias"]))
          expect(userResponse.getElementText("question_11_alias")).to(equal("Answer111"))
          expect(userResponse.getElementText("question_22_alias")).to(equal("Answer222"))
        }
        it("doesn't create UserResponse if there is empty alias") {
          let leadGenModel = LeadGenResponse(id: 1,
                                             alias: nil,
                                             questionList: [questionOneModel])
          let responseModel = NodeResponse.leadGen(leadGenModel)
          let userResponse = adapter.toUserResponse(responseModel)
          expect(userResponse).to(beNil())
        }
      }
      context("QuestionResponse") {
        it("creates UserResponse from question response with one answer") {
          let responseModel = NodeResponse.question(questionOneModel)
          let userResponse = adapter.toUserResponse(responseModel)!
          expect(userResponse.getQuestionAlias()).to(equal("question_11_alias"))
          expect(userResponse.getFilledElements()).to(equal(["answer_111_alias"]))
          expect(userResponse.getElementText("answer_111_alias")).to(equal("Answer111"))
        }
        it("creates UserResponse from question response with two answers") {
          let responseModel = NodeResponse.question(questionTwoModel)
          let userResponse = adapter.toUserResponse(responseModel)!
          expect(userResponse.getQuestionAlias()).to(equal("question_22_alias"))
          expect(userResponse.getFilledElements()).to(equal(["answer_222_alias", "answer_333_alias"]))
          expect(userResponse.getElementText("answer_222_alias")).to(equal("Answer222"))
          expect(userResponse.getElementText("answer_333_alias")).to(equal("Answer333"))
        }
        it("skips answers with no alias") {
          let answerModel = AnswerResponse(id: 444,
                                           alias: nil,
                                           text: "Answer444")
          let questionModel = QuestionResponse(id: 44,
                                               alias: "question_44_alias",
                                               answerList: [answerTwoModel, answerThreeModel, answerModel])
          let responseModel = NodeResponse.question(questionModel)
          let userResponse = adapter.toUserResponse(responseModel)!
          expect(userResponse.getQuestionAlias()).to(equal("question_44_alias"))
          expect(userResponse.getFilledElements()).to(equal(["answer_222_alias", "answer_333_alias"]))
          expect(userResponse.getElementText("answer_222_alias")).to(equal("Answer222"))
          expect(userResponse.getElementText("answer_333_alias")).to(equal("Answer333"))
        }
        it("doesn't create UserResponse if there is empty alias") {
          let responseModel = NodeResponse.question(questionThreeModel)
          let userResponse = adapter.toUserResponse(responseModel)
          expect(userResponse).to(beNil())
        }
        
      }
    }
  }
}
