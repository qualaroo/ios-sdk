//
//  AnswerTextView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

class AnswerTextView: UIView, FocusableAnswerView {
  
  private var interactor: AnswerTextInteractor!

  private var inactiveTextBorderColor: UIColor = UIColor.clear
  private var activeTextBorderColor: UIColor = UIColor.clear

  @IBOutlet weak var responseTextView: UITextView!
  
  func setupView(backgroundColor: UIColor,
                 activeTextBorderColor: UIColor,
                 inactiveTextBorderColor: UIColor,
                 keyboardStyle: UIKeyboardAppearance,
                 interactor: AnswerTextInteractor) {
    self.backgroundColor = backgroundColor
    self.inactiveTextBorderColor = inactiveTextBorderColor
    self.activeTextBorderColor = activeTextBorderColor
    responseTextView.layer.borderColor = inactiveTextBorderColor.cgColor
    responseTextView.layer.borderWidth = 1.0
    responseTextView.layer.cornerRadius = 4.0
    responseTextView.keyboardAppearance = keyboardStyle
    responseTextView.delegate = self
    self.interactor = interactor
  }
  
  func getFocus() {
    responseTextView.becomeFirstResponder()
  }

  private func changeBorderColor(_ newColor: UIColor) {
    let animation = CABasicAnimation(keyPath: "borderColor")
    animation.fromValue = responseTextView.layer.borderColor
    animation.toValue = newColor.cgColor
    animation.duration = kAnimationTime
    animation.repeatCount = 1
    responseTextView.layer.add(animation, forKey: "borderColor")
    responseTextView.layer.borderColor = newColor.cgColor
  }
}

extension AnswerTextView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    interactor.setAnswer(textView.text)
  }
  func textViewDidBeginEditing(_ textView: UITextView) {
    changeBorderColor(activeTextBorderColor)
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    changeBorderColor(inactiveTextBorderColor)
  }
}
