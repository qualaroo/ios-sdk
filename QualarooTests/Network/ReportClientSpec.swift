//
//  ReportClientSpec.swift
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

class ReportClientSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("ReportClient") {
      context("sending response") {
        var scheduler: ReportRequestProtocolMock!
        var urlComposer: UrlComposerMock!
        var memory: ReportRequestMemoryProtocol!
        beforeEach {
          scheduler = ReportRequestProtocolMock()
          urlComposer = UrlComposerMock()
          memory = PersistentMemory()
        }
        it("send request with given url") {
          let url = URL(string: "https://qualaroo.com")!
          urlComposer.returnUrlValue = url
          let reportClient = ReportClient(scheduler, urlComposer, memory)
          reportClient.sendResponse(JsonLibrary.questionResponse())
          expect(scheduler.scheduleRequestUrl).to(equal(url))
        }
        it("don't send request if url was nil") {
          let reportClient = ReportClient(scheduler, UrlComposerMock(), memory)
          reportClient.sendResponse(JsonLibrary.questionResponse())
          expect(scheduler.scheduleRequestUrl).to(beNil())
        }
      }
      context("recording impression") {
        let memory = PersistentMemory()
        it("send request with given url") {
          let url = URL(string: "https://qualaroo.com")!
          let urlComposer = UrlComposerMock()
          urlComposer.returnUrlValue = url
          let scheduler = ReportRequestProtocolMock()
          let reportClient = ReportClient(scheduler, urlComposer, memory)
          reportClient.recordImpression()
          expect(scheduler.scheduleRequestUrl).to(equal(url))
        }
        it("don't send request if url was nil") {
          let scheduler = ReportRequestProtocolMock()
          let reportClient = ReportClient(scheduler, UrlComposerMock(), memory)
          reportClient.recordImpression()
          expect(scheduler.scheduleRequestUrl).to(beNil())
        }
      }
    }
  }
}
