//
//  CustomPropertiesFilterSpec.swift
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

class CustomPropertiesFilterSpec: QuickSpec {
  
  func buildFilter(_ properties: [String: String]) -> CustomPropertiesFilter {
    return CustomPropertiesFilter(customProperties: CustomProperties(properties))
  }
  
  override func spec() {
    super.spec()
    
    describe("CustomPropertiesFilter") {
      var filter: CustomPropertiesFilter!
      beforeEach {
        filter = CustomPropertiesFilter(customProperties: CustomProperties([:]))
      }
      
      it("matches basic cases") {
        expect(filter.check(rule: nil, surveyId: 1)).to(beTrue())
        expect(filter.check(rule: "", surveyId: 1)).to(beTrue())
        expect(filter.check(rule: " ", surveyId: 1)).to(beTrue())
        expect(filter.check(rule: "\"something\" == \"something\"", surveyId: 1)).to(beTrue())
        expect(filter.check(rule: "2", surveyId: 1)).to(beTrue())
        expect(filter.check(rule: "2 > 2", surveyId: 1)).to(beFalse())
        expect(filter.check(rule: "2 != 2", surveyId: 1)).to(beFalse())
        expect(filter.check(rule: "\"something\"||2==2", surveyId: 1)).to(beTrue())
        expect(filter.check(rule: "\"something\"&&2==2", surveyId: 1)).to(beTrue())
      }
      
      it("ignores empty spaces") {
        expect(filter.check(rule: "1==1", surveyId: 0)).to(beTrue())
        expect(filter.check(rule: "1 == 1", surveyId: 0)).to(beTrue())
        expect(filter.check(rule: " 1==      1", surveyId: 0)).to(beTrue())
      }
      
      it("matches based on custom properties") {
        expect(filter.check(rule: "premium==\"true\"", surveyId: 0)).to(beFalse())
        
        filter = self.buildFilter(["premium": "true"])
        expect(filter.check(rule: "premium==\"true\"", surveyId: 0)).to(beTrue())
        expect(filter.check(rule: "premium == \"true\" && age > 18", surveyId: 0)).to(beFalse())
        
        filter = self.buildFilter(["premium": "true", "age": "18"])
        expect(filter.check(rule: "premium == \"true\" && age > 18", surveyId: 0)).to(beFalse())
        
        filter = self.buildFilter(["premium": "true", "age": "19"])
        expect(filter.check(rule: "premium == \"true\" && age > 18", surveyId: 0)).to(beTrue())
        expect(filter.check(rule: "(premium==\"true\" && age > 18) && name=\"Joe\"", surveyId: 0)).to(beFalse())
        
        filter = self.buildFilter(["premium": "true", "age": "19", "name": "Joe"])
        expect(filter.check(rule: "(premium==\"true\" && age > 18) && name==\"Joe\"", surveyId: 0)).to(beTrue())
      
        
        filter = self.buildFilter(["premium": "true", "age": "16", "name": "Joe"])
        expect(filter.check(rule: "((premium==\"true\" && age > 18) && name==\"Joe\") || job == \"ceo\"", surveyId: 0)).to(beFalse())
        
        filter = self.buildFilter(["premium": "true", "age": "16", "name": "Joe", "job": "ceo"])
        expect(filter.check(rule: "((premium==\"true\" && age > 18) && name==\"Joe\") || job == \"ceo\"", surveyId: 0)).to(beTrue())
        
        filter = self.buildFilter(["platform": "iOS"])
        expect(filter.check(rule: "platform==\"Android\"", surveyId: 0)).to(beFalse())
        
        filter = self.buildFilter(["android": "android"])
        expect(filter.check(rule: "android==\"android\"", surveyId: 0)).to(beTrue())
      }
    }
  }
}
