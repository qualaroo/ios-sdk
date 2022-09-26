//
//  ThemeModelSpec.swift
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

class ThemeModelSpec: QuickSpec {
  override func spec() {
    super.spec()
  
    describe("Theme") {
      context("creating") {
        it("should be configured for version before 1.5") {
          let theme = Theme.create(with: JsonLibrary.oldColorTheme(),
                                   logoUrlString: "https://qualaroo.com",
                                   fullscreen: true,
                                   closeButtonVisible: true,
                                   progressBar: "none")!
          expect(theme.colors.buttonTextDisabled).to(equal(theme.colors.buttonTextEnabled))
          expect(theme.fullscreen).to(beTrue())
          expect(theme.closeButtonVisible).to(beTrue())
        }
        it("should be configured for version after 1.5") {
          let theme = Theme.create(with: JsonLibrary.newColorTheme(),
                                   logoUrlString: "https://qualaroo.com",
                                   fullscreen: true,
                                   closeButtonVisible: true,
                                   progressBar: "none")!
          expect(theme.fullscreen).to(beTrue())
          expect(theme.closeButtonVisible).to(beTrue())
        }
        it("should fallback to predefined colors when some color is missing or invalid") {
          var dict = JsonLibrary.newColorTheme()
          dict["background_color"] = NSNull()
          var theme = Theme.create(with: dict,
                                   logoUrlString: "https://qualaroo.com",
                                   fullscreen: true,
                                   closeButtonVisible: true,
                                   progressBar: "none")
        
          expect(theme?.colors).to(equal(Theme.fallbackColorTheme()))
          
          dict["button_enabled_color"] = "red"
          theme = Theme.create(with: dict,
                                   logoUrlString: "https://qualaroo.com",
                                   fullscreen: true,
                                   closeButtonVisible: true,
                                   progressBar: "none")
      
          expect(theme?.colors).to(equal(Theme.fallbackColorTheme()))
        }
   
        it("should have white keyboard for light dim") {
          var dict = JsonLibrary.newColorTheme()
          dict["dim_type"] = "light"
          let theme = Theme.create(with: dict,
                                   logoUrlString: "https://qualaroo.com",
                                   fullscreen: true,
                                   closeButtonVisible: true,
                                   progressBar: "none")!
          expect(theme.dimType).to(equal(UIBlurEffectStyle.light))
          expect(theme.keyboardStyle).to(equal(UIKeyboardAppearance.light))
        }
        it("should have white keyboard for very light dim") {
          var dict = JsonLibrary.newColorTheme()
          dict["dim_type"] = "very_light"
          let theme = Theme.create(with: dict,
                                   logoUrlString: "https://qualaroo.com",
                                   fullscreen: true,
                                   closeButtonVisible: true,
                                   progressBar: "none")!
          expect(theme.dimType).to(equal(UIBlurEffectStyle.extraLight))
          expect(theme.keyboardStyle).to(equal(UIKeyboardAppearance.light))
        }
        it("should have black keyboard for dark dim") {
          var dict = JsonLibrary.newColorTheme()
          dict["dim_type"] = "dark"
          let theme = Theme.create(with: dict,
                                   logoUrlString: "https://qualaroo.com",
                                   fullscreen: true,
                                   closeButtonVisible: true,
                                   progressBar: "none")!
          expect(theme.dimType).to(equal(UIBlurEffectStyle.dark))
          expect(theme.keyboardStyle).to(equal(UIKeyboardAppearance.dark))

        }
      }
    }
  }
}
