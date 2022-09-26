//
//  AnswerListPresenter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

class AnswerListPresenter {
  
  private weak var view: AnswerListView?
  private let interactor: AnswerListInteractor
  private let selecter: AnswerSelectionConfigurator
  
  init(view: AnswerListView,
       interactor: AnswerListInteractor,
       selecter: AnswerSelectionConfigurator) {
    self.view = view
    self.interactor = interactor
    self.selecter = selecter
  }
  
  func passCurrentAnswer() {
    interactor.setAnswer(currentAnswer())
  }
  
  func currentAnswer() -> [(Int, String?)] {
    var selectedAnswers = [(Int, String?)]()
    guard let view = view else { return [] }
    for (index, view) in view.selectableViews.enumerated() where view.isSelected {
      let text = view.isCommentAllowed ? view.freeformTextView.text : nil
      selectedAnswers.append((index, text))
    }
    return selectedAnswers
  }
  
}

extension AnswerListPresenter: SelectableViewDelegate {
  
  func viewWasSelected(_ selectedView: SelectableView) {
    guard let view = view else { return }
    selecter.performSelection(selectedView: selectedView, container: view) {
      self.passCurrentAnswer()
    }
  }
  
  func viewTextChanged(_ selectedView: SelectableView) {
    passCurrentAnswer()
  }
  
}

protocol AnswerSelectionConfigurator: class {
  
  func performSelection(selectedView: SelectableView,
                        container: AnswerListView,
                        completion: @escaping () -> Void)
  
}

class AnswerRadioSelecter: AnswerSelectionConfigurator {

  private struct Const {
    static let minimumDelayTime = 0.1
  }

  func performSelection(selectedView: SelectableView,
                        container: AnswerListView,
                        completion: @escaping () -> Void) {
    container.selectableViews.forEach { $0.isSelected = ($0 == selectedView) }
    container.resize()
    container.isUserInteractionEnabled = false
    DispatchQueue.main.asyncAfter(deadline: .now() + Const.minimumDelayTime) {
      container.isUserInteractionEnabled = true
      completion()
    }
  }
  
}

class AnswerCheckboxSelecter: AnswerSelectionConfigurator {
  
  let maxAnswersCount: Int
  
  init(maxAnswersCount: Int) {
    self.maxAnswersCount = maxAnswersCount
  }
  
  func performSelection(selectedView: SelectableView,
                        container: AnswerListView,
                        completion: @escaping () -> Void) {
    selectedView.isSelected = !selectedView.isSelected
    handleInteractionAllowance(for: container)
    container.resize()
    completion()
  }
  
  private func handleInteractionAllowance(for container: AnswerListView) {
    let selectedCount = container.selectableViews.filter { $0.isSelected }.count
    let interactionAllowed = selectedCount < maxAnswersCount
    interactionAllowed ? enableSelection(inside: container) : disableSelection(inside: container)
  }
  
  private func enableSelection(inside container: AnswerListView) {
    container.selectableViews.forEach { $0.isDisabled = false }
  }
  
  private func disableSelection(inside container: AnswerListView) {
    let unselected = container.selectableViews.filter { !$0.isSelected }
    unselected.forEach { $0.isDisabled = true }
  }
  
}
