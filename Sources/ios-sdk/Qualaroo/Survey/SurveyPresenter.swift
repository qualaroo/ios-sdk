//
//  SurveyPresenter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class SurveyPresenter {
  
  private weak var surveyViewInterface: SurveyViewInterface?
  private var interactor: SurveyInteractorProtocol
  private let theme: Theme
  private let converter: TextConverter
  private lazy var factory: QuestionViewFactory = {
    return QuestionViewFactory(buttonHandler: self,
                               answerHandler: interactor,
                               theme: theme)
  }()

  init(theme: Theme,
       interactor: SurveyInteractorProtocol,
       converter: TextConverter) {
    self.theme = theme
    self.interactor = interactor
    self.converter = converter
    configureObservers()
  }
  
  deinit {
    removeObservers()
  }
  
// MARK: - Question Logic
  private func show(_ question: Question) {
    guard let surveyViewInterface = surveyViewInterface else {
      interactor.unexpectedErrorOccured("Presenter retained while surveyView is nil.")
      return
    }
    guard let embeddedView = factory.createView(with: question) else {
      interactor.unexpectedErrorOccured("Couldn't create QuestionView.")
      return
    }
    surveyViewInterface.displayQuestion(viewModel: copyViewModel(with: question),
                                        answerView: embeddedView,
                                        buttonModel: buttonViewModel(with: question))
  }
  
  private func show(_ message: Message) {
    guard let surveyViewInterface = surveyViewInterface else {
      interactor.unexpectedErrorOccured("Presenter retained while surveyView is nil.")
      return
    }
    surveyViewInterface.displayMessage(withText: converter.convert(message.description),
                                       buttonModel: buttonViewModel(with: message),
                                       fullscreen: theme.fullscreen)
  }

  private func show(_ leadGenForm: LeadGenForm) {
    guard let surveyViewInterface = surveyViewInterface else {
      interactor.unexpectedErrorOccured("Presenter retained while surveyView is nil.")
      return
    }
    guard let embeddedView = LeadGenViewBuilder.createView(forLeadGenForm: leadGenForm,
                                                           buttonHandler: self,
                                                           answerHandler: interactor,
                                                           theme: theme) else {
      interactor.unexpectedErrorOccured("Couldn't create LeadGenView.")
      return
    }
    surveyViewInterface.displayLeadGenForm(with: converter.convert(leadGenForm.description),
                                           fontStyleTitle: leadGenForm.font_style_decription,
                                           leadGenView: embeddedView,
                                           buttonModel: buttonViewModel(with: leadGenForm))
  }
}

// MARK: - Notifications
private extension SurveyPresenter {
  func configureObservers() {
    let action = #selector(self.keyboardNotification(notification:))
    let notificationName = UIResponder.keyboardWillChangeFrameNotification
    NotificationCenter.default.addObserver(self, selector: action, name: notificationName, object: nil)
  }
  
  func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func keyboardNotification(notification: NSNotification) {
    guard
      let userInfo = notification.userInfo,
      let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
      let animationTime = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
      let surveyViewInterface = surveyViewInterface else { return }
    let endFrame = endFrameValue.cgRectValue
    surveyViewInterface.keyboardChangedSize(height: offset(for: endFrame), animationTime: animationTime)
  }
  
  func offset(for keyboardEndFrame: CGRect) -> CGFloat {
    let isKeyboardHiding = keyboardEndFrame.origin.y >= UIScreen.main.bounds.size.height
    return isKeyboardHiding ? 0.0 : keyboardEndFrame.size.height
  }
}

// MARK: - ViewModels
private extension SurveyPresenter {
  
  func buttonViewModel(with message: Message) -> SurveyButtonsView.ButtonViewModel {
    return SurveyButtonsView.ButtonViewModel(text: message.callToAction?.text ?? "",
                                             shouldShowButton: message.callToAction != nil)
  }

