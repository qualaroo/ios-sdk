//
//  SurveyButtonsView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit
import UIKit

@objc(SPMSurveyButtonsView)
class SurveyButtonsView: XibView {
  
  struct ButtonViewModel {
    let text: String?
    let shouldShowButton: Bool
  }
  
  struct ViewModel {
    let enabledColor: UIColor
    let disabledColor: UIColor
    let textEnabledColor: UIColor
    let textDisabledColor: UIColor
  }
  
  private struct Const {
    static let buttonTopMargin: CGFloat = 10
    static let buttonBottomMargin: CGFloat = 20
  }
  
  weak var delegate: SurveyViewDelegate?

  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var totalHeightViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomMarginConstraint: NSLayoutConstraint!
  
  let totalHeight = Const.buttonTopMargin +
                    SurveyView.Const.buttonsHeight +
    Const.buttonBottomMargin
  
  func setup(viewModel: ViewModel) {
    nextButton.setBackgroundColor(color: viewModel.enabledColor, forState: .normal)
    nextButton.setBackgroundColor(color: viewModel.disabledColor, forState: .disabled)
    nextButton.setTitleColor(viewModel.textEnabledColor, for: .normal)
    nextButton.setTitleColor(viewModel.textDisabledColor, for: .disabled)
    nextButton.layer.cornerRadius = SurveyView.Const.buttonsCornerRadius
    self.totalHeightViewConstraint.constant = totalHeight
  }
  
  func configureButton(with model: ButtonViewModel, duration: TimeInterval) -> Animatable {
    if model.shouldShowButton {
      let buttonText = model.text ?? ""
      return showButtonAnimation(withText: buttonText, duration: duration)
    } else {
      return hideButtonAnimation(withDuration: duration)
    }
  }
  
  func hideButtonAnimation(withDuration duration: TimeInterval) -> Animatable {
    return Animation(duration: duration) {
      self.nextButton.setTitle("", for: .normal)
      self.alpha = 0
      self.totalHeightViewConstraint.constant = 0
      self.superview?.superview?.layoutIfNeeded()
    }
  }
  
  func showButtonAnimation(withText text: String, duration: TimeInterval) -> Animatable {
    return Animation(duration: duration) {
      self.nextButton.setTitle(text, for: .normal)
      self.alpha = 1
      self.totalHeightViewConstraint.constant = self.totalHeight
      self.superview?.superview?.layoutIfNeeded()
    }
  }

  // MARK: - User Actions
  @IBAction func buttonPressed(_ sender: UIButton) {
    delegate?.nextButtonPressed()
  }
}
