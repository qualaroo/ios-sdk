//
//  SurveyModelSpec.swift
//  Qualaroo
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

class SurveyModelSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("survey initializations") {
      context("survey") {
        it("should be created with four questions") {
          let questions = [JsonLibrary.question(id: 1),
                          JsonLibrary.question(id: 2),
                          JsonLibrary.question(id: 3)]
          let dict = JsonLibrary.survey(id: 123123,
                                        name: "Test survey",
                                        canonicalName: "test_alias",
                                        questionList: ["en": questions],
                                        messagesList: ["en": [JsonLibrary.goodMessage()]],
                                        startMap: ["en": ["id": 352640]],
                                        languagesList: ["en"])
          let survey = try! SurveyFactory(with: dict).build()
          expect(survey).notTo(beNil())
          expect(survey.surveyId).to(equal(123123))
          expect(survey.name).to(equal("Test survey"))
          expect(survey.alias).to(equal("test_alias"))
          expect(survey.languagesList).to(equal(["en"]))
          expect(survey.startMap).to(equal(["en": 352640]))
          expect(survey.nodeList).to(haveCount(4))
          expect(survey.requireMap.revealSpecs).to(equal(RequireMap.RevealSpecs.untilAnswered))
        }
        it("should be created with three questions") {
          let questions = [JsonLibrary.question(id: 1),
                           JsonLibrary.question(id: 2)]
          let dict = JsonLibrary.survey(id: 123123,
                                        name: "Test survey",
                                        canonicalName: "test_alias",
                                        questionList: ["en": questions],
                                        messagesList: ["en": [JsonLibrary.goodMessage()]],
                                        startMap: ["en": ["id": 352641]],
                                        languagesList: ["en"])
          let survey = try! SurveyFactory(with: dict).build()
          expect(survey).notTo(beNil())
          expect(survey.surveyId).to(equal(123123))
          expect(survey.name).to(equal("Test survey"))
          expect(survey.alias).to(equal("test_alias"))
          expect(survey.languagesList).to(equal(["en"]))
          expect(survey.startMap).to(equal(["en": 352641]))
          expect(survey.nodeList).to(haveCount(3))
        }
        it("should be created with one question") {
          let message = JsonLibrary.goodMessage()
          let dict = JsonLibrary.survey(id: 123456,
                                        name: "Test survey",
                                        active: true,
                                        canonicalName: "test_alias_good",
                                        messagesList: ["en": [message]],
                                        startMap: ["en": ["id": 352640]],
                                        languagesList: ["en"])
          let survey = try! SurveyFactory(with: dict).build()
          expect(survey).notTo(beNil())
          expect(survey.surveyId).to(equal(123456))
          expect(survey.name).to(equal("Test survey"))
          expect(survey.alias).to(equal("test_alias_good"))
          expect(survey.languagesList).to(equal(["en"]))
          expect(survey.startMap).to(equal(["en": 352640]))
          expect(survey.nodeList).to(haveCount(1))
        }
        it("throws error if there is no id") {
          let dict = JsonLibrary.survey(id: nil)
          
          expect { try SurveyFactory(with: dict).build() }.to(throwError())
        }
        it("throws error if there is no start map") {
          let dict = JsonLibrary.survey(startMap: nil)
          
          expect { try SurveyFactory(with: dict).build() }.to(throwError())
        }
        it("throws error if there is no alias") {
          let dict = JsonLibrary.survey(canonicalName: nil)
          
          expect { try SurveyFactory(with: dict).build() }.to(throwError())
        }
        it("throws error if alias is an empty string") {
          let dict = JsonLibrary.survey(canonicalName: "")
          
          expect { try SurveyFactory(with: dict).build() }.to(throwError())
        }
        it("throws error if contain unknown question type") {
          let questions = [JsonLibrary.question(id: 1, type: "unknown")]
          let dict = JsonLibrary.survey(questionList: ["en": questions])
          
          expect { try SurveyFactory(with: dict).build() }.to(throwError())
        }
        it("should have custom requirements") {
          let dict = JsonLibrary.survey(requireMap: ["custom_map": "test_key=test_value"])
          let survey = try! SurveyFactory(with: dict).build()
          
          expect(survey.requireMap.customRequirementsRule).notTo(beNil())
        }
      }
      context("reveal type") {
        it("should be set as show only once type") {
          let dict = JsonLibrary.survey(requireMap: ["is_one_shot": 1])
          
          let survey = try! SurveyFactory(with: dict).build()
          
          expect(survey.requireMap.revealSpecs).to(equal(RequireMap.RevealSpecs.onlyOnce))
        }
        it("should be set as show every time type") {
          let dict = JsonLibrary.survey(requireMap: ["is_persistent": 1])
          
          let survey = try! SurveyFactory(with: dict).build()
          
          expect(survey.requireMap.revealSpecs).to(equal(RequireMap.RevealSpecs.everyTime))
        }
        it("should be set as show every time type") {
          let survey = try! SurveyFactory(with: JsonLibrary.survey(requireMap: [:])).build()
          
          expect(survey.requireMap.revealSpecs).to(equal(RequireMap.RevealSpecs.untilAnswered))
        }
      }
    }
  }
}
