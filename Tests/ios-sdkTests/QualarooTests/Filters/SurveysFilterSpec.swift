//
//  SurveysFilterSpec.swift
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

class FilterProtocolMock: FilterProtocol {
  let shouldShowValue: Bool
  init(isPassing: Bool) {
    shouldShowValue = isPassing
  }
  func shouldShow(survey: Survey) -> Bool {
    return shouldShowValue
  }
}

class SurveysFilterSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("SurveysFilterSpec") {
      it("passes when all filters are passing") {
        let filters = [FilterProtocolMock(isPassing: true),
                       FilterProtocolMock(isPassing: true),
                       FilterProtocolMock(isPassing: true)]
        let filter = SurveysFilter(filters: filters)
        let survey = try! SurveyFactory(with: JsonLibrary.survey()).build()
        let isPassing = filter.shouldShow(survey: survey)
        expect(isPassing).to(beTrue())
      }
      it("return false if at least one filter is not passing") {
        let filters = [FilterProtocolMock(isPassing: true),
                       FilterProtocolMock(isPassing: false),
                       FilterProtocolMock(isPassing: true)]
        let filter = SurveysFilter(filters: filters)
        let survey = try! SurveyFactory(with: JsonLibrary.survey()).build()
        let isPassing = filter.shouldShow(survey: survey)
        expect(isPassing).to(beFalse())

      }
    }
  }
}
