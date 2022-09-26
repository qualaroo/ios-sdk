//
//  Logger.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import UIKit

protocol Loggable: class {
  static func log(_ string: String)
  static func log(_ error: Error)
}

extension Loggable {
  static func log(_ string: String) {
    Logger.sharedInstance.log(string)
  }
  static func log(_ error: Error) {
    if let error = error as? QualarooError {
      Logger.sharedInstance.log(error.qualarooDescription())
    } else {
      Logger.sharedInstance.log(error.localizedDescription)
    }
  }
}

class Logger {
  
  static let sharedInstance = Logger()
  
  func log(_ string: String) {
    if (Qualaroo.shared.isDebugMode()) {
      print("[Qualaroo]: \(string)")
    }
  }
}

protocol QualarooError: Error {
  func qualarooDescription() -> String
}

extension QualarooError {
  func qualarooDescription() -> String {
    return """
    Survey parsing error.
    Please update your SDK and/or survey.
    If you still see this error contact us at support@qualaroo.com and attach this error code.
    \(self.localizedDescription)
    """
  }
}
