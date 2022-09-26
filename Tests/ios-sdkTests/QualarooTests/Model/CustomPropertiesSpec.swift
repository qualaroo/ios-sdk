//
//  CustomPropertiesSpec.swift
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

class CustomPropertiesSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("CustomProperties") {
      it("should find missing properties") {
        let properties = CustomProperties([:])
        let result = properties.checkForMissing(withKeywords: ["test"])
        expect(result).to(equal(["test"]))
      }
      it("should find missing properties") {
        let properties = CustomProperties([:])
        let result = properties.checkForMissing(withKeywords: ["test", "test2"])
        expect(result).to(equal(["test", "test2"]))
      }
      it("should find missing properties") {
        let properties = CustomProperties(["test": "value"])
        let result = properties.checkForMissing(withKeywords: ["test2"])
        expect(result).to(equal(["test2"]))
      }
      it("shouldn't find missing properties if there aren't any") {
        let properties = CustomProperties(["test": "value", "test2": "42"])
        let result = properties.checkForMissing(withKeywords: ["test", "test2"])
        expect(result).to(equal([String]()))
      }
    }
  }
}