  func buttonViewModel(with question: Question) -> SurveyButtonsView.ButtonViewModel {
    return SurveyButtonsView.ButtonViewModel(text: question.buttonText, shouldShowButton: question.shouldShowButton)
  }
  
  func buttonViewModel(with leadGen: LeadGenForm) -> SurveyButtonsView.ButtonViewModel {
    return SurveyButtonsView.ButtonViewModel(text: leadGen.buttonText, shouldShowButton: true)
  }
  
  func copyViewModel(with question: Question) -> SurveyHeaderView.CopyViewModel {
    return SurveyHeaderView.CopyViewModel(title: converter.convert(question.title),
                                          description: converter.convert(question.description),
                                          descriptionPlacement: question.descriptionPlacement,fontStyleQuestion: question.fontStyleQuestion,fontStyleDescription: question.fontStyleDescription)
  }
  
  func buttonViewModel(with colors: ColorTheme) -> SurveyButtonsView.ViewModel {
    return SurveyButtonsView.ViewModel(enabledColor: colors.buttonEnabled,
                                       disabledColor: colors.buttonDisabled,
                                       textEnabledColor: colors.buttonTextEnabled,
                                       textDisabledColor: colors.buttonTextDisabled)
  }
  
  func closeButtonModel(with theme: Theme) -> SurveyHeaderView.CloseButtonViewModel {
    return SurveyHeaderView.CloseButtonViewModel(color: theme.colors.uiNormal,
                                                 hidden: !theme.closeButtonVisible)
  }
  
  func surveyBodyViewModel(with theme: Theme) -> SurveyView.BodyViewModel {
    return SurveyView.BodyViewModel(backgroundColor: theme.colors.background,
                                dimStyle: theme.dimType,
                                dimAlpha: theme.dimAlpha,
                                fullscreen: theme.fullscreen)
  }
}

// MARK: - SurveyViewDelegate
extension SurveyPresenter: SurveyViewDelegate {
  
  func viewLoaded(_ view: SurveyViewInterface) {
    surveyViewInterface = view
    let progressViewModel = SurveyView.ProgressViewModel(
      trackColor: theme.colors.uiNormal,
      progressColor: theme.colors.uiSelected,
      location: theme.progressBarLocation
    )
    view.setup(backgroundColor: theme.colors.background,
               textColor: theme.colors.text,
               buttonViewModel: buttonViewModel(with: theme.colors),
               logoUrl: theme.logoUrlString,
               closeButtonViewModel: closeButtonModel(with: theme),
               surveyBodyViewModel: surveyBodyViewModel(with: theme),
               progressViewModel: progressViewModel)
    interactor.viewLoaded()
  }
  
  func viewDisplayed(_ view: SurveyViewInterface) {
    if !theme.fullscreen {
      view.dimBackground()
    }
  }
  
  func backgroundDimTapped() {
    interactor.userWantToCloseSurvey()
  }
  
  func nextButtonPressed() {
    interactor.goToNextNode()
  }
  
  func closeButtonPressed() {
    interactor.userWantToCloseSurvey()
  }
}

// MARK: - SurveyPresenterProtocol
extension SurveyPresenter: SurveyPresenterProtocol {
    
  func focusOnInput() {
    surveyViewInterface?.focusOnInput()
  }
  
  func enableButton() {
    surveyViewInterface?.enableNextButton()
  }
  
  func disableButton() {
    surveyViewInterface?.disableNextButton()
  }
  
  func present(question: Question) {
    show(question)
  }
  
  func present(message: Message) {
    show(message)
  }
  
  func present(leadGenForm: LeadGenForm) {
    show(leadGenForm)
  }
  
  func closeSurvey() {
    surveyViewInterface?.closeSurvey(withDim: !theme.fullscreen)
  }
    
  func displayProgress(progress: Float) {
    surveyViewInterface?.setProgress(progress: progress)
  }

}
