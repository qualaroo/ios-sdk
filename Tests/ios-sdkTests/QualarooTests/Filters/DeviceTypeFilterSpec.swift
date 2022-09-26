//
//  DeviceTypeFilterSpec.swift
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

class DeviceTypeFilterSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("DeviceTypeFilter") {
      let phoneDeviceTypeFilter = DeviceTypeFilter(withInterfaceIdiom: .phone)
      let padDeviceTypeFilter = DeviceTypeFilter(withInterfaceIdiom: .pad)
      it("returns true for iPhone when targeting only phones") {
        let map = JsonLibrary.survey(requireMap: ["device_type_list": ["phone"]])
        let survey = try! SurveyFactory(with: map).build()
        
        let result = phoneDeviceTypeFilter.shouldShow(survey: survey)
        
        expect(result).to(beTrue())
      }
      it("returns true for iPhone when targeting phones and tablets") {
        let map = JsonLibrary.survey(requireMap: ["device_type_list": ["phone", "tablet"]])
        let survey = try! SurveyFactory(with: map).build()
        
        let result = phoneDeviceTypeFilter.shouldShow(survey: survey)
        
        expect(result).to(beTrue())
      }
      it("returns false for iPhone when targeting only tablets") {
        let map = JsonLibrary.survey(requireMap: ["device_type_list": ["tablet"]])
        let survey = try! SurveyFactory(with: map).build()
        
        let result = phoneDeviceTypeFilter.shouldShow(survey: survey)
        
        expect(result).to(beFalse())
      }
      it("returns false for iPhone when targeting tablets and desktop") {
        let map = JsonLibrary.survey(requireMap: ["device_type_list": ["tablet", "desktop"]])
        let survey = try! SurveyFactory(with: map).build()
        
        let result = phoneDeviceTypeFilter.shouldShow(survey: survey)
        
        expect(result).to(beFalse())
      }
      it("returns false for iPhone when targeting nothing") {
        let map = JsonLibrary.survey(requireMap: ["device_type_list": []])
        let survey = try! SurveyFactory(with: map).build()
        
        let result = phoneDeviceTypeFilter.shouldShow(survey: survey)
        
        expect(result).to(beFalse())
      }
      it("returns false for iPad when targeting only phones") {
        let map = JsonLibrary.survey(requireMap: ["device_type_list": ["phone"]])
        let survey = try! SurveyFactory(with: map).build()
        
        let result = padDeviceTypeFilter.shouldShow(survey: survey)
        
        expect(result).to(beFalse())
      }
      it("returns true for iPad when targeting phones and tablets") {
        let map = JsonLibrary.survey(requireMap: ["device_type_list": ["phone", "tablet"]])
        let survey = try! SurveyFactory(with: map).build()
        
        let result = padDeviceTypeFilter.shouldShow(survey: survey)
        
        expect(result).to(beTrue())
      }
      it("returns true for iPad when targeting only tablets") {
        let map = JsonLibrary.survey(requireMap: ["device_type_list": ["tablet"]])
        let survey = try! SurveyFactory(with: map).build()
        
        let result = padDeviceTypeFilter.shouldShow(survey: survey)
        
        expect(result).to(beTrue())
      }
      it("returns true for iPad when targeting tablets and desktop") {
        let map = JsonLibrary.survey(requireMap: ["device_type_list": ["tablet", "desktop"]])
        let survey = try! SurveyFactory(with: map).build()
        
        let result = padDeviceTypeFilter.shouldShow(survey: survey)
        
        expect(result).to(beTrue())
      }
    }
  }
}
