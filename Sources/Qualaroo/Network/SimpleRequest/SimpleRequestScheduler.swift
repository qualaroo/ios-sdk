//
//  SimpleRequestScheduler.swift
//  QualarooSDKiOS
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

class SimpleRequestScheduler {
    
  /// Queue that is used to execute operations which send responses.
  var privateQueue: OperationQueue
  /// Reachability object that contain logic for checking internet availability.
  private let reachability: Reachability?
  /// Saves and loades data.
  private let storage: ReportRequestMemoryProtocol
  
  init(reachability: Reachability?, storage: ReportRequestMemoryProtocol) {
    self.storage = storage
    self.reachability = reachability
    privateQueue = OperationQueue()
    privateQueue.name = "com.qualaroo.sendresponsequeue"
    privateQueue.maxConcurrentOperationCount = 4
    privateQueue.qualityOfService = .background
    addObservers()
    retryStoredAnswers()
  }
  
  deinit {
    removeObservers()
  }
  
  /// Resume executing requests.
  private func resumeQueue() {
    privateQueue.isSuspended = false
  }
  
  /// Stops executing requests.
  private func pauseQueue() {
    privateQueue.isSuspended = true
  }
  
  private func cleanQueue() {
    privateQueue.cancelAllOperations()
  }
  
  // MARK: - Notifications
  
  func addObservers() {
    observeForEnteringBackground()
    observeForEnteringForeground()
    observeForInternetAvailability()
  }
  
  func removeObservers() {
    stopObservingForEnteringBackground()
    stopObservingForEnteringForeground()
    stopObservingInternetAvailability()
  }
  
  // MARK: - Saving answers
  
  private func observeForEnteringBackground() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleEnteredBackground),
                                           name: UIApplication.didEnterBackgroundNotification,
                                           object: nil)
  }
  
  private func stopObservingForEnteringBackground() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIApplication.didEnterBackgroundNotification,
                                              object: nil)
  }
  
  private func observeForEnteringForeground() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleEnteringForeground),
                                           name: UIApplication.willEnterForegroundNotification,
                                           object: nil)
  }
  
  private func stopObservingForEnteringForeground() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIApplication.willEnterForegroundNotification,
                                              object: nil)
  }
  
  @objc func handleEnteredBackground() {
    pauseQueue()
    cleanQueue()
  }
  
  @objc func handleEnteringForeground() {
    retryStoredAnswers()
    if isInternetAvailable() {
      resumeQueue()
    }
  }

  func retryStoredAnswers() {
    let requests = storage.getAllRequests()
    for url in requests {
      scheduleRequest(URL(string: url)!)
    }
  }
  
  private class ReportRequestOperation: Operation {
    
    let maxRetryCount = 3

    let url: URL
    let storage: ReportRequestMemoryProtocol
    
    init(url: URL, storage: ReportRequestMemoryProtocol) {
      self.url = url
      self.storage = storage
    }
    
    override func main() {
      var success: Bool = false
      var tries = 0
      repeat {
        success = call(url, tries)
        tries += 1
      } while tries <= maxRetryCount && !success
      
      if success {
        storage.remove(reportRequest: url.absoluteString)
      }
    }
    
    private func call(_ url: URL, _ retryNum: Int) -> Bool {
      let timeToWait = pow(2, retryNum) - 1
      sleep(NSDecimalNumber(decimal: timeToWait).uint32Value)
      let request = ReportRequest(url)
      let result = request.call()
      return result.isSuccessful()
    }
    
  }
}

// MARK: - Internet
extension SimpleRequestScheduler {
  /// Call it to start observing internet status.
  private func observeForInternetAvailability() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(reachabilityChanged(_:)),
                                           name: reachabilityModified,
                                           object: reachability)
    do {
      try reachability?.startNotifier()
    } catch {
      pauseQueue()
    }
  }
  
  /// Use it to stop observing internet status. Should be used when class is being deallocated.
  private func stopObservingInternetAvailability() {
    NotificationCenter.default.removeObserver(self, name: reachabilityModified, object: reachability)
  }
  
  /// Function called when access to internet status changed while it's observed.
  ///
  /// - Parameter notification: notification that contain new reachability status.
  @objc func reachabilityChanged(_ notification: Notification) {
    guard (notification.object as? Reachability) != nil else { return }
    if isInternetAvailable() {
      resumeQueue()
    } else {
      pauseQueue()
    }
  }
  
  /// Check if devise have access to internet.
  ///
  /// - Returns: True if there is access of false if there isn't.
  private func isInternetAvailable() -> Bool {
    guard let reachability = reachability else { return false }
    return reachability.currentReachabilityStatus != .notReachable
  }
}

extension SimpleRequestScheduler: ReportRequestProtocol {
  func scheduleRequest(_ url: URL) {
    let operation = ReportRequestOperation(url: url, storage: storage)
    privateQueue.addOperation(operation)
  }
}
