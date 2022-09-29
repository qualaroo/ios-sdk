//
//  SamplePercentFilterSpec.swift
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

class SamplePercentFilterSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("SamplePercentFilter") {
      let memory = PersistentMemory()
      let filter = SamplePercentFilter(withSamplePercentStorage: memory)
      beforeEach {
        PersistentMemory().resetStoredData()
      }
      it("shows survey for every user if sample percent is 100") {
        let dict = JsonLibrary.survey(requireMap: ["sample_percent": 100])
        let survey = try! SurveyFactory(with: dict).build()
        var result = filter.shouldShow(survey: survey)
        expect(result).to(beTrue())
        memory.memory.set(["1": 10], forKey: "samplePercents")
        result = filter.shouldShow(survey: survey)
        expect(result).to(beTrue())
        memory.memory.set(["1": 90], forKey: "samplePercents")
        result = filter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("shows survey only for users that are in proper range") {
        let dict = JsonLibrary.survey(requireMap: ["sample_percent": 50])
        let survey = try! SurveyFactory(with: dict).build()
        memory.memory.set(["1": 10], forKey: "samplePercents")
        var result = filter.shouldShow(survey: survey)
        expect(result).to(beTrue())
        memory.memory.set(["1": 90], forKey: "samplePercents")
        result = filter.shouldShow(survey: survey)
        expect(result).to(beFalse())
      }
      it("doesn't shows survey if sample percent is 0") {
        let dict = JsonLibrary.survey(requireMap: ["sample_percent": 0])
        let survey = try! SurveyFactory(with: dict).build()
        var result = filter.shouldShow(survey: survey)
        expect(result).to(beFalse())
        memory.memory.set(["1": 10], forKey: "samplePercents")
        result = filter.shouldShow(survey: survey)
        expect(result).to(beFalse())
        memory.memory.set(["1": 90], forKey: "samplePercents")
        result = filter.shouldShow(survey: survey)
        expect(result).to(beFalse())
      }
    }
  }
}
