//
//  XibView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import UIKit

class XibView: UIView {
  override func awakeFromNib() {
    guard
      let xib = Bundle.qualaroo().loadNibNamed(String(describing: type(of: self)),
                                               owner: self,
                                               options: nil),
      let views = xib as? [UIView],
      let subview = views.first else { return }
    addSubview(views[0])
    NSLayoutConstraint.fillView(self, with: subview)
  }
}
