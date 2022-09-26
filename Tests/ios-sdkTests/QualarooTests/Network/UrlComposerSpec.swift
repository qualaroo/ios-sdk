//
//  SendResponseComposerSpec.swift
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

class UrlComposerSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("UrlComposer") {
      let sdkSession = SdkSession()
      var sessionInfo: SessionInfo!
      var customProperties: CustomProperties!
      var urlComposer: UrlComposer!
      beforeEach {
        sessionInfo = SessionInfo(surveyId: 1,
                                  clientId: "2",
                                  deviceId: "3",
                                  sessionId: "4")
        customProperties = CustomProperties([:])
        urlComposer = UrlComposer(sessionInfo: sessionInfo,
                                  customProperties: customProperties,
                                  environment: .production,
                                  sdkSession: sdkSession)
      }
      context("recording impression") {
        it("have proper host for production") {
          let url = urlComposer.impressionUrl()!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          expect(components.scheme).to(equal("https"))
          expect(components.host).to(equal("turbo.qualaroo.com"))
          expect(components.path).to(equal("/c.js"))
        }
        it("have proper host for staging") {
          urlComposer = UrlComposer(sessionInfo: sessionInfo,
                                    customProperties: customProperties,
                                    environment: .staging,
                                    sdkSession: sdkSession)
          let url = urlComposer.impressionUrl()!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          expect(components.scheme).to(equal("https"))
          expect(components.host).to(equal("stage1.turbo.qualaroo.com"))
          expect(components.path).to(equal("/c.js"))
        }
        it("creates proper query with session info with identity") {
          let url = urlComposer.impressionUrl()!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(haveCount(4))
          expect(query).to(contain(URLQueryItem(name: "id", value: "1")))
          expect(query).to(contain(URLQueryItem(name: "i", value: "2")))
          expect(query).to(contain(URLQueryItem(name: "au", value: "3")))
          expect(query).to(contain(URLQueryItem(name: "u", value: "4")))
        }
        it("creates proper query without identity") {
          sessionInfo = SessionInfo(surveyId: 1,
                                    clientId: nil,
                                    deviceId: "3",
                                    sessionId: "4")
          urlComposer = UrlComposer(sessionInfo: sessionInfo,
                                    customProperties: customProperties,
                                    environment: .production,
                                    sdkSession: sdkSession)
          let url = urlComposer.impressionUrl()!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(haveCount(3))
          expect(query).to(contain(URLQueryItem(name: "id", value: "1")))
          expect(query).to(contain(URLQueryItem(name: "au", value: "3")))
          expect(query).to(contain(URLQueryItem(name: "u", value: "4")))
        }
      }
      context("sending response") {
        it("have proper host for production") {
          let url = urlComposer.responseUrl(with: JsonLibrary.questionResponse())!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          expect(components.scheme).to(equal("https"))
          expect(components.host).to(equal("turbo.qualaroo.com"))
          expect(components.path).to(equal("/r.js"))
        }
        it("have proper host for staging") {
          urlComposer = UrlComposer(sessionInfo: sessionInfo,
                                    customProperties: customProperties,
                                    environment: .staging,
                                    sdkSession: sdkSession)
          let url = urlComposer.responseUrl(with: JsonLibrary.questionResponse())!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          expect(components.scheme).to(equal("https"))
          expect(components.host).to(equal("stage1.turbo.qualaroo.com"))
          expect(components.path).to(equal("/r.js"))
        }
        it("creates proper session info query") {
          customProperties = CustomProperties([:])
          let url = urlComposer.responseUrl(with: JsonLibrary.questionResponse())!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(contain(URLQueryItem(name: "id", value: "1")))
          expect(query).to(contain(URLQueryItem(name: "i", value: "2")))
          expect(query).to(contain(URLQueryItem(name: "au", value: "3")))
          expect(query).to(contain(URLQueryItem(name: "u", value: "4")))
        }
        it("creates proper single custom property query") {
          customProperties = CustomProperties(["key": "value"])
          urlComposer = UrlComposer(sessionInfo: sessionInfo,
                                    customProperties: customProperties,
                                    environment: .production,
                                    sdkSession: sdkSession)
          let url = urlComposer.responseUrl(with: JsonLibrary.questionResponse())!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(contain(URLQueryItem(name: "rp[key]", value: "value")))
        }
        it("creates proper multiple custom property query") {
          customProperties = CustomProperties(["key": "value",
                                               "key2": "value2",
                                               "key3": "value3"])
          urlComposer = UrlComposer(sessionInfo: sessionInfo,
                                    customProperties: customProperties,
                                    environment: .production,
                                    sdkSession: sdkSession)
          let url = urlComposer.responseUrl(with: JsonLibrary.questionResponse())!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(contain(URLQueryItem(name: "rp[key]", value: "value")))
          expect(query).to(contain(URLQueryItem(name: "rp[key2]", value: "value2")))
          expect(query).to(contain(URLQueryItem(name: "rp[key3]", value: "value3")))
        }
        it("creates proper single response query") {
          let answer = AnswerResponse(id: 5, alias: nil, text: nil)
          let question = QuestionResponse(id: 4, alias: nil, answerList: [answer])
          let response = NodeResponse.question(question)
          let url = urlComposer.responseUrl(with: response)!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(contain(URLQueryItem(name: "r[4][]", value: "5")))
        }
        it("creates proper multi response query") {
          let answerOne = AnswerResponse(id: 5, alias: nil, text: nil)
          let answerTwo = AnswerResponse(id: 6, alias: nil, text: nil)
          let question = QuestionResponse(id: 4, alias: nil, answerList: [answerOne, answerTwo])
          let response = NodeResponse.question(question)
          let url = urlComposer.responseUrl(with: response)!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(contain(URLQueryItem(name: "r[4][]", value: "5")))
          expect(query).to(contain(URLQueryItem(name: "r[4][]", value: "6")))
        }
        it("creates proper text response query") {
          let answer = AnswerResponse(id: nil, alias: nil, text: "test")
          let question = QuestionResponse(id: 4, alias: nil, answerList: [answer])
          let response = NodeResponse.question(question)
          let url = urlComposer.responseUrl(with: response)!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(contain(URLQueryItem(name: "r[4][text]", value: "test")))
        }
        it("creates proper freeform comment response query") {
          let answer = AnswerResponse(id: 3, alias: nil, text: "test")
          let question = QuestionResponse(id: 4, alias: nil, answerList: [answer])
          let response = NodeResponse.question(question)
          let url = urlComposer.responseUrl(with: response)!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(contain(URLQueryItem(name: "re[4][3]", value: "test")))
        }
        it("creates proper response query for leadGen") {
          let answerOne = AnswerResponse(id: nil, alias: nil, text: "test1")
          let questionOne = QuestionResponse(id: 44, alias: nil, answerList: [answerOne])
          let answerTwo = AnswerResponse(id: nil, alias: nil, text: "test2")
          let questionTwo = QuestionResponse(id: 55, alias: nil, answerList: [answerTwo])
          let leadGen = LeadGenResponse(id: 5, alias: nil, questionList: [questionOne, questionTwo])
          let response = NodeResponse.leadGen(leadGen)
          let url = urlComposer.responseUrl(with: response)!
          let components = URLComponents(url: url,
                                         resolvingAgainstBaseURL: false)!
          let query = components.queryItems
          expect(query).to(contain(URLQueryItem(name: "r[44][text]", value: "test1")))
          expect(query).to(contain(URLQueryItem(name: "r[55][text]", value: "test2")))
        }
      }
      
    }
  }
}
