//
//  RequireMap.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class RequireMapFactory {
  
  private struct DefaultValues {
    static let samplePercent: Int = 100
    static let targetUser: RequireMap.UserTargetType = .any
    static let deviceTypes: [RequireMap.DeviceTargetType] = [.phone, .tablet, .desktop]
  }
  
  let dictionary: [String: Any]
  
  init(with dictionary: [String: Any]) {
    self.dictionary = dictionary
  }
  
  func build() -> RequireMap {
    return RequireMap(revealSpecs: revealSpecs(),
                      customRequirementsRule: customRequirementsRule(),
                      samplePercent: samplePercent(),
                      targetUser: targetUserType(),
                      targetDevices: targetDevices())
  }
  
  private func revealSpecs() -> RequireMap.RevealSpecs {
    if dictionary.keys.contains("is_one_shot") { return .onlyOnce }
    if dictionary.keys.contains("is_persistent") { return .everyTime }
    return .untilAnswered
  }
  
  private func customRequirementsRule() -> String? {
    return dictionary["custom_map"] as? String
  }
  
  private func samplePercent() -> Int {
    guard let samplePercent = dictionary["sample_percent"] as? Int else {
      return DefaultValues.samplePercent
    }
    return samplePercent
  }
  
  private func targetUserType() -> RequireMap.UserTargetType {
    guard
      let string = dictionary["want_user_str"] as? String,
      let userType = RequireMap.UserTargetType(rawValue: string) else {
        return DefaultValues.targetUser
    }
    return userType
  }
  
  private func targetDevices() -> [RequireMap.DeviceTargetType] {
    guard let devicesList = dictionary["device_type_list"] as? [String] else {
      return DefaultValues.deviceTypes
    }
    let allowedDevices = devicesList.map { RequireMap.DeviceTargetType(rawValue: $0) }
    return allowedDevices.removeNils()
  }
  
}

struct RequireMap {
  
  let revealSpecs: RevealSpecs
  let customRequirementsRule: String?
  let samplePercent: Int
  let targetUser: UserTargetType
  let targetDevices: [DeviceTargetType]

  enum RevealSpecs {
    case onlyOnce, untilAnswered, everyTime
  }
  enum UserTargetType: String {
    case known = "yes"
    case unknown = "no"
    case any = "any"
  }
  enum DeviceTargetType: String {
    case phone, tablet, desktop, none
  }
  
}

extension RequireMap: Equatable {
  static func == (lhs: RequireMap, rhs: RequireMap) -> Bool {
    return lhs.revealSpecs == rhs.revealSpecs &&
      lhs.customRequirementsRule == rhs.customRequirementsRule &&
      lhs.samplePercent == rhs.samplePercent &&
      lhs.targetUser == rhs.targetUser &&
      lhs.targetDevices == rhs.targetDevices
  }

}
