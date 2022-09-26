//
//  Credentials.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

/// Wrapper class for credentials. Initialized by apiKey that client can get from Qualaroo dashboard.
class Credentials {
  
  /// Used as name of client.
  var apiKey: String
  /// Used as password of client.
  var apiSecret: String
  /// Unique number identifier that points to surveys created by current client.
  var siteId: String
  
  init?(withKey key: String) {
    guard
      let data = Data(base64Encoded: key),
      let decodedString = String(data: data, encoding: .utf8) else { return nil }
    let array = decodedString.components(separatedBy: ":")
    guard
      array.count == 3,
      array.filter({ $0 == "" }).count == 0 else { return nil }
    let apiKey = array[0]
    let apiSecret = array[1]
    let siteId = array[2]
    guard siteId.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else { return nil }
    guard apiKey.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else { return nil }
    self.apiKey = apiKey
    self.apiSecret = apiSecret
    self.siteId = siteId
  }
}
