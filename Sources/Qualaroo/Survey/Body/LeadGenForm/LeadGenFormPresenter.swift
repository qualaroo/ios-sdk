//
//  LeadGenFormPresenter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

class LeadGenFormPresenter: NSObject {
  
  private weak var view: LeadGenFormView?
  private let interactor: LeadGenFormInteractor
  
  init(view: LeadGenFormView,
       interactor: LeadGenFormInteractor) {
    self.view = view
    self.interactor = interactor
  }
}

extension LeadGenFormPresenter: TextChangeListener {
  func textDidChange() {
    guard let view = view else { return }
    let answers = view.cells.map { $0.answerTextField.text ?? "" }
    interactor.answerChanged(answers)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let currentIndex = index(for: textField) else { return true }
    if let nextField = nextTextField(after: currentIndex) {
      nextField.becomeFirstResponder()
    } else if isTextFieldLast(currentIndex) {
      interactor.lastAnswerWasFilled()
    }
    return false
  }
  private func index(for textField: UITextField) -> Int? {
    return view?.cells.index { $0.answerTextField == textField }
  }
  private func nextTextField(after index: Int) -> UITextField? {
    guard
      let view = view,
      index < view.cells.endIndex else { return nil }
    if isTextFieldLast(index) {
      return firstEmptyTextField()
    }
    return view.cells[index+1].answerTextField
  }
  private func isTextFieldLast(_ index: Int) -> Bool {
    guard let view = view else { return false }
    return index == view.cells.endIndex-1
  }
  private func firstEmptyTextField() -> UITextField? {
    let firstEmptyCell = view?.cells.first { $0.answerTextField.text?.count == 0}
    return firstEmptyCell?.answerTextField
  }
}
