//
//  LeadGenFormView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

typealias LeadGenFormItem = (questionId: NodeId,
                             canonicalName: String?,
                             questionAlias: String?,
                             title: String,
                             kayboardType: UIKeyboardType,
                             isRequired: Bool)

class LeadGenFormView: UIView, FocusableAnswerView {
  
  var presenter: LeadGenFormPresenter?
  
  var cells = [LeadGenFormCell]()

  @IBOutlet weak var cellsScrollContainer: UIScrollView!
  @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var topBorderLine: UIView!
  @IBOutlet weak var topBorderHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomBorderLine: UIView!
  @IBOutlet weak var bottomBorderHeightConstraint: NSLayoutConstraint!
  
  func setupView(withBorderColor borderColor: UIColor,
                 textColor: UIColor,
                 keyboardStyle: UIKeyboardAppearance,
                 cells: [LeadGenFormCell],
                 presenter: LeadGenFormPresenter) {
    self.presenter = presenter
    commonSetup(withSeparatorColor: textColor)
    setup(withCells: cells)
    presenter.textDidChange()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    scrollViewHeightConstraint.constant = cellsScrollContainer.contentSize.height
  }
  
  private func commonSetup(withSeparatorColor color: UIColor) {
    translatesAutoresizingMaskIntoConstraints = false
    topBorderHeightConstraint.constant = 0.5
    bottomBorderHeightConstraint.constant = 0.5
    topBorderLine.backgroundColor = color.withAlphaComponent(0.5)
    bottomBorderLine.backgroundColor = color.withAlphaComponent(0.5)
  }
  
  func setup(withCells cells: [LeadGenFormCell]) {
    self.cells = cells
    NSLayoutConstraint.fillScrollView(cellsScrollContainer, with: cells, margin: 0, spacing: 1)
    scrollViewHeightConstraint.constant = 0
    cells.first?.removeTopSeparator()
  }
  
  func getFocus() {
    cells.first?.answerTextField.becomeFirstResponder()
  }
}
