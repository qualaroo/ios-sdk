//
//  AutotrackingManagerSpec.swift
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

class MethodSwizzlerMock: MethodSwizzler {
  var swizzledCount: Int = 0
  override func swizzle(_ firstSelector: Selector,
                        with secondSelector: Selector,
                        aClass: AnyClass) { swizzledCount += 1 }
}

class AutotrackingManagerSpec: QuickSpec {
  override func spec() {
    super.spec()
  
    describe("AutotrackingManager") {
      var manager: AutotrackingManager!
      var swizzler: MethodSwizzlerMock!
      beforeEach {
        swizzler = MethodSwizzlerMock()
        manager = AutotrackingManager(swizzler: swizzler)
      }
      context("autotracking") {
        it("is disabled by default it is changing implementation if needed") {
          expect(swizzler.swizzledCount).to(equal(0))
          manager.enableAutotracking()
          expect(swizzler.swizzledCount).to(equal(1))
          manager.enableAutotracking()
          expect(swizzler.swizzledCount).to(equal(1))
          manager.disableAutotracking()
          expect(swizzler.swizzledCount).to(equal(2))
          manager.disableAutotracking()
          expect(swizzler.swizzledCount).to(equal(2))
        }
      }
    }
  }
}
