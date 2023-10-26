//
//  QuestionViewFactory.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

class QuestionViewFactory {
  
  let buttonHandler: SurveyButtonHandler
  let answerHandler: SurveyAnswerHandler
  let theme: Theme

  init(buttonHandler: SurveyButtonHandler,
       answerHandler: SurveyAnswerHandler,
       theme: Theme) {
    self.buttonHandler = buttonHandler
    self.answerHandler = answerHandler
    self.theme = theme
  }
  
  func createView(with question: Question) -> UIView? {
    var view: UIView?
    switch question.type {
    case .nps:
      view = npsQuestionView(with: question)
    case .text:
      view = textQuestionView(with: question)
    case .dropdown:
      view = dropdownQuestionView(with: question)
    case .binary:
      view = binaryQuestionView(with: question)
    case .radio:
      view = radioQuestionView(with: question)
    case .checkbox:
      view = checkboxQuestionView(with: question)
    case .emoji:
        view = emojiQuestionView(with: question)
    case .thumb:
        view = thumbQuestionView(with: question)
    case .unknown:
      view = nil
    }
    view?.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  
  private func npsQuestionView(with question: Question) -> AnswerNpsView? {
    guard
      let nib = Bundle.qualaroo()?.loadNibNamed("AnswerNpsView", owner: nil, options: nil),
      let view = nib.first as? AnswerNpsView else { return nil }
    let responseBuilder = SingleSelectionAnswerResponseBuilder(question: question)
    let validator = AnswerNpsValidator(question: question)
    let interactor = AnswerNpsInteractor(responseBuilder: responseBuilder,
                                         validator: validator,
                                         buttonHandler: buttonHandler,
                                         answerHandler: answerHandler,
                                         question: question)
    view.setupView(backgroundColor: theme.colors.background,
                   minText: question.npsMinText ?? "",
                   maxText: question.npsMaxText ?? "",
                   textColor: theme.colors.text,
                   npsColor: theme.colors.uiSelected,
                   npsBackgroundColor: theme.colors.npsBackgroundColor,
                   npsSelectedColor:  theme.colors.npsSelectedColor,
                   ansColor:  theme.colors.ansColor,
                   ansSelectedColor:  theme.colors.ansSelectedColor,
                   interactor: interactor)
    return view
  }
  private func textQuestionView(with question: Question) -> AnswerTextView? {
    guard
      let nib = Bundle.qualaroo()?.loadNibNamed("AnswerTextView", owner: nil, options: nil),
      let view = nib.first as? AnswerTextView else { return nil }
    let responseBuilder = AnswerTextResponseBuilder(question: question)
    let validator = AnswerTextValidator(question: question)
    let interactor = AnswerTextInteractor(responseBuilder: responseBuilder,
                                          validator: validator,
                                          buttonHandler: buttonHandler,
                                          answerHandler: answerHandler)
    view.setupView(backgroundColor: theme.colors.background,
                   activeTextBorderColor: theme.colors.uiSelected,
                   inactiveTextBorderColor: theme.colors.uiNormal,
                   keyboardStyle: theme.keyboardStyle,
                   interactor: interactor)
    return view
  }
  private func dropdownQuestionView(with question: Question) -> AnswerDropdownView? {
    guard
      let nib = Bundle.qualaroo()?.loadNibNamed("AnswerDropdownView", owner: nil, options: nil),
      let view = nib.first as? AnswerDropdownView else { return nil }
    let answers = question.answerList.map { $0.title }
    let responseBuilder = SingleSelectionAnswerResponseBuilder(question: question)
    let interactor = AnswerDropdownInteractor(responseBuilder: responseBuilder,
                                              buttonHandler: buttonHandler,
                                              answerHandler: answerHandler,
                                              question: question)
    view.setupView(backgroundColor: theme.colors.background,
                   answers: answers,
                   textColor: theme.colors.text,
                   interactor: interactor)
    return view
  }
  private func binaryQuestionView(with question: Question) -> AnswerBinaryView? {
    guard
      let nib = Bundle.qualaroo()?.loadNibNamed("AnswerBinaryView", owner: nil, options: nil),
      let view = nib.first as? AnswerBinaryView else { return nil }
    let responseBuilder = SingleSelectionAnswerResponseBuilder(question: question)
    let interactor = AnswerBinaryInteractor(responseBuilder: responseBuilder,
                                            answerHandler: answerHandler)
    view.setupView(backgroundColor: theme.colors.background,
                   buttonTextColor: theme.colors.buttonTextEnabled,
                   buttonBackgroundColor: theme.colors.buttonEnabled,
                   leftTitle: question.answerList[0].title,
                   rightTitle: question.answerList[1].title,
                   interactor: interactor)
    return view
  }
    
    private func emojiQuestionView(with question: Question) -> AnswerEmojiView? {
        guard
         let nib = Bundle.qualaroo()?.loadNibNamed("AnswerEmojiView", owner: nil, options: nil),
          let view = nib.first as? AnswerEmojiView else { return nil }
        let answers = question.answerList.map { $0.emojiUrl }
        let responseBuilder = SingleSelectionAnswerResponseBuilder(question: question)
        let interactor = AnswerEmojiInteractor(responseBuilder: responseBuilder,answerHandler: answerHandler)
        view.setupView(backgroundColor: theme.colors.background,textColor: theme.colors.text, answers:answers,interactor:interactor)
        return view
        
    }
    
    private func thumbQuestionView(with question: Question) -> AnswerThumbView? {
        guard
         let nib = Bundle.qualaroo()?.loadNibNamed("AnswerThumbView", owner: nil, options: nil),
          let view = nib.first as? AnswerThumbView else { return nil }
        let answers = question.answerList.map { $0.emojiUrl }
        let responseBuilder = SingleSelectionAnswerResponseBuilder(question: question)
        let interactor = AnswerThumbInteractor(responseBuilder: responseBuilder,answerHandler: answerHandler)
        view.setupView(backgroundColor: theme.colors.background,textColor: theme.colors.text, answers:answers,interactor:interactor)
        return view
        
    }
    
  private func radioQuestionView(with question: Question) -> AnswerListView? {
    guard
        let onImage = UIImage(named: "radio_button_on",
                              in: Bundle.qualaroo(),
                              compatibleWith: nil),
        let offImage = UIImage(named: "radio_button_off",
                           in: Bundle.qualaroo(),
                           compatibleWith: nil)
        else { return nil }

    return AnswerListView.Builder(question: question,
                                  buttonHandler: buttonHandler,
                                  answerHandler: answerHandler,
                                  selecter: AnswerRadioSelecter(),
                                  theme: theme,
                                  onImage: onImage,
                                  offImage: offImage).build()
  }
  private func checkboxQuestionView(with question: Question) -> AnswerListView? {
    guard
        let onImage = UIImage(named: "checkbox_button_on",
                              in: Bundle.qualaroo(),
                              compatibleWith: nil),
        let offImage = UIImage(named: "checkbox_button_off",
                               in: Bundle.qualaroo(),
                               compatibleWith: nil)
        else { return nil }
    
    guard let maxAnswersCount = question.maxAnswersCount else { return nil }
    return AnswerListView.Builder(question: question,
                                  buttonHandler: buttonHandler,
                                  answerHandler: answerHandler,
                                  selecter: AnswerCheckboxSelecter(maxAnswersCount: maxAnswersCount),
                                  theme: theme,
                                  onImage: onImage,
                                  offImage: offImage).build()
  }
}
