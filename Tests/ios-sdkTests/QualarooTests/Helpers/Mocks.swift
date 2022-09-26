//
//  Mocks.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit
@testable import Qualaroo

class SurveyViewMock: SurveyViewInterface {
  func setProgress(progress: Float) {
  
  }
  
  var dimBackgroundFlag = false
  var enableNextButtonFlag = false
  var disableNextButtonFlag = false
  var focusOnInputFlag = false
  var keyboardChangedSizeHeightValue: CGFloat?
  var keyboardChangedSizeAnimationTimeValue: TimeInterval?
  var backgroundColorValue: UIColor?
  var textColorValue: UIColor?
  var buttonEnabledColorValue: UIColor?
  var buttonDisabledColorValue: UIColor?
  var buttonTextEnabledColorValue: UIColor?
  var buttonTextDisabledColorValue: UIColor?
  var logoUrlValue: String?
  var uiNormalColorValue: UIColor?
  var showCloseButtonValue: Bool?
  var fullscreenValue: Bool?
  var dimStyleValue: UIBlurEffectStyle?
  var closeSurveyDimValue: Bool?
  func setup(backgroundColor: UIColor,
             textColor: UIColor,
             buttonViewModel: SurveyButtonsView.ViewModel,
             logoUrl: String,
             closeButtonViewModel: SurveyHeaderView.CloseButtonViewModel,
             surveyBodyViewModel: SurveyView.BodyViewModel,
             progressViewModel: SurveyView.ProgressViewModel) {
    backgroundColorValue = backgroundColor
    textColorValue = textColor
    buttonEnabledColorValue = buttonViewModel.enabledColor
    buttonDisabledColorValue = buttonViewModel.disabledColor
    buttonTextEnabledColorValue = buttonViewModel.textEnabledColor
    buttonTextDisabledColorValue = buttonViewModel.textDisabledColor
    logoUrlValue = logoUrl
    uiNormalColorValue = closeButtonViewModel.color
    showCloseButtonValue = !closeButtonViewModel.hidden
    fullscreenValue = surveyBodyViewModel.fullscreen
    dimStyleValue = surveyBodyViewModel.dimStyle
  }
  func displayMessage(withText text: String,
                      buttonModel: SurveyButtonsView.ButtonViewModel,
                      fullscreen: Bool) {}
  func displayQuestion(viewModel: SurveyHeaderView.CopyViewModel,
                       answerView: UIView,
                       buttonModel: SurveyButtonsView.ButtonViewModel) {}
  func displayLeadGenForm(with text: String,
                          leadGenView: LeadGenFormView,
                          buttonModel: SurveyButtonsView.ButtonViewModel) {}
  func focusOnInput() { focusOnInputFlag = true }
  func closeSurvey(withDim dimming: Bool) { closeSurveyDimValue = dimming }
  func keyboardChangedSize(height: CGFloat,
                           animationTime: TimeInterval) {
    keyboardChangedSizeHeightValue = height
    keyboardChangedSizeAnimationTimeValue = animationTime
  }
  func dimBackground() { dimBackgroundFlag = true }
  func enableNextButton() { enableNextButtonFlag = true }
  func disableNextButton() { disableNextButtonFlag = true}
}

class SurveyInteractorMock: SurveyInteractorProtocol {
  var viewLoadedFlag = false
  var goToNextNodeFlag = false
  var userWantToCloseSurveyFlag = false
  var isValidValue: Bool?
  var answerChangedValue: NodeResponse?
  var unexpectedErrorOccuredFlag = false
  func viewLoaded() { viewLoadedFlag = true }
  func goToNextNode() { goToNextNodeFlag = true }
  func userWantToCloseSurvey() { userWantToCloseSurveyFlag = true }
  func answerChanged(_ answer: NodeResponse) { answerChangedValue = answer }
  func unexpectedErrorOccured(_ message: String) { unexpectedErrorOccuredFlag = true }
}

class SurveyPresenterMock: SurveyPresenterProtocol {
  func displayProgress(progress: Float) {
    
  }
  
  var enableButtonFlag = false
  var disableButtonFlag = false
  var focusOnInputFlag = false
  var presentedQuestion: Question?
  var presentedMessage: Message?
  var presentedLeadGenForm: LeadGenForm?
  var closeSurveyFlag = false
  func enableButton() { enableButtonFlag = true }
  func disableButton() { disableButtonFlag = true }
  func present(question: Question) { presentedQuestion = question }
  func present(message: Message) { presentedMessage = message }
  func present(leadGenForm: LeadGenForm) { presentedLeadGenForm = leadGenForm }
  func focusOnInput() { focusOnInputFlag = true }
  func closeSurvey() { closeSurveyFlag = true }
}

class SurveyWireframeMock: SurveyWireframeProtocol {
  var firstNodeValue: Node?
  var nextQuestionValue: Node?
  var currentSurveyValue: Int = 0
  var isMandatoryValue = false
  func firstNode() -> Node? { return firstNodeValue }
  func nextNode(for: NodeId?, response: NodeResponse?) -> Node? { return nextQuestionValue }
  func currentSurveyId() -> Int { return currentSurveyValue }
  func isMandatory() -> Bool { return isMandatoryValue }
}

