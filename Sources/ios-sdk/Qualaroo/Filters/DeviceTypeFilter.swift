//
//  DeviceTypeFilter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class DeviceTypeFilter {
  
  init(withInterfaceIdiom interfaceIdiom: UIUserInterfaceIdiom) {
    self.interfaceIdiom = interfaceIdiom
  }
  
  let interfaceIdiom: UIUserInterfaceIdiom
  
  private func isDeviceCorrect(allowedDevices: [RequireMap.DeviceTargetType],
                               surveyId: Int) -> Bool {
    switch interfaceIdiom {
    case .phone where allowedDevices.contains(.phone) == false:
      Qualaroo.log("""
        Not showing survey with id: \(surveyId).
        Survey should not be displayed on phones.
        """)
      return false
    case .pad where allowedDevices.contains(.tablet) == false:
      Qualaroo.log("""
        Not showing survey with id: \(surveyId).
        Survey should not be displayed on tablets.
        """)
      return false
    default:
      return true
    }
  }
}

extension DeviceTypeFilter: FilterProtocol {
  func shouldShow(survey: Survey) -> Bool {
    return isDeviceCorrect(allowedDevices: survey.requireMap.targetDevices,
                           surveyId: survey.surveyId)
  }
}
