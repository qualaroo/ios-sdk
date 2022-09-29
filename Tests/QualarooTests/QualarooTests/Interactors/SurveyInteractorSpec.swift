//
//  SurveyInteractorSpec.swift
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

class SurveyInteractorSpec: QuickSpec {
  override func spec() {
    super.spec()

    describe("SurveyInteractor") {
      var interactor: SurveyInteractor!
      var wireframe = SurveyWireframeMock()
      var presenter = SurveyPresenterMock()
      var storage = SurveysStorageMock()
      var networkClient = SimpleRequestMock()
      let urlOpener = UrlOpenerMock()
      var delegate: SurveyDelegateMock!
      let progressCalculator = ProgressCalculator(wireframe)
      beforeEach {
        wireframe = SurveyWireframeMock()
        presenter = SurveyPresenterMock()
        storage = SurveysStorageMock()
        networkClient = SimpleRequestMock()
        delegate = SurveyDelegateMock()
        interactor = SurveyInteractor(wireframe: wireframe,
                                      reportClient: networkClient,
                                      storage: storage,
                                      urlOpener: urlOpener,
                                      delegate: delegate,
                                      progressCalculator: progressCalculator)
        interactor.surveyPresenter = presenter
      }
      context("going to next node") {
        it("sends response for question") {
          let dict = JsonLibrary.question(type: "text")
          let question = try! QuestionFactory(with: dict).build()
          interactor.currentNode = question
          interactor.answerChanged(JsonLibrary.questionResponse())
          networkClient.sendResponseFlag = false
          
          interactor.goToNextNode()
          
          expect(networkClient.sendResponseFlag).to(beTrue())
        }
        it("doesn't send response if there isn't any") {
          let dict = JsonLibrary.question(type: "text")
          let question = try! QuestionFactory(with: dict).build()
          interactor.currentNode = question
          networkClient.sendResponseFlag = false
          
          interactor.goToNextNode()
          
          expect(networkClient.sendResponseFlag).to(beFalse())
        }
        it("clears current response") {
          let node = try! QuestionFactory(with: JsonLibrary.question(id: 1)).build()
          interactor.currentNode = node
          wireframe.nextQuestionValue = node
          interactor.answerChanged(JsonLibrary.questionResponse())
          
          interactor.goToNextNode()
          networkClient.sendResponseFlag = false
          interactor.goToNextNode()
          
          expect(networkClient.sendResponseFlag).to(beFalse())
        }
        it("shows next question with focus for question") {
          let current = try! QuestionFactory(with: JsonLibrary.question(id: 1)).build()
          let next = try! QuestionFactory(with: JsonLibrary.question(id: 2)).build()
          wireframe.nextQuestionValue = next
          interactor.currentNode = current
          
          interactor.goToNextNode()
          
          expect(presenter.presentedQuestion).to(equal(next))
          expect(presenter.focusOnInputFlag).to(beTrue())
        }
        it("shows next message with enabling button") {
          let question = try! QuestionFactory(with: JsonLibrary.question()).build()
          let nextMessage = try! MessageFactory(with: JsonLibrary.message()).build()
          wireframe.nextQuestionValue = nextMessage
          interactor.currentNode = question
          
          interactor.goToNextNode()
          
          expect(presenter.enableButtonFlag).to(beTrue())
          expect(presenter.presentedMessage).to(equal(nextMessage))
        }
        it("shows next lead gen with focus") {
          let question = try! QuestionFactory(with: JsonLibrary.question()).build()
          let nextLeadGen = try! LeadGenFormFactory(with: JsonLibrary.leadGenForm()).build()
          wireframe.nextQuestionValue = nextLeadGen
          interactor.currentNode = question
          
          interactor.goToNextNode()
          
          expect(presenter.presentedLeadGenForm).to(equal(nextLeadGen))
          expect(presenter.focusOnInputFlag).to(beTrue())
        }
        it("finishes survey if there is no next node after current question") {
          let question = try! QuestionFactory(with: JsonLibrary.question(type: "text")).build()
          interactor.currentNode = question
          wireframe.currentSurveyValue = 1
          presenter.closeSurveyFlag = false
          
          interactor.goToNextNode()
          
          expect(presenter.closeSurveyFlag).to(beTrue())
          expect(delegate.surveyDidFinishFlag).to(beTrue())
          expect(storage.saveUserHaveFinishedValue).to(equal(1))
        }
        it("sends response for leadGenForm") {
          let leadGen = try! LeadGenFormFactory(with: JsonLibrary.leadGenForm()).build()
          interactor.currentNode = leadGen
          interactor.answerChanged(JsonLibrary.emptyLeadGenResponse())
          networkClient.sendResponseFlag = false
          
          interactor.goToNextNode()
          
          expect(networkClient.sendResponseFlag).to(beTrue())
        }
        it("doesn't send response for leadGenForm if there isn't any") {
          let leadGen = try! LeadGenFormFactory(with: JsonLibrary.leadGenForm()).build()
          interactor.currentNode = leadGen
          networkClient.sendResponseFlag = false
          
          interactor.goToNextNode()
          
          expect(networkClient.sendResponseFlag).to(beFalse())
        }
        it("shows next node with focus for leadGenForm") {
          let leadGen = try! LeadGenFormFactory(with: JsonLibrary.leadGenForm()).build()
          let nextQuestion = try! QuestionFactory(with: JsonLibrary.question(type: "text")).build()
          wireframe.nextQuestionValue = nextQuestion
          interactor.currentNode = leadGen
          
          interactor.goToNextNode()
          
          expect(presenter.presentedQuestion).to(equal(nextQuestion))
          expect(presenter.focusOnInputFlag).to(beTrue())
        }
        it("finishes survey for message") {
          let message = try! MessageFactory(with: JsonLibrary.message()).build()
          let nextQuestion = try! QuestionFactory(with: JsonLibrary.question(type: "text")).build()
          wireframe.nextQuestionValue = nextQuestion
          wireframe.currentSurveyValue = 1
          interactor.currentNode = message
          presenter.closeSurveyFlag = false
          
          interactor.goToNextNode()
          
          expect(presenter.closeSurveyFlag).to(beTrue())
          expect(delegate.surveyDidFinishFlag).to(beTrue())
          expect(storage.saveUserHaveFinishedValue).to(equal(1))
        }
        it("open url for cta button on message") {
          let dict = JsonLibrary.message(ctaMap: ["text": "go",
                                                  "uri": "www.qualaroo.com"])
          interactor.currentNode = try! MessageFactory(with: dict).build()
          let url = URL(string: "www.qualaroo.com")
          
          interactor.goToNextNode()
          
          expect(urlOpener.openUrlValue).to(equal(url))
        }
        it("closes survey with error if there is no current node") {
          interactor.goToNextNode()
          
          expect(presenter.closeSurveyFlag).to(beTrue())
          expect(delegate.surveyDidCloseMessage).notTo(beNil())
        }
        it("doesn't send info about user response to delegate for question without alias") {
          let answer = AnswerResponse(id: nil,
                                      alias: "answer_1",
                                      text: "text")
          let model = QuestionResponse(id: 1,
                                       alias: nil,
                                       answerList: [answer])
          let response = NodeResponse.question(model)
          interactor.currentNode = try! QuestionFactory(with: JsonLibrary.question()).build()
          interactor.answerChanged(response)
          
          interactor.goToNextNode()
          
          expect(delegate.answersValue).to(beNil())
        }
        it("sends info about user response to delegate for question with alias and no answers selected") {
          let model = QuestionResponse(id: 1,
                                       alias: "question_1",
                                       answerList: [])
          let response = NodeResponse.question(model)
          interactor.currentNode = try! QuestionFactory(with: JsonLibrary.question()).build()
          interactor.answerChanged(response)
          
          interactor.goToNextNode()
          
          let userResponse = delegate.answersValue!
          expect(userResponse.getQuestionAlias()).to(equal("question_1"))
          expect(userResponse.getFilledElements()).to(haveCount(0))
        }
        it("sends info about user response to delegate for question with alias") {
          let answer = AnswerResponse(id: nil,
                                      alias: "answer_1",
                                      text: "text")
          let model = QuestionResponse(id: 1,
                                       alias: "question_1",
                                       answerList: [answer])
          let response = NodeResponse.question(model)
          interactor.currentNode = try! QuestionFactory(with: JsonLibrary.question()).build()
          interactor.answerChanged(response)
          
          interactor.goToNextNode()
          
          let userResponse = delegate.answersValue!
          expect(userResponse.getQuestionAlias()).to(equal("question_1"))
          expect(userResponse.getFilledElements()).to(equal(["answer_1"]))
          expect(userResponse.getElementText("answer_1")).to(equal("text"))
        }
      }
      context("trying to close survey") {
        it("dismisses survey on question when survey is optional") {
          let question = try! QuestionFactory(with: JsonLibrary.question()).build()
          interactor.currentNode = question
          
          interactor.userWantToCloseSurvey()
          
          expect(presenter.closeSurveyFlag).to(beTrue())
          expect(delegate.surveyDidDismissFlag).to(beTrue())
        }
        it("does nothing on question when survey is mandatory") {
          let question = try! QuestionFactory(with: JsonLibrary.question()).build()
          interactor.currentNode = question
          wireframe.isMandatoryValue = true
          
          interactor.userWantToCloseSurvey()
          
          expect(presenter.closeSurveyFlag).to(beFalse())
          expect(delegate.surveyDidFinishFlag).to(beFalse())
          expect(delegate.surveyDidDismissFlag).to(beFalse())
          expect(delegate.surveyDidCloseMessage).to(beNil())
        }
        it("dismisses survey on leadGen when survey is optional") {
          let leadGen = try! LeadGenFormFactory(with: JsonLibrary.leadGenForm()).build()
          interactor.currentNode = leadGen
          
          interactor.userWantToCloseSurvey()
          
          expect(presenter.closeSurveyFlag).to(beTrue())
          expect(delegate.surveyDidDismissFlag).to(beTrue())
        }
        it("does nothing on leadGen when survey is mandatory") {
          let leadGen = try! LeadGenFormFactory(with: JsonLibrary.leadGenForm()).build()
          interactor.currentNode = leadGen
          wireframe.isMandatoryValue = true
          
          interactor.userWantToCloseSurvey()
          
          expect(presenter.closeSurveyFlag).to(beFalse())
          expect(delegate.surveyDidFinishFlag).to(beFalse())
          expect(delegate.surveyDidDismissFlag).to(beFalse())
          expect(delegate.surveyDidCloseMessage).to(beNil())
        }
        it("finished survey on message when survey is optional") {
          let message = try! MessageFactory(with: JsonLibrary.message()).build()
          interactor.currentNode = message
          wireframe.currentSurveyValue = 1
          
          interactor.userWantToCloseSurvey()
          
          expect(presenter.closeSurveyFlag).to(beTrue())
          expect(delegate.surveyDidFinishFlag).to(beTrue())
          expect(storage.saveUserHaveFinishedValue).to(equal(1))
        }
        it("finished survey on message even when survey is mandatory") {
          let message = try! MessageFactory(with: JsonLibrary.message()).build()
          interactor.currentNode = message
          wireframe.isMandatoryValue = true
          wireframe.currentSurveyValue = 1
          
          interactor.userWantToCloseSurvey()
          
          expect(presenter.closeSurveyFlag).to(beTrue())
          expect(delegate.surveyDidFinishFlag).to(beTrue())
          expect(storage.saveUserHaveFinishedValue).to(equal(1))
        }
        it("closes if there is no current node") {
          interactor.currentNode = nil
          
          interactor.userWantToCloseSurvey()
          
          expect(presenter.closeSurveyFlag).to(beTrue())
          expect(delegate.surveyDidCloseMessage).notTo(beNil())
        }
      }
      context("getting new answer") {
        it("doesn't send response when there even is no 'Next' button on question") {
          var dict = JsonLibrary.question()
          dict["always_show_send"] = false
          let question = try! QuestionFactory(with: dict).build()
          interactor.currentNode = question
          
          interactor.answerChanged(JsonLibrary.questionResponse())
          
          expect(networkClient.sendResponseFlag).to(beFalse())
        }
        it("doesn't try do display next node even when there is no 'Next' button on question") {
          var dict = JsonLibrary.question()
          dict["always_show_send"] = false
          let question = try! QuestionFactory(with: dict).build()
          let nextQuestion = try! QuestionFactory(with: JsonLibrary.question()).build()
          interactor.currentNode = question
          wireframe.nextQuestionValue = nextQuestion
          
          interactor.answerChanged(JsonLibrary.questionResponse())
          
          expect(presenter.presentedQuestion).to(beNil())
        }
        it("does nothing if there is 'Next' button on question") {
          var dict = JsonLibrary.question()
          dict["always_show_send"] = true
          let question = try! QuestionFactory(with: dict).build()
          let nextQuestion = try! QuestionFactory(with: JsonLibrary.question()).build()
          interactor.currentNode = question
          wireframe.nextQuestionValue = nextQuestion
          
          interactor.answerChanged(JsonLibrary.questionResponse())
          
          expect(networkClient.sendResponseFlag).to(beFalse())
          expect(presenter.presentedQuestion).to(beNil())
        }
        it("does nothing on LeadGen") {
          let leadGen = try! LeadGenFormFactory(with: JsonLibrary.leadGenForm()).build()
          interactor.currentNode = leadGen
          
          interactor.answerChanged(JsonLibrary.questionResponse())
          
          expect(networkClient.sendResponseFlag).to(beFalse())
        }
      }
      context("unexpected error ocurred") {
        it("closes node with error") {
          interactor.unexpectedErrorOccured("test")
          
          expect(presenter.closeSurveyFlag).to(beTrue())
          expect(delegate.surveyDidCloseMessage).to(equal("test"))
        }
      }
      context("loading view") {
        it("shows first node without focusing") {
          let question = try! QuestionFactory(with: JsonLibrary.question()).build()
          wireframe.firstNodeValue = question
          
          interactor.viewLoaded()
          
          expect(presenter.presentedQuestion).to(equal(question))
          expect(presenter.focusOnInputFlag).to(beFalse())
        }
        it("remembers that survey was seen") {
          let question = try! QuestionFactory(with: JsonLibrary.question()).build()
          wireframe.firstNodeValue = question
          wireframe.currentSurveyValue = 1
          
          interactor.viewLoaded()
          
          expect(storage.saveUserHaveSeenValue).to(equal(1))
        }
        it("informs about survey start") {
          let question = try! QuestionFactory(with: JsonLibrary.question()).build()
          wireframe.firstNodeValue = question
          
          interactor.viewLoaded()
          
          expect(delegate.surveyDidStartFlag).to(beTrue())
        }
        it("records impression") {
          let question = try! QuestionFactory(with: JsonLibrary.question()).build()
          wireframe.firstNodeValue = question
          
          interactor.viewLoaded()
          
          expect(networkClient.recordImpressionFlag).to(beTrue())
        }
      }
    }
  }
}
