//
//  AnswerBinaryView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit
class AnswerBinaryView: UIView {
  
  private struct Const {
    static let buttonLabelMargin: CGFloat = 12
  }
  
  private var interactor: AnswerBinaryInteractor!
  
  @IBOutlet weak var leftButton: UIButton!
  @IBOutlet weak var rightButton: UIButton!
  
  @IBOutlet weak var buttonsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonsEdgeMarginConstraint: NSLayoutConstraint!
  
  func setupView(backgroundColor: UIColor,
                 buttonTextColor: UIColor,
                 buttonBackgroundColor: UIColor,
                 leftTitle: String,
                 rightTitle: String,
                 interactor: AnswerBinaryInteractor) {
    configureButtons(textColor: buttonTextColor,
                     background: buttonBackgroundColor,
                     leftTitle: leftTitle,
                     rightTitle: rightTitle)
    self.backgroundColor = backgroundColor
    self.interactor = interactor
  }
  
  private func configureButtons(textColor: UIColor,
                                background: UIColor,
                                leftTitle: String,
                                rightTitle: String) {
    leftButton.setTitle(leftTitle, for: .normal)
    rightButton.setTitle(rightTitle, for: .normal)
    let buttons: [UIButton] = [leftButton, rightButton]
    buttons.forEach {
      $0.setBackgroundColor(color: background, forState: .normal)
      $0.setTitleColor(textColor, for: .normal)
      $0.titleLabel?.textAlignment = .center
      $0.layer.cornerRadius = SurveyView.Const.buttonsCornerRadius
      $0.layoutIfNeeded()
    }
    let heights = buttons.map { $0.titleLabel?.frame.height }.removeNils()
    let maxHeight = heights.max() ?? SurveyView.Const.buttonsHeight
    buttonsHeightConstraint.constant = maxHeight + 2*AnswerBinaryView.Const.buttonLabelMargin
    buttonsEdgeMarginConstraint.constant = SurveyView.Const.edgeMargin
  }
  
  @IBAction func leftButtonPressed() {
    interactor.selectLeftAnswer()
  }
  
  @IBAction func rightButtonPressed() {
    interactor.selectRightAnswer()
  }
}
