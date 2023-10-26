//
//  ViewController.swift
//  Swift Qualaroo Demo
//
//  Created by Mihály Papp on 14/08/2017.
//  Copyright © 2017 Mihály Papp. All rights reserved.
//

import UIKit
import Qualaroo

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func showSurvey(_ sender: Any) {
    Qualaroo.shared.showSurvey(with: "nps__net_promoter_score",
                               on: self,
                               delegate: self)
  }

}

extension ViewController: SurveyDelegate {
  func surveyDidStart() { print("surveyDidStart") }
  func surveyDidDismiss() { print("surveyDidDismiss") }
  func surveyDidFinish() { print("surveyDidFinish") }
  func surveyDidClose(errorMessage: String) { print("surveyDidClose errorMessage: \(errorMessage)") }
}
