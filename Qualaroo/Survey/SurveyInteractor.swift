//
//  SurveyInteractor.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

class SurveyInteractor {
  
  private weak var delegate: SurveyDelegate?
  weak var surveyPresenter: SurveyPresenterProtocol!
  
  private let wireframe: SurveyWireframeProtocol
  private let reportClient: SendResponseProtocol & RecordImpressionProtocol
  private let storage: SeenSurveyMemoryProtocol & FinishedSurveyMemoryProtocol
  private let urlOpener: UrlOpener
  private let progressCalculator: ProgressCalculator
    
  private var numberOfStepsDisplayed = 0
  
  var currentNode: Node?//TODO: change to private (adjust tests)
  private var currentAnswers: NodeResponse?

  init(wireframe: SurveyWireframeProtocol,
       reportClient: SendResponseProtocol & RecordImpressionProtocol,
       storage: SeenSurveyMemoryProtocol & FinishedSurveyMemoryProtocol,
       urlOpener: UrlOpener,
       delegate: SurveyDelegate?,
       progressCalculator: ProgressCalculator) {
    self.wireframe = wireframe
    self.reportClient = reportClient
    self.storage = storage
    self.urlOpener = urlOpener
    self.delegate = delegate
    self.progressCalculator = progressCalculator
  }
  
}

// MARK: - Changing Node
private extension SurveyInteractor {
  
  func showFirstNode() {
    showNode(wireframe.firstNode())
  }
  
  func showNextNode() {
    let nextNode = wireframe.nextNode(for: currentNode?.nodeId(), response: currentAnswers)
    showNode(nextNode)
    surveyPresenter.focusOnInput()
  }

  func showNode(_ node: Node?) {
    numberOfStepsDisplayed += 1
    currentNode = node
    currentAnswers = nil
    guard let node = node else {
      closeSurvey(.finished)
      return
    }
    progressCalculator.setCurrentStep(node.nodeId())
    let stepsLeft = progressCalculator.getStepsLeft()
    let progress = Float(numberOfStepsDisplayed) / Float(numberOfStepsDisplayed + stepsLeft)
    surveyPresenter.displayProgress(progress: progress)
    let showVisitor = ShowNodeVisitor(withInteractor: self)
    node.accept(showVisitor)
  }
  
}

// MARK: - Delegate UseCases
private extension SurveyInteractor {
  
  func informDelegateAboutAnswer() {
    guard let currentAnswers = currentAnswers,
      let response = UserResponseAdapter().toUserResponse(currentAnswers) else { return }
    delegate?.userDidAnswerQuestion?(response)
  }

}

// MARK: - Network UseCases
private extension SurveyInteractor {
  
  func sendResponse() {
    guard let currentAnswers = currentAnswers else { return }
    reportClient.sendResponse(currentAnswers)
  }
  
  func recordImpression() {
    reportClient.recordImpression()
  }

}

// MARK: - Closing Survey
private extension SurveyInteractor {
  
  private func closeSurvey(_ reason: ClosingReason) {
    switch reason {
    case .finished: surveyFinished()
    case .dismissed: surveyDismissed()
    case .error(let message): surveyClosed(message)
    }
    surveyPresenter.closeSurvey()
  }
  
  enum ClosingReason {
    case finished, dismissed, error(String)
  }

}

// MARK: - SurveyEvents
private extension SurveyInteractor {
  
  func surveyStarted() {
    storage.saveUserHaveSeen(surveyWithID: wireframe.currentSurveyId())
    delegate?.surveyDidStart()
  }
  
  func surveyFinished() {
    storage.saveUserHaveFinished(surveyWithID: wireframe.currentSurveyId())
    delegate?.surveyDidFinish()
  }
  
  func surveyDismissed() {
    delegate?.surveyDidDismiss()
  }
  
  func surveyClosed(_ message: String) {
    Qualaroo.log(message)
    delegate?.surveyDidClose(errorMessage: message)
  }
  
}

// MARK: - Visitors
extension SurveyInteractor {
  
  private class ShowNodeVisitor: NodeVisitor {
    let interactor: SurveyInteractor
    init(withInteractor interactor: SurveyInteractor) {
      self.interactor = interactor
    }
    func visit(_ node: Message) {
      interactor.surveyPresenter.enableButton()
      interactor.surveyPresenter.present(message: node)
    }
    func visit(_ node: Question) {
      interactor.surveyPresenter.present(question: node)
    }
    func visit(_ node: LeadGenForm) {
      interactor.surveyPresenter.present(leadGenForm: node)
    }
  }
  
  private class ButtonNodeVisitor: NodeVisitor {
    let interactor: SurveyInteractor
    init(withInteractor interactor: SurveyInteractor) {
      self.interactor = interactor
    }
    func visit(_ node: Message) {
      if let callToAction = node.callToAction {
        interactor.urlOpener.openUrl(callToAction.url)
      }
      interactor.closeSurvey(.finished)
    }
    func visit(_ node: Question) {
      interactor.sendResponse()
      interactor.informDelegateAboutAnswer()
      interactor.showNextNode()
    }
    func visit(_ node: LeadGenForm) {
      interactor.sendResponse()
      interactor.informDelegateAboutAnswer()
      interactor.showNextNode()
    }
  }
  
  private class CloseNodeVisitor: NodeVisitor {
    let interactor: SurveyInteractor
    init(interactor: SurveyInteractor) {
      self.interactor = interactor
    }
    func visit(_ node: Message) {
      interactor.closeSurvey(.finished)
    }
    func visit(_ node: Question) {
      if interactor.wireframe.isMandatory() == false {
        interactor.closeSurvey(.dismissed)
      }
    }
    func visit(_ node: LeadGenForm) {
      if interactor.wireframe.isMandatory() == false {
        interactor.closeSurvey(.dismissed)
      }
    }
  }
  
}

// MARK: - SurveyInteractorProtocol
extension SurveyInteractor: SurveyInteractorProtocol {
  
  func viewLoaded() {
    showFirstNode()
    surveyStarted()
    recordImpression()
  }
  
  func goToNextNode() {
    guard let currentNode = currentNode else {
      closeSurvey(.error("There is no current node."))
      return
    }
    let buttonVisitor = ButtonNodeVisitor(withInteractor: self)
    currentNode.accept(buttonVisitor)
  }
  
  func userWantToCloseSurvey() {
    guard let currentNode = currentNode else {
      closeSurvey(.error("There is no current node."))
      return
    }
    let closeVisitor = CloseNodeVisitor(interactor: self)
    currentNode.accept(closeVisitor)
  }
  
  func answerChanged(_ answer: NodeResponse) {
    currentAnswers = answer
  }
  
  func unexpectedErrorOccured(_ message: String) {
    closeSurvey(.error(message))
    Qualaroo.log("It seems like an nexpected error has occured. Please contact support@qualaroo.com with surveyId:\(wireframe.currentSurveyId()); sdkVersion:\(SdkSession().sdkVersion)")
  }
  
}
