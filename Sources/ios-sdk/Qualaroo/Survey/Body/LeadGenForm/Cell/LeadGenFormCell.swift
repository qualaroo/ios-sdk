//
//  LeadGenFormCell.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class LeadGenFormCell: UIView {
  
  @IBOutlet weak var topSeparator: UIView!
  @IBOutlet weak var topSeparatorHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerTextField: UITextField!
  
  func setupView(withText text: String,
                 textColor: UIColor,
                 keyboardType: UIKeyboardType,
                 isRequired: Bool,
                 textDelegate: TextChangeListener) {
    commonInit()
    var labelDescription = text
    if isRequired {
      labelDescription.append(" *")
    }
    questionLabel.text = labelDescription
    questionLabel.textColor = textColor
    answerTextField.textColor = textColor
    answerTextField.tintColor = textColor
    answerTextField.keyboardType = keyboardType
    answerTextField.spellCheckingType = .no
    topSeparator.backgroundColor = textColor.withAlphaComponent(0.5)
    configureDelegate(textDelegate)
  }
  
  private func commonInit() {
    translatesAutoresizingMaskIntoConstraints = false
    topSeparatorHeightConstraint.constant = 0.5
    backgroundColor = .clear
  }
  
  private func configureDelegate(_ textDelegate: TextChangeListener) {
    answerTextField.delegate = textDelegate
    answerTextField.addTarget(textDelegate,
                              action: #selector(textDelegate.textDidChange),
                              for: .editingChanged)
  }

  func removeTopSeparator() {
    topSeparator.backgroundColor = .clear
  }
}
