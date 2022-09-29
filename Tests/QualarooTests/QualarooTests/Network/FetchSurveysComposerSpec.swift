//
//  FetchSurveysComposerSpec.swift
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

class FetchSurveysComposerSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("FetchSurveysComposer") {
      context("URL creation") {
        it("should return proper URL if siteID was fine") {
          let composer = FetchSurveysComposer(siteId: "123123", deviceId: "", environment: .production)
          let components = URLComponents(url: composer.url()!, resolvingAgainstBaseURL: false)!
          expect(components.host).to(equal("api.qualaroo.com"))
          expect(components.path).to(equal("/api/v1.5/surveys"))
          let validQueryItems = [URLQueryItem(name: "site_id", value: "123123"),
                                 URLQueryItem(name: "spec", value: "1"),
                                 URLQueryItem(name: "no_superpack", value: "1")]
          expect(components.queryItems).to(contain(validQueryItems))
        }
        it("should create basic info with appName") {
          let composer = FetchSurveysComposer(siteId: "123123",
                                              deviceId: "1",
                                              appId: "testName",
                                              environment: .production)
          let components = URLComponents(url: composer.url()!, resolvingAgainstBaseURL: false)!
          let version = Bundle.qualaroo().object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
          let queryItems = [URLQueryItem(name: "sdk_version", value: version),
                            URLQueryItem(name: "client_app", value: "testName"),
                            URLQueryItem(name: "device_type", value: UIDevice.current.model),
                            URLQueryItem(name: "os_version", value: UIDevice.current.systemVersion),
                            URLQueryItem(name: "os", value: "iOS"),
                            URLQueryItem(name: "device_id", value: "1")]
          expect(components.queryItems).to(contain(queryItems))
        }
        it("should create basic info even without app name") {
          let composer = FetchSurveysComposer(siteId: "123123", deviceId: "1", environment: .production)
          let components = URLComponents(url: composer.url()!, resolvingAgainstBaseURL: false)!
          let version = Bundle.qualaroo().object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
          let queryItems = [URLQueryItem(name: "sdk_version", value: version),
                            URLQueryItem(name: "device_type", value: UIDevice.current.model),
                            URLQueryItem(name: "os_version", value: UIDevice.current.systemVersion),
                            URLQueryItem(name: "os", value: "iOS"),
                            URLQueryItem(name: "device_id", value: "1")]
          expect(components.queryItems).to(contain(queryItems))
        }
        it("should create proper URL for staging") {
          let composer = FetchSurveysComposer(siteId: "123123", deviceId: "", environment: .staging)
          expect(composer.url()!.host).to(equal("staging-app.qualaroo.com"))
        }
      }
      context("authentication creation") {
        it("should create proper Basic Authorisation string") {
          let composer = FetchSurveysComposer(siteId: "", deviceId: "", environment: .production)
          let authentication = composer.authentication(apiKey: "123", apiSecret: "456")
          expect(authentication).to(equal("Basic MTIzOjQ1Ng=="))
        }
      }
    }
  }
}