class SurveysStorageMock: SeenSurveyMemoryProtocol, FinishedSurveyMemoryProtocol {
  var saveUserHaveSeenValue: Int?
  var saveUserHaveFinishedValue: Int?
  var checkIfUserHaveSeenValue = false
  var checkIfUserHaveSeenRecentlyValue = false
  var checkIfUserHaveFinishedValue = false
  var lastSeenDateValue: Date?
  func saveUserHaveSeen(surveyWithID surveyID: Int) { saveUserHaveSeenValue = surveyID }
  func saveUserHaveFinished(surveyWithID surveyID: Int) { saveUserHaveFinishedValue = surveyID }
  func checkIfUserHaveSeen(surveyWithID surveyID: Int) -> Bool { return checkIfUserHaveSeenValue }
  func checkIfUserHaveSeenRecently(surveyWithID surveyID: Int) -> Bool { return checkIfUserHaveSeenRecentlyValue }
  func checkIfUserHaveFinished(surveyWithID surveyID: Int) -> Bool { return checkIfUserHaveFinishedValue }
  func lastSeenDate(forSurveyWithID surveyID: Int) -> Date? { return lastSeenDateValue }
}

class ProgressCalculatorMock: ProgressCalculator {
    
}

class PersistentMemoryMock: SimpleRequestMemoryProtocol {
  var savedObject: [String]?
  var cleanSimpleRequestsListFlag = false
  func save(simpleRequestsList: [String]) { savedObject = simpleRequestsList }
  func loadSimpleRequestsList() -> [String]? { return savedObject }
  func cleanSimpleRequestsList() { cleanSimpleRequestsListFlag = true }
}

protocol SendResponseProtocolMock: SendResponseProtocol {
  var sendResponseFlag: Bool { get set }
}

extension SendResponseProtocolMock {
  func sendResponse(_ response: NodeResponse) {
    sendResponseFlag = true
  }
}

protocol RecordImpressionProtocolMock: RecordImpressionProtocol {
  var recordImpressionFlag: Bool { get set }
}

extension RecordImpressionProtocolMock {
  func recordImpression() {
    recordImpressionFlag = true
  }
}

class SimpleRequestMock: SendResponseProtocolMock, RecordImpressionProtocolMock {
  var sendResponseFlag = false
  var recordImpressionFlag = false
}

class FetchSurveySchedulerMock: FetchSurveysProtocol {
  var startFetchingSurveysFlag = false
  func startFetchingSurveys(saveBlock: FetchSurveysCallback?) { startFetchingSurveysFlag = true }
  func fetchSurveys() {}
}

class ReportRequestProtocolMock: ReportRequestProtocol {
  var scheduleRequestUrl: URL?
  func scheduleRequest(_ url: URL) { scheduleRequestUrl = url }
}

class ImageStorageMock: ImageStorage {
  override func getImage(forUrl urlString: String, completion: @escaping ImageFetchBlock = { _ in }) {}
}

class ListRandomizerMock: ListRandomizer {
  override func shuffleList<T>(_ answers: [T], keepLast anchorCount: Int) -> [T] {
    let lastAnswers = answers.suffix(anchorCount)
    var newList = Array(answers.dropLast(anchorCount))
    newList.reverse()
    newList.append(contentsOf: lastAnswers)
    return newList
  }
}

class UrlComposerMock: ReportUrlComposerProtocol {
  var returnUrlValue: URL?
  func responseUrl(with response: NodeResponse) -> URL? {
    return returnUrlValue
  }
  func impressionUrl() -> URL? {
    return returnUrlValue
  }
}

class LeadGenFormValidatorMock: LeadGenFormValidator {
  var isValidValue = false
  init() { super.init(items: []) }
  override func isValid(with texts: [String]) -> Bool {
    return isValidValue
  }
}

class UrlOpenerMock: UrlOpener {
  var openUrlValue: URL?
  override func openUrl(_ url: URL) { openUrlValue = url }
}

class SurveyDelegateMock: SurveyDelegate {
  var surveyDidStartFlag = false
  var surveyDidDismissFlag = false
  var surveyDidFinishFlag = false
  var surveyDidCloseMessage: String?
  var answersValue: UserResponse?
  func surveyDidStart() { surveyDidStartFlag = true }
  func surveyDidDismiss() { surveyDidDismissFlag = true}
  func surveyDidFinish() { surveyDidFinishFlag = true }
  func surveyDidClose(errorMessage: String) { surveyDidCloseMessage = errorMessage }
  func userDidAnswerQuestion(_ response: UserResponse) { answersValue = response }
}

class SingleSelectionAnswerResponseBuilderMock: SingleSelectionAnswerResponseBuilder {
  var responseValue: NodeResponse?
  override func response(selectedIndex: Int) -> NodeResponse? {
    return responseValue
  }
}
