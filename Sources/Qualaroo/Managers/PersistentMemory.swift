//
//  PersistentMemory.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import Foundation
import UIKit

class PersistentMemory {
  
  private struct Keys {
    static let defaultLogoName = "defaultLogoName"
    static let seenSurveys = "seenSurveys"
    static let finishedSurveys = "finishedSurveys"
    static let samplePercent = "samplePercents"
    static let savedRequests = "savedRequests"
    static let deviceId = "anonymousUserID"
  }
  
  private let accessQueue = DispatchQueue(label: "reportRequestSync")
  var memory: UserDefaults = UserDefaults(suiteName: "Qualaroo")!
  
  func resetStoredData() {
    for key in memory.dictionaryRepresentation().keys {
      memory.removeObject(forKey: key)
    }
    memory.removePersistentDomain(forName: "Qualaroo")
    memory = UserDefaults(suiteName: "Qualaroo")!
  }
  func save(_ strings: [String], forKey key: String) {
    memory.set(strings, forKey: key)
    memory.synchronize()
  }
  func save(_ string: String, forKey key: String) {
    memory.set(string, forKey: key)
    memory.synchronize()
  }
  func value(forKey key: String) -> Any? {
    return memory.value(forKey: key)
  }
  func remove(valueForKey key: String) {
    memory.removeObject(forKey: key)
    memory.synchronize()
  }
}

extension PersistentMemory: ReportRequestMemoryProtocol {
  
  func store(reportRequest: String) {
    accessQueue.sync {
      var requests =  memory.value(forKey: Keys.savedRequests) as? [String] ?? [String]()
      requests.append(reportRequest)
      memory.set(requests, forKey: Keys.savedRequests)
    }
  }
  
  func remove(reportRequest: String) {
    accessQueue.sync {
      var requests =  memory.value(forKey: Keys.savedRequests) as? [String] ?? [String]()
      requests.lastIndex(of: reportRequest).ifNotNull {
        requests.remove(at: $0)
      }
      memory.set(requests, forKey: Keys.savedRequests)
    }
  }
  
  func getAllRequests() -> [String] {
    return accessQueue.sync {
      memory.value(forKey: Keys.savedRequests) as? [String] ?? [String]()
    }
  }
}

extension Optional where Wrapped: Any {
  func ifNotNull(block: (Wrapped) -> ()) {
    if let value = self {
      block(value)
    }
  }
}


extension PersistentMemory: SeenSurveyMemoryProtocol {
  
  private func save(seenSurveys: [String: Date]) {
    memory.set(seenSurveys, forKey: Keys.seenSurveys)
  }
  private func readSeenSurveys() -> [String: Date] {
    return memory.value(forKey: Keys.seenSurveys) as? [String: Date] ?? [String: Date]()
  }
  
  func saveUserHaveSeen(surveyWithID surveyID: Int) {
    let surveyID = "\(surveyID)"
    var seenSurveys = readSeenSurveys()
    seenSurveys[surveyID] = Date()
    save(seenSurveys: seenSurveys)
  }
  func checkIfUserHaveSeen(surveyWithID surveyID: Int) -> Bool {
    let surveyID = "\(surveyID)"
    return readSeenSurveys().keys.contains(surveyID)
  }
  func lastSeenDate(forSurveyWithID surveyID: Int) -> Date? {
    let surveyID = "\(surveyID)"
    return readSeenSurveys()[surveyID]
  }
}

extension PersistentMemory: FinishedSurveyMemoryProtocol {
  
  private func save(finishedSurveys: [Int]) {
    memory.set(finishedSurveys, forKey: Keys.finishedSurveys)
  }
  private func readFinishedSurveys() -> [Int] {
    return memory.value(forKey: Keys.finishedSurveys) as? [Int] ?? [Int]()
  }
  
  func saveUserHaveFinished(surveyWithID surveyID: Int) {
    if checkIfUserHaveFinished(surveyWithID: surveyID) {
      return
    }
    var finishedSurveys = [Int]()
    finishedSurveys.append(surveyID)
    finishedSurveys.append(contentsOf: readFinishedSurveys())
    finishedSurveys.sort()
    save(finishedSurveys: finishedSurveys)
  }
  func checkIfUserHaveFinished(surveyWithID surveyID: Int) -> Bool {
    return readFinishedSurveys().contains(surveyID)
  }

}

extension PersistentMemory: SamplePercentMemoryProtocol {
  
  private var samplePercentDictionary: [String: Int] {
    let percents = memory.value(forKey: Keys.samplePercent) as? [String: Int]
    return percents ?? [:]
  }

  func getSamplePercent(forSurveyId surveyId: Int) -> Int? {
    return samplePercentDictionary["\(surveyId)"]
  }
  func saveSamplePercent(_ percent: Int, forSurveyId surveyId: Int) {
    var percents = samplePercentDictionary
    percents["\(surveyId)"] = percent
    memory.set(percents, forKey: Keys.samplePercent)
  }
  func getSamplePercent(forSurveysChain chain: String) -> Int? {
    return samplePercentDictionary[chain]
  }
  func saveSamplePercent(_ percent: Int, forSurveyChain chain: String) {
    var percents = samplePercentDictionary
    percents[chain] = percent
    memory.set(percents, forKey: Keys.samplePercent)
  }
}

extension PersistentMemory: DeviceIdMemoryProtocol {
  
  private func generateDeviceId() -> String {
    let userId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    save(userId, forKey: Keys.deviceId)
    return userId
  }
  
  func getDeviceId() -> String {
    guard
      let userId = value(forKey: Keys.deviceId) as? String,
      !userId.isEmpty else {
        return generateDeviceId()
    }
    return userId
  }
}

extension PersistentMemory: DefaultLogoNameMemoryProtocol {
  func saveDefaultLogoName(_ name: String) {
    save(name, forKey: Keys.defaultLogoName)
  }
  func getDefaultLogoName() -> String? {
    return value(forKey: Keys.defaultLogoName) as? String
  }
}
