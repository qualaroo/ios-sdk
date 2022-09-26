//
//  HTTPURLResponse.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

extension HTTPURLResponse {
  func isSuccessful() -> Bool {
    return statusCode >= 200 && statusCode < 300
  }
}
