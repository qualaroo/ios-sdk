//
//  LeadGenFormValidatorSpec.swift
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

class LeadGenFormValidatorSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("LeadGenFormValidator") {
      it("should always return true if there is no required questions") {
        let items = [JsonLibrary.leadGenItem(isRequired: false),
                     JsonLibrary.leadGenItem(isRequired: false),
                     JsonLibrary.leadGenItem(isRequired: false)]
        let validator = LeadGenFormValidator(items: items)
        var isValid = validator.isValid(with: ["1", "2", "3"])
        expect(isValid).to(beTrue())
        isValid = validator.isValid(with: ["", "", ""])
        expect(isValid).to(beTrue())
      }
      it("should return true if all required questions have non-empty answer") {
        let items = [JsonLibrary.leadGenItem(isRequired: true),
                     JsonLibrary.leadGenItem(isRequired: true),
                     JsonLibrary.leadGenItem(isRequired: false)]
        let validator = LeadGenFormValidator(items: items)
        let isValid = validator.isValid(with: ["1", "2", ""])
        expect(isValid).to(beTrue())
      }
      it("should return false if at least one required question has empty answer") {
        let items = [JsonLibrary.leadGenItem(isRequired: true),
                     JsonLibrary.leadGenItem(isRequired: true),
                     JsonLibrary.leadGenItem(isRequired: false)]
        let validator = LeadGenFormValidator(items: items)
        let isValid = validator.isValid(with: ["1", "", "3"])
        expect(isValid).to(beFalse())
      }
      it("should return false if number of answers is different then number of items") {
        let items = [JsonLibrary.leadGenItem(isRequired: true),
                     JsonLibrary.leadGenItem(isRequired: true),
                     JsonLibrary.leadGenItem(isRequired: false)]
        let validator = LeadGenFormValidator(items: items)
        let isValid = validator.isValid(with: ["1", "2"])
        expect(isValid).to(beFalse())
      }
    }
  }
}
