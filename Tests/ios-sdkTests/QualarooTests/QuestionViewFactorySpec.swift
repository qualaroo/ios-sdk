//
//  QuestionViewFactorySpec.swift
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

class QuestionViewFactorySpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("QuestionViewFactory") {
      var factory: QuestionViewFactory!
      var buttonHandler: SurveyPresenterMock!
      var answerHandler: SurveyInteractorMock!
      var question: Question!
      beforeEach {
        buttonHandler = SurveyPresenterMock()
        answerHandler = SurveyInteractorMock()
        let theme = Theme.create(with: JsonLibrary.newColorTheme(),
                                 logoUrlString: "https://qualaroo.com",
                                 fullscreen: true,
                                 closeButtonVisible: true,
                                 progressBar: "none")!
        factory = QuestionViewFactory(buttonHandler: buttonHandler,
                                      answerHandler: answerHandler,
                                      theme: theme)
      }
      context("binary question") {
        var view: AnswerBinaryView!
        beforeEach {
          let firstAnswer = JsonLibrary.answer(id: 1,
                                               title: "1")
          let secondAnswer = JsonLibrary.answer(id: 2,
                                                title: "2")
          let dict = JsonLibrary.question(type: "binary",
                                          answerList: [firstAnswer, secondAnswer])
          question = try! QuestionFactory(with: dict).build()
          view = factory.createView(with: question) as? AnswerBinaryView
        }
        it("creates binary question") {
          let leftButtonTitle = view.leftButton.title(for: .normal)
          expect(leftButtonTitle).to(equal("1"))
          let rightButtonTitle = view.rightButton.title(for: .normal)
          expect(rightButtonTitle).to(equal("2"))
        }
        it("handling left button event") {
          view.leftButtonPressed()
          expect(answerHandler.answerChangedValue).notTo(beNil())
        }
        it("handling right button event") {
          view.rightButtonPressed()
          expect(answerHandler.answerChangedValue).notTo(beNil())
        }
      }
      context("radio question") {
        var view: AnswerListView!
        beforeEach {
          var lastAnswer = JsonLibrary.answer(id: 40, title: "4")
          lastAnswer["explain_type"] = "short"
          let answers = [JsonLibrary.answer(id: 10, title: "1"),
                         JsonLibrary.answer(id: 20, title: "2"),
                         JsonLibrary.answer(id: 30, title: "3"),
                         lastAnswer]
          let dict = JsonLibrary.question(type: "radio",
                                          answerList: answers)
          question = try! QuestionFactory(with: dict).build()
          view = factory.createView(with: question) as! AnswerListView
        }
        it("creates radio question") {
          let answersShowed = view.selectableViews.count
          expect(answersShowed).to(equal(4))
          let firstAnswer = view.selectableViews.first
          expect(firstAnswer?.titleLabel.text).to(equal("1"))
        }
        it("supports freeform comments") {
          let firstAnswer = view.selectableViews.first
          expect(firstAnswer?.titleLabel.text).to(equal("1"))
          expect(firstAnswer?.isCommentAllowed).to(beFalse())
          let lastAnswer = view.selectableViews.last
          expect(lastAnswer?.titleLabel.text).to(equal("4"))
          expect(lastAnswer?.isCommentAllowed).to(beTrue())
        }
      }
      context("checkbox question") {
        var view: AnswerListView!
        beforeEach {
          var lastAnswer = JsonLibrary.answer(id: 40, title: "4")
          lastAnswer["explain_type"] = "short"
          let answers = [JsonLibrary.answer(id: 10, title: "1"),
                         JsonLibrary.answer(id: 20, title: "2"),
                         JsonLibrary.answer(id: 30, title: "3"),
                         lastAnswer]
          let dict = JsonLibrary.question(type: "checkbox",
                                          answerList: answers)
          question = try! QuestionFactory(with: dict).build()
          view = factory.createView(with: question) as! AnswerListView
        }
        it("creates radio question") {
          let answersShowed = view.selectableViews.count
          expect(answersShowed).to(equal(4))
          let firstAnswer = view.selectableViews.first
          expect(firstAnswer?.titleLabel.text).to(equal("1"))
        }
        it("supports freeform comments") {
          let firstAnswer = view.selectableViews.first
          expect(firstAnswer?.titleLabel.text).to(equal("1"))
          expect(firstAnswer?.isCommentAllowed).to(beFalse())
          let lastAnswer = view.selectableViews.last
          expect(lastAnswer?.titleLabel.text).to(equal("4"))
          expect(lastAnswer?.isCommentAllowed).to(beTrue())
        }
      }
      context("dropdown question") {
        var view: AnswerDropdownView!
        beforeEach {
          let answers = [JsonLibrary.answer(), JsonLibrary.answer()]
          question = try! QuestionFactory(with: JsonLibrary.question(type: "dropdown",
                                                                     answerList: answers)).build()
          view = factory.createView(with: question) as! AnswerDropdownView
        }
        it("creates dropdorn question") {
          expect(view.picker.numberOfComponents).to(equal(1))
          expect(view.picker.numberOfRows(inComponent: 0)).to(equal(2))
        }
        it("handles picker events") {
          view.pickerView(view.picker,
                          didSelectRow: 0,
                          inComponent: 0)
          expect(answerHandler.answerChangedValue).notTo(beNil())
        }
      }
      context("text question") {
        var view: AnswerTextView!
        beforeEach {
          let question = try! QuestionFactory(with: JsonLibrary.question(type: "text")).build()
          view = factory.createView(with: question) as! AnswerTextView
        }
        it("creates text question") {
          expect(view).notTo(beNil())
        }
        it("sends event when text changes") {
          view.textViewDidChange(view.responseTextView)
          expect(answerHandler.answerChangedValue).notTo(beNil())
        }
      }
      context("nps question") {
        var view: AnswerNpsView!
        beforeEach {
          let answers = Array(repeating: JsonLibrary.answer(), count: 11)
          var dict = JsonLibrary.question(type: "nps",
                                          answerList: answers)
          dict["nps_min_label"] = "MIN"
          dict["nps_max_label"] = "MAX"
          let question = try! QuestionFactory(with: dict).build()
          view = factory.createView(with: question) as! AnswerNpsView
        }
        it("creates nps question") {
          expect(view.minLabel.text).to(equal("MIN"))
          expect(view.maxLabel.text).to(equal("MAX"))
        }
      }
    }
  }
}
