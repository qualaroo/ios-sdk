//
//  SdkSession.swift
//  Qualaroo
//
//  Created by Marcin Robaczyński on 16/08/2018.
//  Copyright © 2018 Mihály Papp. All rights reserved.
//

import UIKit

struct SdkSession {
  
  let platform = "iOS"
  let osVersion = UIDevice.current.systemVersion
  let deviceModel = UIDevice.current.type
  let language: String = Locale.current.languageCode ?? "unknown"
  let sdkVersion: String = Bundle.qualaroo()?.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown"
  let appId: String = Bundle.main.bundleIdentifier ?? "unknown"
  let resolution: String
  let deviceType: String

  init() {
    let screenSize = UIScreen.main.bounds
    self.resolution = "\(Int(screenSize.width))x\(Int(screenSize.height))"
    self.deviceType = SdkSession.findDeviceType()
  }
  
  private static func findDeviceType() -> String {
    let idiom = UIDevice.current.userInterfaceIdiom
    switch(idiom) {
    case .phone:
      return "phone"
    case .pad:
      return "tablet"
    default:
      return "other"
    }
  }
  
}
