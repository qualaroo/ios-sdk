//
//  SessionInfo.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

struct SessionInfo {
  
  let surveyId: Int
  let clientId: String?
  let deviceId: String
  let sessionId: String
  
  init(surveyId: Int,
       clientId: String?,
       deviceId: String,
       sessionId: String) {
    self.surveyId = surveyId
    self.clientId = clientId
    self.deviceId = deviceId
    self.sessionId = sessionId
  }
}
