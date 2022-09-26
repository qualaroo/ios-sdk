//
//  SimpleRequestSchedulerSpec.swift
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

class SimpleRequestSchedulerSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("SimpleRequestScheduler") {
      var scheduler: SimpleRequestScheduler!
      beforeEach {
        scheduler = SimpleRequestScheduler(reachability: nil, storage: PersistentMemory())
        scheduler.removeObservers()
      }
      context("SimpleRequestProtocol") {
        it("schedule request when asked") {
          scheduler.privateQueue.isSuspended = true
          scheduler.scheduleRequest(URL(string: "https://qualaroo.com")!)
          let operations = scheduler.privateQueue.operations.filter { $0.isCancelled == false }
          expect(operations).to(haveCount(1))
        }
        it("schedule two request when asked") {
          scheduler.privateQueue.isSuspended = true
          scheduler.scheduleRequest(URL(string: "https://qualaroo.com")!)
          scheduler.scheduleRequest(URL(string: "https://qualaroo.com")!)
          let operations = scheduler.privateQueue.operations.filter { $0.isCancelled == false }
          expect(operations).to(haveCount(2))
        }
      }
    }
  }
}
