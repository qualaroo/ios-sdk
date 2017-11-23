//
//  AppDelegate.swift
//  Swift Qualaroo Demo
//
//  Created by Mihály Papp on 14/08/2017.
//  Copyright © 2017 Mihály Papp. All rights reserved.
//

import UIKit
import Qualaroo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Qualaroo.shared.configure(withApiKey: "YourApiKey==")
    return true
  }
  
}

