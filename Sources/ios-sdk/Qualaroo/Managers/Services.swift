//
//  Services.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class Services {
  
  let reachability = Reachability()
  let persistentMemory = PersistentMemory()
  let autotrackingManager = AutotrackingManager(swizzler: MethodSwizzler())
  let imageStorage: ImageStorage
  
  init() {
    self.imageStorage = ImageStorage(defaultLogoNameMemory: persistentMemory)
  }

  func makeClientInfo() -> ClientInfo {
    return ClientInfo(deviceId: persistentMemory.getDeviceId())
  }
  func surveysFilter(clientInfo: ClientInfo) -> FilterProtocol {
    return SurveyFilterBuilder().withSamplePercent().build(storage: persistentMemory, clientInfo: clientInfo)
  }
  func surveyAbFilter(clientInfo: ClientInfo) -> FilterProtocol {
  return SurveyFilterBuilder().build(storage: persistentMemory, clientInfo: clientInfo)
  }

}
