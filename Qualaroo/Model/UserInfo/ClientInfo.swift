//
//  ClientInfo.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

struct ClientInfo {
    
  var clientId: String?
  let deviceId: String
  var customProperties = CustomProperties([:])
  var preferredLanguage: String?

  init(deviceId: String) {
    self.deviceId = deviceId
  }
  
}
