//
//  UIViewController.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit
import UIKit

// MARK: - Autoshow Survey Extension
extension UIViewController {
  
  @objc func qualaroo_viewDidAppear(_ animated: Bool) {
    qualaroo_viewDidAppear(animated)
    tryToShowSurvey()
  }
  
  private func tryToShowSurvey() {
    if isViewControllerIncorrect() { return }
    if let alias = fittingAlias() {
      Qualaroo.shared.showSurvey(with: alias)
    }
  }
  private func isViewControllerIncorrect() -> Bool {
    if self.nibBundle == Bundle.qualaroo() { return true }
    if !view.isMember(of: UIView.self) { return true }
    return false
  }
  private func fittingAlias() -> String? {
    return possibleAliases().first(where: { Qualaroo.shared.survey(forAlias: $0) != nil})
  }
  private func possibleAliases() -> [String] {
    return [className(), self.title].removeNils()
  }
  private func className() -> String? {
    let simpleName: String = String(describing: type(of: self))
    guard
      let name = simpleName.components(separatedBy: ".").last,
      name.isEmpty == false else { return nil }
    return name
  }
  
}
