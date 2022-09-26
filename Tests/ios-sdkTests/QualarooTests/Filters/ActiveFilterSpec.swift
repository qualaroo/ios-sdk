//
//  ActiveFilterSpec.swift
//  QualarooTests
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

class ActiveFilterSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("ActiveFilter") {
      let filter = ActiveFilter()
      it("shows active survey") {
        var dict = JsonLibrary.survey()
        dict["active"] = true
        let survey = try! SurveyFactory(with: dict).build()
        
        let result = filter.shouldShow(survey: survey)
        
        expect(result).to(beTrue())
      }
      it("doesn't show inactive survey") {
        var dict = JsonLibrary.survey()
        dict["active"] = false
        let survey = try! SurveyFactory(with: dict).build()
        
        let result = filter.shouldShow(survey: survey)
        
        expect(result).to(beFalse())
      }
    }
  }
}
