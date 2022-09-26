//
//  AnswerDropdownView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit
import UIKit

class AnswerDropdownView: UIView {
  
  var interactor: AnswerDropdownInteractor!
  
  @IBOutlet weak var picker: UIPickerView!
  
  var answers = [String]()
  var textColor = UIColor.black

  private struct Const {
    static let horizontalMargin: CGFloat = 10
    static let rowHeight: CGFloat = 44
    static let answerViewHeight: CGFloat = 200
  }
  
  func setupView(backgroundColor: UIColor,
                 answers: [String],
                 textColor: UIColor,
                 interactor: AnswerDropdownInteractor) {
    self.backgroundColor = backgroundColor
    self.answers = answers
    self.textColor = textColor
    self.interactor = interactor
    picker.delegate = self
    picker.dataSource = self
    picker.reloadAllComponents()
  }
}

extension AnswerDropdownView: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView,
                  widthForComponent component: Int) -> CGFloat {
    return bounds.size.width - 2 * Const.horizontalMargin
  }
  func pickerView(_ pickerView: UIPickerView,
                  rowHeightForComponent component: Int) -> CGFloat {
    return Const.rowHeight
  }
  func pickerView(_ pickerView: UIPickerView,
                  viewForRow row: Int,
                  forComponent component: Int,
                  reusing view: UIView?) -> UIView {
    let recentLabel = view as? UILabel
    let label = recentLabel ?? newConfiguredLabel()
    let attributtes = [NSAttributedString.Key.foregroundColor: textColor]
    label.attributedText = NSAttributedString(string: answers[row],
                                              attributes: attributtes)
    return label
  }
  private func newConfiguredLabel() -> UILabel {
    let frame = CGRect(x: Const.horizontalMargin,
                       y: 0,
                       width: picker.frame.width - 2*Const.horizontalMargin,
                       height: Const.rowHeight)
    let label = UILabel(frame: frame)
    label.backgroundColor = .clear
    label.textColor = textColor
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .center
    label.lineBreakMode = .byWordWrapping
    label.adjustsFontSizeToFitWidth = false
    label.numberOfLines = 0
    return label
  }
  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int) {
    interactor.setAnswer(row)
  }
}

extension AnswerDropdownView: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    return answers.count
  }
}
