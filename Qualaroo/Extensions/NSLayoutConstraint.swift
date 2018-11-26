//
//  NSLayoutConstraint.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

let UILayoutPriorityVeryHigh = UILayoutPriority(900)

extension NSLayoutConstraint {
  convenience init(connect view1: Any,
                   attribute attr1: NSLayoutConstraint.Attribute,
                   relatedBy relation: NSLayoutConstraint.Relation = .equal,
                   to view2: Any?,
                   attribute attr2: NSLayoutConstraint.Attribute,
                   multiplier: CGFloat = 1,
                   constant: CGFloat = 0) {
    self.init(item: view1, attribute: attr1, relatedBy: relation,
              toItem: view2, attribute: attr2, multiplier: multiplier, constant: constant)
  }
  
  static func connectEdges(_ edges: [NSLayoutConstraint.Attribute],
                           of firstView: UIView,
                           to secondView: UIView) {
    for edge in edges {
      NSLayoutConstraint(connect: firstView, attribute: edge,
                         to: secondView, attribute: edge, constant: 0).isActive = true
    }
  }
  
  static func fillView(_ superview: UIView, with subview: UIView) {
    superview.translatesAutoresizingMaskIntoConstraints = false
    subview.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 9.0, *) {
      fillUsingAnchors(superview, with: subview)
    } else {
      fillUsingConstraints(superview, with: subview)
    }
  }
  
  private static func fillUsingConstraints(_ superview: UIView, with subview: UIView) {
    connectEdges([.top, .bottom, .left, .right], of: subview, to: superview)
  }
  
  @available(iOS 9.0, *)
  private static func fillUsingAnchors(_ superview: UIView, with subview: UIView) {
    superview.topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
    superview.bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
    superview.leftAnchor.constraint(equalTo: subview.leftAnchor).isActive = true
    superview.rightAnchor.constraint(equalTo: subview.rightAnchor).isActive = true
  }
  
  static func fillScrollView(_ scrollView: UIScrollView,
                             with views: [UIView],
                             margin: CGFloat,
                             spacing: CGFloat) {
    if #available(iOS 9.0, *) {
      fillScrollUsingAnchors(scrollView, with: views, margin: margin, spacing: spacing)
    } else {
      fillScrollUsingConstraints(scrollView, with: views, margin: margin, spacing: spacing)
    }
  }
  
  private static func fillScrollUsingConstraints(_ scrollView: UIScrollView,
                                                 with views: [UIView],
                                                 margin: CGFloat,
                                                 spacing: CGFloat) {
    guard let lastView = views.last else { return }
    for (index, view) in views.enumerated() {
      view.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview(view)
      NSLayoutConstraint(connect: view, attribute: .width,
                         to: scrollView, attribute: .width,
                         constant: -2 * margin).isActive = true
      NSLayoutConstraint(connect: view, attribute: .left,
                         to: scrollView, attribute: .left,
                         constant: margin).isActive = true
      NSLayoutConstraint(connect: view, attribute: .right,
                         to: scrollView, attribute: .right,
                         constant: margin).isActive = true
      if index == 0 {
        NSLayoutConstraint(connect: view, attribute: .top,
                           to: scrollView, attribute: .top,
                           constant: spacing/2).isActive = true
      } else {
        let previousView = views[index-1]
        NSLayoutConstraint(connect: view, attribute: .top,
                           to: previousView, attribute: .bottom,
                           constant: spacing).isActive = true
      }
    }
    NSLayoutConstraint(connect: scrollView, attribute: .bottom,
                       to: lastView, attribute: .bottom,
                       constant: spacing/2).isActive = true
  }
  
  @available(iOS 9.0, *)
  private static func fillScrollUsingAnchors(_ scrollView: UIView,
                                             with views: [UIView],
                                             margin: CGFloat,
                                             spacing: CGFloat) {
    guard let lastView = views.last else { return }
    for (index, view) in views.enumerated() {
      view.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview(view)
      view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * margin).isActive = true
      view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: margin).isActive = true
      view.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: margin).isActive = true
      if index == 0 {
        view.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: spacing/2).isActive = true
      } else {
        let previousView = views[index-1]
        view.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: spacing).isActive = true
      }
    }
    scrollView.bottomAnchor.constraint(equalTo: lastView.bottomAnchor, constant: spacing/2).isActive = true
  }

}
