//
//  QualarooSpec.swift
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

class QualarooSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("Qualaroo main component") {
      context("credentials") {
        it("should be initialized with proper key") {
          let key = "MTIzNDU6NzUyYmQ5OGVjMjEyMTAwMDAwOTIwYjllMGYyZjMyNWY3ZTZhNDU1Yjo2Nzg5MA=="
          let credentials = Credentials(withKey: key)
          expect(credentials).notTo(beNil())
          expect(credentials?.apiKey).to(equal("12345"))
          expect(credentials?.apiSecret).to(equal("752bd98ec212100000920b9e0f2f325f7e6a455b"))
          expect(credentials?.siteId).to(equal("67890"))
        }
        it("should return nil if empty key") {
          let credentials = Credentials(withKey: "")
          expect(credentials).to(beNil())
        }
        it("should return nil if key decryption contains to little elements") {
          let key = "MzkyNDE6NzUyYmQ5OGVjMjEyMTYzMDNhOTJmYjllMGYyZjMyNWY3ZTZhNDU1Y452NDc1N4o="
          let credentials = Credentials(withKey: key)
          expect(credentials).to(beNil())
        }
        it("should return nil if key decryption contains to many elements") {
          let credentials = Credentials(withKey: "MTIzNDEyMzQ6MTIzNDoxMjM0MTIzNDoxMjM0")
          expect(credentials).to(beNil())
        }
        it("should be nil if there are letters in apiKey") {
          let credentials = Credentials(withKey: "MTIzYToxMjM0OjEyMzQ=")
          expect(credentials).to(beNil())
        }
        it("should be nil if there letters in siteID") {
          let credentials = Credentials(withKey: "MTIzNDoxMjM0OjEyM2E=")
          expect(credentials).to(beNil())
        }
      }
      context("qualaroo module") {
        it("should not configure with wrong credentials") {
          let wrongKey = "MTIzNDEyMzQ6MTIzNDoxMjM0MTIzNDoxMjM0"
          Qualaroo.shared.configure(with: wrongKey)
          expect(Qualaroo.shared.isConfigured()).to(beFalse())
        }
        it("should configure with proper credentials") {
          let properKey = "MTIzNDU6NzUyYmQ5OGVjMjEyMTAwMDAwOTIwYjllMGYyZjMyNWY3ZTZhNDU1Yjo2Nzg5MA=="
          Qualaroo.shared.configure(with: properKey)
          expect(Qualaroo.shared.isConfigured()).to(beTrue())
        }
        it("should not change language if user tries to set wrong language code") {
          expect { try Qualaroo.shared.setPreferredSurveysLanguage("abc-def") }.to(throwError())
        }
        it("should change language if user tries to set correct language code") {
          expect { try Qualaroo.shared.setPreferredSurveysLanguage("fr") }.notTo(throwError())
        }
      }
      context("userProperties") {
        it("should be set same as requested") {
          Qualaroo.shared.setUserProperties(["key": "value"])
          expect(Qualaroo.shared.userProperties()).to(equal(["key": "value"]))
        }
        it("should be changed to new") {
          Qualaroo.shared.setUserProperties(["key": "value"])
          Qualaroo.shared.setUserProperties(["newKey": "newValue"])
          expect(Qualaroo.shared.userProperties()).to(equal(["newKey": "newValue"]))
        }
        it("should add new records") {
          Qualaroo.shared.setUserProperties(["key": "value"])
          Qualaroo.shared.addUserProperty("newKey", withValue: "newValue")
          expect(Qualaroo.shared.userProperties()).to(equal(["key": "value", "newKey": "newValue"]))
        }
        it("should update record") {
          Qualaroo.shared.setUserProperties(["key": "value"])
          Qualaroo.shared.addUserProperty("key", withValue: "newValue")
          expect(Qualaroo.shared.userProperties()).to(equal(["key": "newValue"]))
        }
        it("should remove records") {
          Qualaroo.shared.setUserProperties(["key": "value", "newKey": "newValue"])
          Qualaroo.shared.removeUserProperty("newKey")
          expect(Qualaroo.shared.userProperties()).to(equal(["key": "value"]))
        }
      }
    }
  }
}
