//
//  LeadGenViewBuilder.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

class LeadGenViewBuilder {
  static func createView(forLeadGenForm leadGenForm: LeadGenForm,
                         buttonHandler: SurveyButtonHandler,
                         answerHandler: SurveyAnswerHandler,
                         theme: Theme) -> LeadGenFormView? {
    guard
      let nib = Bundle.qualaroo()?.loadNibNamed("LeadGenFormView",
                                               owner: nil,
                                               options: nil),
      let view = nib.first as? LeadGenFormView else { return nil }
    let questions = items(from: leadGenForm.questionList)
    let responseBuilder = LeadGenFormResponseBuilder(id: leadGenForm.leadGenFormId,
                                                     alias: leadGenForm.alias,
                                                     items: questions)
    let validator = LeadGenFormValidator(items: questions)
    let interactor = LeadGenFormInteractor(responseBuilder: responseBuilder,
                                           validator: validator,
                                           buttonHandler: buttonHandler,
                                           answerHandler: answerHandler)
    let presenter = LeadGenFormPresenter(view: view,
                                         interactor: interactor)
    let cells = questions.map {
      self.cell(with: $0,
                textDelegate: presenter,
                theme: theme)
      }.removeNils()
    view.setupView(withBorderColor: theme.colors.uiSelected,
                   textColor: theme.colors.text,
                   keyboardStyle: theme.keyboardStyle,
                   cells: cells,
                   presenter: presenter)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  
  private static func items(from list: [Question]) -> [LeadGenFormItem] {
    return list.map { ($0.nodeId(),
                       $0.canonicalName,
                       $0.alias,
                       $0.title,
                       keyboard(for: $0.canonicalName),
                       $0.isRequired) }
  }
  
  private static func keyboard(for canonicalName: String?) -> UIKeyboardType {
    guard let canonicalName = canonicalName else {
      return .`default`
    }
    switch canonicalName {
    case "email":
      return .emailAddress
    case "phone":
      return .numbersAndPunctuation
    default:
      return .`default`
    }
  }
  
  private static func cell(with item: LeadGenFormItem,
                           textDelegate: TextChangeListener,
                           theme: Theme) -> LeadGenFormCell? {
    guard
      let nib = Bundle.qualaroo()?.loadNibNamed("LeadGenFormCell",
                                               owner: nil,
                                               options: nil),
      let view = nib.first as? LeadGenFormCell else { return nil }
    view.setupView(withText: item.title,
                   textColor: theme.colors.text,
                   keyboardType: item.kayboardType,
                   isRequired: item.isRequired,
                   textDelegate: textDelegate)
    return view
  }

}
