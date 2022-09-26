//
//  OpeningFilterSpec.swift
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

class OpeningFilterSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("OpeningFilter") {
      let memory = PersistentMemory()
      let openingFilter = OpeningFilter(withSeenSurveyStorage: memory)
      beforeEach {
        memory.resetStoredData()
      }
      it("should return true for not seen survey with always show") {
        let survey = try! SurveyFactory(with: JsonLibrary.survey(id: 1, requireMap: ["is_persistent": "true"])).build()
        let result = openingFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("should return true for seen survey with always show") {
        memory.memory.set(["1": Date()], forKey: "seenSurveys")
        let survey = try! SurveyFactory(with: JsonLibrary.survey(id: 1, requireMap: ["is_persistent": "true"])).build()
        let result = openingFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("should return true for not seen survey with until answered") {
        let survey = try! SurveyFactory(with: JsonLibrary.survey(id: 1, requireMap: [:])).build()
        let result = openingFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("should return true for seen survey with until answered if not finished") {
        memory.memory.set(["1": Date()], forKey: "seenSurveys")
        let survey = try! SurveyFactory(with: JsonLibrary.survey(id: 1, requireMap: [:])).build()
        let result = openingFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("should return false for finished survey with until answered if not finished") {
        memory.memory.set([1], forKey: "finishedSurveys")
        let survey = try! SurveyFactory(with: JsonLibrary.survey(id: 1, requireMap: [:])).build()
        let result = openingFilter.shouldShow(survey: survey)
        expect(result).to(beFalse())
      }
      it("should return true for not seen survey with only once") {
        memory.memory.set([String: Any](), forKey: "seenSurveys")
        let survey = try! SurveyFactory(with: JsonLibrary.survey(id: 1, requireMap: ["is_one_shot": "true"])).build()
        let result = openingFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("should return false for seen survey with only once") {
        memory.memory.set(["1": Date()], forKey: "seenSurveys")
        let survey = try! SurveyFactory(with: JsonLibrary.survey(id: 1, requireMap: ["is_one_shot": "true"])).build()
        let result = openingFilter.shouldShow(survey: survey)
        expect(result).to(beFalse())
      }
    }
  }
}
