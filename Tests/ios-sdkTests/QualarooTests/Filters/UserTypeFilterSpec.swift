//
//  UserTypeFilterSpec.swift
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

class UserTypeFilterSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("UserTypeFilter") {
      let knownUserTypeFilter = UserTypeFilter(clientId: "knownUserInfo")
      let unknownUserTypeFilter = UserTypeFilter(clientId: nil)
      it("should return true when targeting known user with clientId") {
        let survey = try! SurveyFactory(with: JsonLibrary.survey(requireMap: ["want_user_str": "yes"])).build()
        let result = knownUserTypeFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("should return false when targeting known user without clientId") {
        let survey = try! SurveyFactory(with: JsonLibrary.survey(requireMap: ["want_user_str": "yes"])).build()
        let result = unknownUserTypeFilter.shouldShow(survey: survey)
        expect(result).to(beFalse())
      }
      it("should return false when targeting unknown user with clientId") {
        let survey = try! SurveyFactory(with: JsonLibrary.survey(requireMap: ["want_user_str": "no"])).build()
        let result = knownUserTypeFilter.shouldShow(survey: survey)
        expect(result).to(beFalse())
      }
      it("should return true when targeting unknown user without clientId") {
        let survey = try! SurveyFactory(with: JsonLibrary.survey(requireMap: ["want_user_str": "no"])).build()
        let result = unknownUserTypeFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("should return true when targeting any user with clientId") {
        let survey = try! SurveyFactory(with: JsonLibrary.survey(requireMap: ["want_user_str": "any"])).build()
        let result = knownUserTypeFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
      it("should return true when targeting any user without clientId") {
        let survey = try! SurveyFactory(with: JsonLibrary.survey(requireMap: ["want_user_str": "any"])).build()
        let result = unknownUserTypeFilter.shouldShow(survey: survey)
        expect(result).to(beTrue())
      }
    }
  }
}
