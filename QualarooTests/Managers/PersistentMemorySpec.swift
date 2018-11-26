//
//  PersistentMemorySpec.swift
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

class PersistentMemorySpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("PersistentMemory") {
      let memory = PersistentMemory()
      beforeEach {
        memory.resetStoredData()
      }
      context("SimpleRequestMemoryProtocol") {
        it("saves and loads simple request list") {
          let list = ["one", "two"]
          memory.store(reportRequest: "one")
          memory.store(reportRequest: "two")
          
          let loadedList = memory.getAllRequests()
          expect(loadedList).to(equal(list))
        }
        
        it("removes saved list") {
          memory.store(reportRequest: "one")
          memory.store(reportRequest: "two")
          
          memory.remove(reportRequest: "one")
          memory.remove(reportRequest: "two")
        
          let loadedList = memory.getAllRequests()
          expect(loadedList).to(beEmpty())
        }
      }
      context("SeenSurveyMemoryProtocol") {
        it("remembers that survey has been seen") {
          memory.saveUserHaveSeen(surveyWithID: 1)
          expect(memory.checkIfUserHaveSeen(surveyWithID: 1)).to(beTrue())
        }
        it("remembers that survey with given ID has been seen") {
          memory.saveUserHaveSeen(surveyWithID: 1)
          expect(memory.checkIfUserHaveSeen(surveyWithID: 2)).to(beFalse())
        }
        it("remembers that few surveys have been seen") {
          memory.saveUserHaveSeen(surveyWithID: 1)
          memory.saveUserHaveSeen(surveyWithID: 2)
          expect(memory.checkIfUserHaveSeen(surveyWithID: 1)).to(beTrue())
          expect(memory.checkIfUserHaveSeen(surveyWithID: 2)).to(beTrue())
        }
      }
      context("FinishedSurveyMemoryProtocol") {
        it("remembers that survey has been finished") {
          memory.saveUserHaveFinished(surveyWithID: 1)
          expect(memory.checkIfUserHaveFinished(surveyWithID: 1)).to(beTrue())
        }
        it("remembers that few surveys have been finished") {
          memory.saveUserHaveFinished(surveyWithID: 1)
          memory.saveUserHaveFinished(surveyWithID: 2)
          expect(memory.checkIfUserHaveFinished(surveyWithID: 1)).to(beTrue())
          expect(memory.checkIfUserHaveFinished(surveyWithID: 2)).to(beTrue())
        }
      }
      context("SamplePercentMemoryProtocol") {
        it("saves sample procent for every survey") {
          memory.saveSamplePercent(1, forSurveyId: 1)
          memory.saveSamplePercent(20, forSurveyId: 2)
          let firstProcent = memory.getSamplePercent(forSurveyId: 1)
          let secondProcent = memory.getSamplePercent(forSurveyId: 2)
          expect(firstProcent).to(equal(1))
          expect(secondProcent).to(equal(20))
        }
        it("returns nil for not saved survey") {
          let procent = memory.getSamplePercent(forSurveyId: 3)
          expect(procent).to(beNil())
        }
      }
      context("DeviceIdMemoryProtocol") {
        it("returns vendor id if nothing was set") {
          let firstTry = memory.getDeviceId()
          let vendorId = UIDevice.current.identifierForVendor?.uuidString
          expect(firstTry).notTo(beNil())
          expect(firstTry).to(equal(vendorId))
        }

        it("returns same deviceId") {
          let firstTry = memory.getDeviceId()
          let secondTry = memory.getDeviceId()
          expect(firstTry).to(equal(secondTry))
        }
      }
      context("DefaultLogoNameMemoryProtocol") {
        it("saves default logo name") {
          memory.saveDefaultLogoName("name")
          let savedName = memory.getDefaultLogoName()
          expect(savedName).to(equal("name"))
        }
        it("returns nil if nothing was saved") {
          let savedName = memory.getDefaultLogoName()
          expect(savedName).to(beNil())
        }
      }
    }
  }
}
