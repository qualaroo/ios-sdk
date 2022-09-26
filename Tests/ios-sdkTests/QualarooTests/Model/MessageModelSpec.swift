//
//  MessageModelSpec.swift
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

class MessageModelSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("Message") {
      context("equatable") {
        it("is equal to another message if have the same description and id") {
          let firstDict = JsonLibrary.message(id: 4, description: "1")
          let firstMessage = try! MessageFactory(with: firstDict).build()
          let secondDict = JsonLibrary.message(id: 4, description: "1")
          let secondMessage = try! MessageFactory(with: secondDict).build()
          
          expect(firstMessage).to(equal(secondMessage))
        }
        it("is not equal to another message if have different description") {
          let firstDict = JsonLibrary.message(id: 4, description: "1")
          let firstMessage = try! MessageFactory(with: firstDict).build()
          let secondDict = JsonLibrary.message(id: 4, description: "2")
          let secondMessage = try! MessageFactory(with: secondDict).build()
          
          expect(firstMessage).notTo(equal(secondMessage))
        }
        it("is not equal to another message if have different id") {
          let firstDict = JsonLibrary.message(id: 4, description: "1")
          let firstMessage = try! MessageFactory(with: firstDict).build()
          let secondDict = JsonLibrary.message(id: 5, description: "1")
          let secondMessage = try! MessageFactory(with: secondDict).build()
          
          expect(firstMessage).notTo(equal(secondMessage))
        }
      }
      context("message") {
        it("is created from good dictionary") {
          let dict = JsonLibrary.message(id: 1, description: "Thank you!")
          let message = try! MessageFactory(with: dict).build()
          expect(message.messageId).to(equal(1))
          expect(message.description).to(equal("Thank you!"))
        }
        it("throws error if there is no id") {
          let dict = JsonLibrary.message(id: nil, description: "Thank you!")
          let factory = MessageFactory(with: dict)
          
          expect { try factory.build() }.to(throwError())
        }
        it("throws error if there is no text") {
          let dict = JsonLibrary.message(id: 1, description: nil)
          let factory = MessageFactory(with: dict)
          
          expect { try factory.build() }.to(throwError())
        }
      }
      context("call to action") {
        it("should have call to action if dict was ok") {
          let dict = JsonLibrary.message(ctaMap: ["text": "text", "uri": "https://qualaroo.com"])
          let message = try! MessageFactory(with: dict).build()
          expect(message.callToAction?.text).to(equal("text"))
          expect(message.callToAction?.url).to(equal(URL(string: "https://qualaroo.com")))
        }
        it("shouldn't have call to action if dict don't have text") {
          let dict = JsonLibrary.message(ctaMap: ["url": "https://qualaroo.com"])
          let message = try! MessageFactory(with: dict).build()
          expect(message.callToAction).to(beNil())
        }
        it("shouldn't have call to action if dict don't have url") {
          let dict = JsonLibrary.message(ctaMap: ["text": "text"])
          let message = try! MessageFactory(with: dict).build()
          expect(message.callToAction).to(beNil())
        }
      }
    }

  }
}
