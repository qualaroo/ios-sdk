//
//  SurveyProtocols.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit
import UIKit

// MARK: - View Interfaces
protocol SurveyViewInterface: class {
  func setup(backgroundColor: UIColor,
             textColor: UIColor,
             buttonViewModel: SurveyButtonsView.ViewModel,
             logoUrl: String,
             closeButtonViewModel: SurveyHeaderView.CloseButtonViewModel,
             surveyBodyViewModel: SurveyView.BodyViewModel,
             progressViewModel: SurveyView.ProgressViewModel)
  func displayMessage(withText text: String,
                      buttonModel: SurveyButtonsView.ButtonViewModel,
                      fullscreen: Bool)
  func displayQuestion(viewModel: SurveyHeaderView.CopyViewModel,
                       answerView: UIView,
                       buttonModel: SurveyButtonsView.ButtonViewModel)
  func displayLeadGenForm(with text: String,
                          fontStyleTitle:String,
                          leadGenView: LeadGenFormView,
                          buttonModel: SurveyButtonsView.ButtonViewModel)
  func focusOnInput()
  func enableNextButton()
  func disableNextButton()
  func closeSurvey(withDim dimming: Bool)
  func keyboardChangedSize(height: CGFloat, animationTime: TimeInterval)
  func dimBackground()
  func setProgress(progress: Float)
}

protocol FocusableAnswerView {
  func getFocus()
}

// MARK: - View Delegates
protocol SurveyViewDelegate: class {
  func viewLoaded(_ view: SurveyViewInterface)
  func viewDisplayed(_ view: SurveyViewInterface)
  func backgroundDimTapped()
  func nextButtonPressed()
  func closeButtonPressed()
}

// MARK: - Presenter Protocols
protocol SurveyButtonHandler: class {
  func enableButton()
  func disableButton()
}
protocol SurveyPresenterProtocol: SurveyButtonHandler {
  func focusOnInput()
  func present(question: Question)
  func present(message: Message)
  func present(leadGenForm: LeadGenForm)
  func closeSurvey()
  func displayProgress(progress: Float)
}

// MARK: - Interactor Protocols
protocol SurveyAnswerHandler: class {
  func answerChanged(_ answers: NodeResponse)
  func goToNextNode()
}

protocol SurveyInteractorProtocol: SurveyAnswerHandler {
  func viewLoaded()
  func userWantToCloseSurvey()
  func unexpectedErrorOccured(_ message: String)
}

// MARK: - SurveyWireframeProtocol
protocol SurveyWireframeProtocol: class {
  func firstNode() -> Node?
  func nextNode(for: NodeId?, response: NodeResponse?) -> Node?
  func currentSurveyId() -> Int
  func isMandatory() -> Bool
}

protocol ReportRequestMemoryProtocol {
  func store(reportRequest: String)
  func remove(reportRequest: String)
  func getAllRequests() -> [String]
}

// MARK: - SimpleRequestMemoryProtocol
protocol SimpleRequestMemoryProtocol {
  func save(simpleRequestsList: [String])
  func loadSimpleRequestsList() -> [String]?
  func cleanSimpleRequestsList()
}

// MARK: - SeenSurveyMemoryProtocol
protocol SeenSurveyMemoryProtocol: class {
  func saveUserHaveSeen(surveyWithID surveyID: Int)
  func checkIfUserHaveSeen(surveyWithID surveyID: Int) -> Bool
  func lastSeenDate(forSurveyWithID surveyID: Int) -> Date?
}

// MARK: - FinishedSurveyMemoryProtocol
protocol FinishedSurveyMemoryProtocol: class {
  func saveUserHaveFinished(surveyWithID surveyID: Int)
  func checkIfUserHaveFinished(surveyWithID surveyID: Int) -> Bool
}

// MARK: - SamplePercentMemoryProtocol
protocol SamplePercentMemoryProtocol: class {
  func getSamplePercent(forSurveyId surveyId: Int) -> Int?
  func saveSamplePercent(_ percent: Int, forSurveyId surveyId: Int)
  func getSamplePercent(forSurveysChain chain: String) -> Int?
  func saveSamplePercent(_ percent: Int, forSurveyChain chain: String)
}

// MARK: - DeviceIdMemoryProtocol
protocol DeviceIdMemoryProtocol: class {
  func getDeviceId() -> String
}

protocol DefaultLogoNameMemoryProtocol: class {
  func saveDefaultLogoName(_ name: String)
  func getDefaultLogoName() -> String?
}
