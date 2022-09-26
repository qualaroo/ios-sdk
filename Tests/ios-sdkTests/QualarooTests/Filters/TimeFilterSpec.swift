//
//  TimeFilterSpec.swift
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

class TimeFilterSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("TimeFilter") {
      let memory = PersistentMemory()
      let survey = try! SurveyFactory(with: JsonLibrary.survey(id: 1)).build()
      let timeFilter = TimeFilter(withSeenSurveyStorage: memory)
      beforeEach {
        PersistentMemory().resetStoredData()
      }
      it("should know if user seen recently survey") {
        let seenSurveys = ["1": Date(timeIntervalSinceNow: -60)]
        memory.memory.set(seenSurveys, forKey: "seenSurveys")
        let result = timeFilter.shouldShow(survey: survey)
        expect(result).to(beFalse())
      }
      it("should return true if user haven't seen survey") {
        let result = timeFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("should return true if user have seen survey more then three days ago") {
        let seenSurveys = ["1": Date(timeIntervalSinceNow: -73 * 60 * 60)]
        memory.memory.set(seenSurveys, forKey: "seenSurveys")
        let result = timeFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
    }
  }
}
