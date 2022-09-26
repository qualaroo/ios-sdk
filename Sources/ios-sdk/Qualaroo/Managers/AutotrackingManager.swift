//
//  AutotrackingManager.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class AutotrackingManager {
  
  static private var isViewDidAppearSwizzled = false
  private let swizzler: MethodSwizzler
  
  init(swizzler: MethodSwizzler) {
    self.swizzler = swizzler
  }
  
  func enableAutotracking() {
    setAutotrackingEnabled(true)
  }
  
  func disableAutotracking() {
    setAutotrackingEnabled(false)
  }
  
  private func setAutotrackingEnabled(_ enabled: Bool) {
    if AutotrackingManager.isViewDidAppearSwizzled == enabled { return }
    AutotrackingManager.isViewDidAppearSwizzled = enabled
    swizzleViewDidAppear()
  }
  
  private func swizzleViewDidAppear() {
    let originalSelector = #selector(UIViewController.viewDidAppear(_:))
    let swizzledSelector = #selector(UIViewController.qualaroo_viewDidAppear(_:))
    swizzler.swizzle(originalSelector,
                     with: swizzledSelector,
                     aClass: UIViewController.self)
  }
}

class MethodSwizzler {
  func swizzle(_ firstSelector: Selector,
               with secondSelector: Selector,
               aClass: AnyClass) {
    guard let firstMethod = class_getInstanceMethod(aClass, firstSelector),
          let secondMethod = class_getInstanceMethod(aClass, secondSelector) else { return }
    
    let didAddMethod = class_addMethod(aClass,
                                       firstSelector,
                                       method_getImplementation(secondMethod),
                                       method_getTypeEncoding(secondMethod))
    
    if didAddMethod {
      class_replaceMethod(aClass,
                          secondSelector,
                          method_getImplementation(firstMethod),
                          method_getTypeEncoding(secondMethod))
    } else {
      method_exchangeImplementations(firstMethod, secondMethod)
    }
  }
}
