//
//  QuestionModelSpec.swift
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

class QuestionModelSpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("questions initializations") {
      context("equatable") {
        it("is equal to another question with same proporties") {
          let first = QuestionFactory(with: JsonLibrary.question(id: 1, type: "text", title: "title"))
          let second = QuestionFactory(with: JsonLibrary.question(id: 1, type: "text", title: "title"))
          let firstQuestion = try! first.build()
          let secondQuestion = try! second.build()
          expect(firstQuestion).to(equal(secondQuestion))
        }
        it("is not equal to another question with different type") {
          let first = JsonLibrary.question(id: 1, type: "radio", answerList: [JsonLibrary.answer()])
          let second = JsonLibrary.question(id: 1, type: "checkbox", answerList: [JsonLibrary.answer()])
          let firstQuestion = try! QuestionFactory(with: first).build()
          let secondQuestion = try! QuestionFactory(with: second).build()
          expect(firstQuestion).notTo(equal(secondQuestion))
        }
        it("is not equal to another question with different Id") {
          let first = QuestionFactory(with: JsonLibrary.question(id: 1, type: "text", title: "title"))
          let second = QuestionFactory(with: JsonLibrary.question(id: 2, type: "text", title: "title"))
          let firstQuestion = try! first.build()
          let secondQuestion = try! second.build()
          expect(firstQuestion).notTo(equal(secondQuestion))
        }
      }
      context("radio question") {
        it("is created from good dictionary") {
          let first = JsonLibrary.answer(id: 999768,
                                         title: "Very disappointed",
                                         nextMap: ["id": 345691,
                                                   "node_type": "question"])
          let second = JsonLibrary.answer(id: 999769,
                                          title: "Somewhat disappointed",
                                          nextMap: ["id": 345691,
                                                    "node_type": "question"])
          let third = JsonLibrary.answer(id: 999770,
                                         title: "Not disappointed",
                                         nextMap: ["id": 345691,
                                                   "node_type": "question"])
          let answersDict = [first, second, third]
          let dict = JsonLibrary.question(id: 352640,
                                          type: "radio",
                                          title: "Title",
                                          description: "Description",
                                          answerList: answersDict,
                                          disableRandom: true)
          let answerList = [try! AnswerFactory(with: first).build(),
                            try! AnswerFactory(with: second).build(),
                            try! AnswerFactory(with: third).build()]
          let question = try! QuestionFactory(with: dict).build()
          expect(question.answerList).to(haveCount(3))
          expect(question.answerList).to(equal(answerList))
          expect(question.title).to(equal("Title"))
          expect(question.type).to(equal(Question.Category.radio))
          expect(question.description).to(equal("Description"))
          expect(question.nextNodeId).to(beNil())
        }
        it("is not created from dictionary without title") {
          var badQuestion = JsonLibrary.question(id: 345691, type: "radio")
          badQuestion["title"] = NSNull()
          let factory = QuestionFactory(with: badQuestion)
          expect { try factory.build() }.to(throwError())
        }
        it("is not created from dictionary without id") {
          var badQuestion = JsonLibrary.question(type: "radio")
          badQuestion["id"] = NSNull()
          let factory = QuestionFactory(with: badQuestion)
          expect { try factory.build() }.to(throwError())
        }
        it("is not created from dictionary with string id type") {
          var badQuestion = JsonLibrary.question(type: "radio")
          badQuestion["id"] = "text"
          let factory = QuestionFactory(with: badQuestion)
          expect { try factory.build() }.to(throwError())
        }
        it("is not created if there is no answers") {
          var badQuestion = JsonLibrary.question(type: "radio")
          badQuestion["answer_list"] = [[:]]
          let factory = QuestionFactory(with: badQuestion)
          expect { try factory.build() }.to(throwError())
        }
      }
      context("description placement") {
        it("should place description before title") {
          var dict = JsonLibrary.question(description: "description")
          dict["description_placement"] = "before"
          let question = try! QuestionFactory(with: dict).build()
          let placement = question.descriptionPlacement
          expect(placement).to(equal(Question.DescriptionPlacement.before))
        }
        it("should place description after title") {
          var dict = JsonLibrary.question(description: "description")
          dict["description_placement"] = "after"
          let question = try! QuestionFactory(with: dict).build()
          let placement = question.descriptionPlacement
          expect(placement).to(equal(Question.DescriptionPlacement.after))
        }
        it("should place description after title if not specified") {
          var dict = JsonLibrary.question(description: "description")
          dict["description_placement"] = NSNull()
          let question = try! QuestionFactory(with: dict).build()
          let placement = question.descriptionPlacement
          expect(placement).to(equal(Question.DescriptionPlacement.after))
        }
      }
      context("anchor last answers") {
        it("should randomize question order") {
          let answerList = [JsonLibrary.answer(id: 1),
                            JsonLibrary.answer(id: 2),
                            JsonLibrary.answer(id: 3),
                            JsonLibrary.answer(id: 4)]
          let dict = JsonLibrary.question(type: "radio",
                                          answerList: answerList,
                                          disableRandom: false,
                                          anchorLast: false)
          let question = try! QuestionFactory(with: dict,
                                              listRandomizer: ListRandomizerMock()).build()
          expect(question.answerList).to(haveCount(4))
          let answersOrder = question.answerList.map({ $0.answerId })
          expect(answersOrder).notTo(equal([1, 2, 3, 4]))
        }
        it("should anchor last one answer if only anchorLast present") {
          let answerList = [JsonLibrary.answer(id: 1),
                            JsonLibrary.answer(id: 2),
                            JsonLibrary.answer(id: 3),
                            JsonLibrary.answer(id: 4)]
          let dict = JsonLibrary.question(type: "radio",
                                          answerList: answerList,
                                          disableRandom: false,
                                          anchorLast: true)
          let question = try! QuestionFactory(with: dict,
                                              listRandomizer: ListRandomizerMock()).build()
          let lastAnswerId = question.answerList.last!.answerId
          expect(lastAnswerId).to(equal(4))
          let answersOrder = question.answerList.map({ $0.answerId })
          expect(answersOrder).notTo(equal([1, 2, 3, 4]))
        }
        it("should anchor last three answers") {
          let answerList = [JsonLibrary.answer(id: 1),
                            JsonLibrary.answer(id: 2),
                            JsonLibrary.answer(id: 3),
                            JsonLibrary.answer(id: 4),
                            JsonLibrary.answer(id: 5)]
          var dict = JsonLibrary.question(type: "radio",
                                          answerList: answerList,
                                          disableRandom: false,
                                          anchorLast: true)
          dict["anchor_last_count"] = 3
          let question = try! QuestionFactory(with: dict,
                                              listRandomizer: ListRandomizerMock()).build()
          let answersOrder = question.answerList.map({ $0.answerId })
          expect(answersOrder).notTo(equal([1, 2, 3, 4, 5]))
          let lastThreeOrder = Array(answersOrder.suffix(3))
          expect(lastThreeOrder).to(equal([3, 4, 5]))
        }
        it("should always be required if radio, nps and dropdown type") {
          let answers = Array(repeating: JsonLibrary.answer(), count: 11)
          var dict = JsonLibrary.question(type: "radio",
                                          answerList: answers)
          dict["is_required"] = NSNull()
          var question = try! QuestionFactory(with: dict).build()
          expect(question.isRequired).to(beTrue())
          dict["type"] = "nps"
          dict["nps_min_label"] = ""
          dict["nps_max_label"] = ""
          question = try! QuestionFactory(with: dict).build()
          expect(question.isRequired).to(beTrue())
          dict["type"] = "dropdown"
          question = try! QuestionFactory(with: dict).build()
          expect(question.isRequired).to(beTrue())
        }
        it("shouldn't preset required for text type") {
          var dict = JsonLibrary.question(type: "text")
          var question = try! QuestionFactory(with: dict).build()
          expect(question.isRequired).to(beFalse())
          dict["is_required"] = true
          question = try! QuestionFactory(with: dict).build()
          expect(question.isRequired).to(beTrue())
        }
        it("shouldn't preset required for checkbox type") {
          var dict = JsonLibrary.question(type: "checkbox", answerList: [JsonLibrary.answer()])
          var question = try! QuestionFactory(with: dict).build()
          expect(question.isRequired).to(beFalse())
          dict["is_required"] = true
          question = try! QuestionFactory(with: dict).build()
          expect(question.isRequired).to(beTrue())
        }
      }
      context("checkbox question") {
        it("has min and max answer count") {
          let answers = Array(repeating: JsonLibrary.answer(), count: 5)
          var goodQuestion = JsonLibrary.question(id: 1, type: "checkbox", answerList: answers)
          goodQuestion["min_answers_count"] = 2
          goodQuestion["max_answers_count"] = 3
          let question = try! QuestionFactory(with: goodQuestion).build()
          expect(question.minAnswersCount).to(equal(2))
          expect(question.maxAnswersCount).to(equal(3))
        }
        it("have backward compatibility with min and max answer count") {
          let answers = Array(repeating: JsonLibrary.answer(), count: 5)
          let goodQuestion = JsonLibrary.question(id: 1, type: "checkbox", answerList: answers)
          let question = try! QuestionFactory(with: goodQuestion).build()
          expect(question.minAnswersCount).to(equal(0))
          expect(question.maxAnswersCount).to(equal(5))
        }
        it("interfeere min answer count from isRequired param") {
          let answers = Array(repeating: JsonLibrary.answer(), count: 5)
          var goodQuestion = JsonLibrary.question(id: 1, type: "checkbox", answerList: answers)
          goodQuestion["is_required"] = true
          let question = try! QuestionFactory(with: goodQuestion).build()
          expect(question.minAnswersCount).to(equal(1))
        }
      }
      context("nps question") {
        it("is created from good dictionary") {
          let answers = Array(repeating: JsonLibrary.answer(), count: 11)
          var goodQuestion = JsonLibrary.question(id: 345691,
                                                  type: "nps",
                                                  title: "Title",
                                                  description: "Description",
                                                  answerList: answers)
          goodQuestion["nps_min_label"] = "Poor"
          goodQuestion["nps_max_label"] = "Awesome"
          goodQuestion["next_map"] = ["id": 123123]
          let question = try! QuestionFactory(with: goodQuestion).build()
          expect(question.answerList).to(haveCount(11))
          expect(question.title).to(equal("Title"))
          expect(question.type).to(equal(Question.Category.nps))
          expect(question.description).to(equal("Description"))
          expect(question.nextNodeId).to(equal(123123))
          expect(question.npsMinText!).to(equal("Poor"))
          expect(question.npsMaxText!).to(equal("Awesome"))
        }
        it("throws error if there is no min or max nps description") {
          let answers = Array(repeating: JsonLibrary.answer(), count: 11)
          var badQuestion = JsonLibrary.question(type: "nps",
                                                 answerList: answers)
          badQuestion["nps_min_label"] = NSNull()
          badQuestion["nps_max_label"] = "Awesome"
          badQuestion["next_map"] = ["id": 123123]
          let noMinNps = QuestionFactory(with: badQuestion)
          expect { try noMinNps.build() }.to(throwError())
          badQuestion["nps_min_label"] = "Poor"
          badQuestion["nps_max_label"] = NSNull()
          let noMaxNps =  QuestionFactory(with: badQuestion)
          expect { try noMaxNps.build() }.to(throwError())
        }
        it("throws error if the number of answers isn't 11") {
          let answers = Array(repeating: JsonLibrary.answer(), count: 9)
          var badQuestion = JsonLibrary.question(type: "nps",
                                                 answerList: answers)
          badQuestion["nps_min_label"] = "Poor"
          badQuestion["nps_max_label"] = "Awesome"
          badQuestion["next_map"] = ["id": 123123]
          let factory = QuestionFactory(with: badQuestion)
          
          expect { try factory.build() }.to(throwError())
        }
      }
      context("wrong questions") {
        it("throws error with unknown type") {
          let badQuestion = JsonLibrary.question(type: "unknown")
          let factory = QuestionFactory(with: badQuestion)
          
          expect { try factory.build() }.to(throwError())
        }
      }
    }
  }
}
