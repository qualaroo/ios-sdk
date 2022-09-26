//
//  SurveyWireframeSpec.swift
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

class SurveyWireframeSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("SurveyWireframe") {
      context("Preferred languages") {
        var survey: Survey!
        beforeEach {
          let questions = ["en": [JsonLibrary.question(id: 11)],
                           "fr": [JsonLibrary.question(id: 22)]]
          let dict = JsonLibrary.survey(questionList: questions,
                                        startMap: ["en": ["id": 11], "fr": ["id": 22]],
                                        languagesList: ["en", "fr"])
          survey = try! SurveyFactory(with: dict).build()

        }
        it("is using second languagefrom list if first one doesn't match") {
          let wireframe = SurveyWireframe(survey: survey, languages: ["pl", "en"])
          
          let firstNode = wireframe.firstNode()!
          
          expect(firstNode.nodeId()).to(equal(11))
        }
        it("is using first language question set if all languages aren't matching") {
          let wireframe = SurveyWireframe(survey: survey, languages: ["pl", "de"])
          
          let firstNode = wireframe.firstNode()!
          
          expect(firstNode.nodeId()).to(equal(11))
        }
        it("is using preferred language question set if it matches") {
          let wireframe = SurveyWireframe(survey: survey, languages: ["fr", "en"])
          
          let firstNode = wireframe.firstNode()!
          
          expect(firstNode.nodeId()).to(equal(22))
        }
      }
      context("SurveyWireframeProtocol") {
        var wireframe: SurveyWireframe!
        beforeEach {
          let answerList = [["id": 12, "title": "Title", "next_map": ["id": 124, "node_type": "question"]],
                            ["id": 13, "title": "Title", "next_map": ["id": 125, "node_type": "question"]]]
          var firstQuestion = JsonLibrary.question(id: 123, type: "radio", answerList: answerList)
          firstQuestion["next_map"] = ["id": 123]
          let questionList = [firstQuestion,
                              JsonLibrary.question(id: 124),
                              JsonLibrary.question(id: 125)]
          let dict = JsonLibrary.survey(id: 1,
                                        questionList: ["en": questionList],
                                        startMap: ["en": ["id": 123]],
                                        languagesList: ["en"])
          let survey = try! SurveyFactory(with: dict).build()
          wireframe = SurveyWireframe(survey: survey, languages: ["en"])
        }
        it("return first question if there is one") {
          expect(wireframe.firstNode()?.nodeId()).to(equal(123))
        }
        it("return proper next question when no answer selected") {
          let response = JsonLibrary.questionResponse()
          
          let nextNode = wireframe.nextNode(for: 123,
                                            response: response)
          
          expect(nextNode?.nodeId()).to(equal(123))
        }
        it("return proper next question when no responce created") {
          let nextNode = wireframe.nextNode(for: 123,
                                            response: nil)
          
          expect(nextNode?.nodeId()).to(equal(123))
        }
        it("return proper next question for selected answer") {
          let response = JsonLibrary.questionResponse(selected: [12])
          
          let nextNode = wireframe.nextNode(for: 123,
                                            response: response)
          
          expect(nextNode?.nodeId()).to(equal(124))
        }
        it("return proper next question for selected answer") {
          let response = JsonLibrary.questionResponse(selected: [13])
          
          let nextNode = wireframe.nextNode(for: 123,
                                            response: response)
          
          expect(nextNode?.nodeId()).to(equal(125))
        }
        it("returns next node for selected answer in response") {
          let answer = JsonLibrary.answer(id: 12, nextMap: ["id": 124, "node_type": "question"])
          let questionList = ["en": [JsonLibrary.question(id: 123, type: "radio", answerList: [answer]),
                                     JsonLibrary.question(id: 124)]]
          let survey = try! SurveyFactory(with: JsonLibrary.survey(questionList: questionList)).build()
          let wireframe = SurveyWireframe(survey: survey, languages: ["nil"])
          let answerResponse = AnswerResponse(id: 12, alias: nil, text: nil)
          let questionResponse = QuestionResponse(id: 123, alias: nil, answerList: [answerResponse])
          let response = NodeResponse.question(questionResponse)
          
          let nextNode = wireframe.nextNode(for: 123, response: response)
          
          expect(nextNode?.nodeId()).to(equal(124))
        }
        it("returns next node for lead gen form response") {
          let leadGenResponse = LeadGenResponse(id: 123, alias: nil, questionList: [])
          let response = NodeResponse.leadGen(leadGenResponse)
          
          let nextNode = wireframe.nextNode(for: 123, response: response)
          
          expect(nextNode?.nodeId()).to(equal(123))
        }
        it("returns next node for empty answer in response") {
          var question = JsonLibrary.question(id: 123, answerList: [])
          question["next_map"] = ["id": 22, "node_type": "question"]
          let nextQuestion = JsonLibrary.question(id: 22)
          let dict = JsonLibrary.survey(questionList: ["en": [question, nextQuestion]])
          let survey = try! SurveyFactory(with: dict).build()
          let wireframe = SurveyWireframe(survey: survey, languages: ["nil"])
          let questionResponse = QuestionResponse(id: 123, alias: nil, answerList: [])
          let response = NodeResponse.question(questionResponse)
          
          let nextNode = wireframe.nextNode(for: 123, response: response)
          
          expect(nextNode?.nodeId()).to(equal(22))
        }
        it("return nil if there isn't next node") {
          let nextNode = wireframe.nextNode(for: 125, response: JsonLibrary.questionResponse(selected: [15]))
          expect(nextNode?.nodeId()).to(beNil())
        }
        it("return current survey Id") {
          expect(wireframe.currentSurveyId()).to(equal(1))
        }
        it("return true for isMandatory call when survey is mandatory") {
          let survey = try! SurveyFactory(with: JsonLibrary.survey(mandatory: true)).build()
          wireframe = SurveyWireframe(survey: survey, languages: ["en"])
          
          expect(wireframe.isMandatory()).to(beTrue())
        }
        it("return false for isMandatory call when survey is optional") {
          let survey = try! SurveyFactory(with: JsonLibrary.survey(mandatory: false)).build()
          wireframe = SurveyWireframe(survey: survey, languages: ["en"])
          
          expect(wireframe.isMandatory()).to(beFalse())
        }
      }
    }
  }
}
