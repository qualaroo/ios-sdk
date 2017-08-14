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
    do {
      try Qualaroo.shared.showSurvey(with: "YourSurveyAlias", on: self)
    } catch {
      print(String(reflecting: error))
    }
  }

}

