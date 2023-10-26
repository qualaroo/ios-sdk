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

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Qualaroo.shared.configure(with: "Njk0OTU6OGY2N2ViYWVjMTZmN2M0ZjBjNTVmYzcyOTJlZGFkMmVlMjFhOTk3YTo2Nzc4Nw==")
    return true
  }
  
}

