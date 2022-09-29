//  SurveyPresenterSpec.swift
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

class SurveyPresenterSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("Survey Presenter") {
      var presenter: SurveyPresenter!
      var interactor = SurveyInteractorMock()
      var view = SurveyViewMock()
      let converter = PropertyInjector(customProperties: CustomProperties([:]))
      let partscreenTheme = Theme.create(with: JsonLibrary.newColorTheme(),
                                         logoUrlString: "https://www.qualaroo.com",
                                         fullscreen: false,
                                         closeButtonVisible: true,
                                         progressBar: "none")!
      let fullscreenTheme = Theme.create(with: JsonLibrary.newColorTheme(),
                                         logoUrlString: "https://www.qualaroo.com",
                                         fullscreen: true,
                                         closeButtonVisible: true,
                                         progressBar: "none")!
      beforeEach {
        interactor = SurveyInteractorMock()
        view = SurveyViewMock()
        presenter = SurveyPresenter(theme: fullscreenTheme,
                                    interactor: interactor,
                                    converter: converter)
      }
      context("SurveyViewDelegate") {
        it("should setup loaded SurveyViewInterface") {
          presenter.viewLoaded(view)
          let black = UIColor(fromHex: "#000000")
          expect(view.backgroundColorValue).to(equal(black))
          expect(view.textColorValue).to(equal(black))
          expect(view.buttonEnabledColorValue).to(equal(black))
          expect(view.buttonDisabledColorValue).to(equal(black))
          expect(view.buttonTextEnabledColorValue).to(equal(black))
          expect(view.buttonTextDisabledColorValue).to(equal(black))
          expect(view.logoUrlValue).notTo(beNil())
          expect(view.uiNormalColorValue).to(equal(black))
          expect(view.showCloseButtonValue).to(beTrue())
          expect(view.fullscreenValue).to(beTrue())
            expect(view.dimStyleValue).to(equal(UIBlurEffect.Style.dark))
        }
        it("should not animate dim whem survey displayed on fullscreen") {
          let view = SurveyViewMock()
          presenter = SurveyPresenter(theme: fullscreenTheme,
                                      interactor: interactor,
                                      converter: converter)
          presenter.viewDisplayed(view)
          expect(view.dimBackgroundFlag).to(beFalse())
        }
        it("should animate dim whem survey displayed not on fullscreen") {
          let view = SurveyViewMock()
          presenter = SurveyPresenter(theme: partscreenTheme,
                                      interactor: interactor,
                                      converter: converter)
          presenter.viewDisplayed(view)
          expect(view.dimBackgroundFlag).to(beTrue())
        }
        it("should pass info to interactor when user tapped dim") {
          presenter.backgroundDimTapped()
          expect(interactor.userWantToCloseSurveyFlag).to(beTrue())
        }
        it("sholud pass info to interactor when user tapped close button") {
          presenter.closeButtonPressed()
          expect(interactor.userWantToCloseSurveyFlag).to(beTrue())
        }
      }
      context("SurveyPresenterProtocol") {
        it("should enable button when asked") {
          presenter.viewLoaded(view)
          expect(view.enableNextButtonFlag).to(beFalse())
          presenter.enableButton()
          expect(view.enableNextButtonFlag).to(beTrue())
        }
        it("should disable button when asked") {
          presenter.viewLoaded(view)
          expect(view.disableNextButtonFlag).to(beFalse())
          presenter.disableButton()
          expect(view.disableNextButtonFlag).to(beTrue())
        }
        it("should close survey when asked") {
          presenter.viewLoaded(view)
          expect(view.closeSurveyDimValue).to(beNil())
          presenter.closeSurvey()
          expect(view.closeSurveyDimValue).notTo(beNil())
        }
        it("should close survey with dimming when not fullscreen") {
          presenter = SurveyPresenter(theme: partscreenTheme,
                                      interactor: interactor,
                                      converter: converter)
          presenter.viewLoaded(view)
          expect(view.closeSurveyDimValue).to(beNil())
          presenter.closeSurvey()
          expect(view.closeSurveyDimValue).to(beTrue())
        }
        it("should close survey without dimming when fullscreen") {
          presenter = SurveyPresenter(theme: fullscreenTheme,
                                      interactor: interactor,
                                      converter: converter)
          presenter.viewLoaded(view)
          expect(view.closeSurveyDimValue).to(beNil())
          presenter.closeSurvey()
          expect(view.closeSurveyDimValue).to(beFalse())
        }
        it("should focus on input") {
          presenter.viewLoaded(view)
          expect(view.focusOnInputFlag).to(beFalse())
          presenter.focusOnInput()
          expect(view.focusOnInputFlag).to(beTrue())
        }
      }
    }
  }
}
