//
//  PropertyInjectorSpec.swift
//  QualarooTests
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

class TextConverterSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("PropertyInjector") {
      var injector: PropertyInjector!
      var customProperties: CustomProperties!
      beforeEach {
        customProperties = CustomProperties(["property": "value",
                                             "name": "Jake"])
        injector = PropertyInjector(customProperties: customProperties)
      }
      context("TextConverter") {
        it("replaces placeholder with value") {
          let text = "Text with ${property}."
          let result = injector.convert(text)
          expect(result).to(equal("Text with value."))
        }
        it("replaces two different placeholders with values") {
          let text = "${name} with ${property}."
          let result = injector.convert(text)
          expect(result).to(equal("Jake with value."))
        }
        it("replaces two same placeholders with values") {
          let text = "${name} with ${name}."
          let result = injector.convert(text)
          expect(result).to(equal("Jake with Jake."))
        }
        it("removes missing properties") {
          let text = "${surname} with ${name}."
          let result = injector.convert(text)
          expect(result).to(equal(" with Jake."))
        }
      }
      context("FilterProtocol") {
        var survey: Survey!
        it("passes when survey has no personalized titles and descriptions") {
          let questions = [JsonLibrary.question(),
                           JsonLibrary.question(),
                           JsonLibrary.question()]
          survey = try! SurveyFactory(with: JsonLibrary.survey(questionList: ["en": questions])).build()
          let result = injector.shouldShow(survey: survey)
          expect(result).to(beTrue())
        }
        it("passes when all custom properties used in titles are set") {
          let questions = [JsonLibrary.question(title: "Hi ${name}.",
                                                description: "${property}")]
          survey = try! SurveyFactory(with: JsonLibrary.survey(questionList: ["en": questions])).build()
          let result = injector.shouldShow(survey: survey)
          expect(result).to(beTrue())
        }
        it("fails when there is property missing in message description") {
          let messages = [JsonLibrary.message(description: "Bye ${unknown}.")]
          survey = try! SurveyFactory(with: JsonLibrary.survey(messagesList: ["en": messages])).build()
          let result = injector.shouldShow(survey: survey)
          expect(result).to(beFalse())
        }
        it("fails when there is property missing in leadGen description") {
          let leadGens = [JsonLibrary.leadGenForm(description: "${unknown}")]
          survey = try! SurveyFactory(with: JsonLibrary.survey(leadGenFormList: ["en": leadGens])).build()
          let result = injector.shouldShow(survey: survey)
          expect(result).to(beFalse())
        }
        it("fails when there is property missing in question title") {
          let questions = [JsonLibrary.question(title: "Hi ${name} ${surname}.")]
          survey = try! SurveyFactory(with: JsonLibrary.survey(questionList: ["en": questions])).build()
          let result = injector.shouldShow(survey: survey)
          expect(result).to(beFalse())
        }
        it("fails when there is property missing in message description") {
          let questions = [JsonLibrary.question(title: "Hi Jake.",
                                                description: "${unknown}")]
          survey = try! SurveyFactory(with: JsonLibrary.survey(questionList: ["en": questions])).build()
          let result = injector.shouldShow(survey: survey)
          expect(result).to(beFalse())
        }
      }
    }
  }
}
