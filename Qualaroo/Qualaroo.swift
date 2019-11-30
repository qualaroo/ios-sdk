//
//  Qualaroo.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

/// Main component of SDK
public class Qualaroo: NSObject, Loggable {
  
  private var finishedDownloadingSurveys = false
  private var configured = false
  private let services = Services()
  private var fetchSurveysScheduler: FetchSurveysProtocol?
  private var surveys = [Survey]()
  private var clientInfo: ClientInfo

  private override init() {
    self.clientInfo = services.makeClientInfo()
  }

  private func fetchSurveys() {
    fetchSurveysScheduler?.fetchSurveys()
  }
  
  private func presentationController(from viewController: UIViewController?) -> UIViewController? {
    if viewController == nil {
      return UIApplication.shared.keyWindow?.rootViewController
    } else {
      return viewController?.navigationController ?? viewController
    }
  }

  func survey(forAlias alias: String) -> Survey? {
    return surveys.first(where: { $0.alias == alias })
  }
  
  enum UserError: Int, QualarooError {
    case wrongLanguageCode = 1
  }
  
  private func surveyView(_ survey: Survey, delegate: SurveyDelegate?) -> UIViewController {
    let assembly = SurveyAssembly(services: services, clientInfo: clientInfo, environment: currentEnvironment())
    return assembly.build(survey, delegate: delegate)
  }
  
  // MARK: - Debug
  @objc private static func newInstance() -> Qualaroo {
    return Qualaroo()
  }
  
  private var debugMode = false
  
  func currentEnvironment() -> Environment {
    return .production
  }
    
  enum Environment {
    case production, staging
  }

}

extension Qualaroo: FetchSurveysDelegate {

  func fetchedSurveys(_ surveys: [Survey]) {
    self.surveys = surveys
    finishedDownloadingSurveys = true
  }
  
  func fetchingFinishedWithError(_ error: Error) {
    Qualaroo.log(error)
    Qualaroo.log("Failed loading surveys. Next attempt in 60 minutes.")
  }
}

extension Qualaroo {
  
  func shouldPresent(survey: Survey, forced: Bool, filters: FilterProtocol) -> Bool {
    guard isConfigured() else {
      Qualaroo.log("First you need to call Qualaroo.shared.configure(withApiKey:)")
      return false
    }
    guard isReady() else {
      Qualaroo.log("Module didn't finish featching survey list yet.")
      return false
    }
    return forced || filters.shouldShow(survey: survey)
  }
  
  func surveyToPresent(alias: String, forced: Bool) -> Survey? {
    guard let selectedSurvey = survey(forAlias: alias) else {
      Qualaroo.log("There is no survey with such alias.")
      return nil
    }
    let filters = services.surveysFilter(clientInfo: clientInfo)
    guard shouldPresent(survey: selectedSurvey, forced: forced, filters: filters) else { return nil }
    return selectedSurvey
  }
  
  func present(survey: Survey,
               on viewController: UIViewController?,
               delegate: SurveyDelegate?) {
    guard let presentationController = presentationController(from: viewController) else {
      Qualaroo.log("There is no presentationViewController.")
      return
    }
    let surveyVC = surveyView(survey, delegate: delegate)
    DispatchQueue.main.async {
      surveyVC.modalPresentationStyle = .overCurrentContext
      presentationController.present(surveyVC, animated: true, completion: nil)
    }
  }

}
// MARK: - Public interface
extension Qualaroo {
  
  // MARK: - Class methods
  /// Instance of Qualaroo class that should be used.
  @objc public static let shared = Qualaroo()
  /// Flag saying if Qualaroo module has been configured
  @objc public static func isConfigured() -> Bool {
    return Qualaroo.shared.isConfigured()
  }
  @objc public func isConfigured() -> Bool {
    return configured
  }
  /// Flag saying if Qualaroo module has already finished featching all data, and it's ready for displaying surveys.
  @objc public static func isReady() -> Bool {
    return Qualaroo.shared.isReady()
  }
  @objc public func isReady() -> Bool {
    return finishedDownloadingSurveys
  }
  @objc public func setDebugMode(_ isEnabled: Bool) {
    return Qualaroo.shared.debugMode = isEnabled
  }
  @objc public func isDebugMode() -> Bool {
        return Qualaroo.shared.debugMode
  }
    
  // MARK: - Configuration
  /// You need to call this method on Qualaroo.shared to create and configure main component with given credentials.
  ///
  /// - Parameters:
  ///   - apiKey: String that authenticate user. You can get it from https://app.qualaroo.com/dashboard by tapping on
  /// "Setup" when you expand selected site/application.
  ///   - autotracking: Flag that decide if survey should be shown on controller with same class name or title as
  /// survey name (alias) without any 'showSurvey' call. By default it's true.
  @available(*, deprecated, message: """
  This method will be removed in future releases, please use 'configure(with:)' instead.
  
  Keep in mind that calling 'configure(with:)' will not turn AutoShow (formerly Autotracking) on\
  by default, in opposition to 'configure(withApiKey:autotracking:)'.
  If you want to enable AutoShow - call 'turnOnAutoShow()'.
  """)
  @objc public func configure(withApiKey apiKey: String, autotracking: Bool = true) {
    configure(with: apiKey)
    if autotracking {
      turnOnAutoShow()
    }
  }
  
  /// You need to call this method on Qualaroo.shared to create and configure main component with given credentials.
  ///
  /// - Parameters:
  ///   - apiKey: String that authenticate user. You can get it from https://app.qualaroo.com/dashboard by tapping on
  /// "Setup" when you expand selected site/application.
  @objc public func configure(with apiKey: String) {
    guard let credentials = Credentials(withKey: apiKey) else {
      Qualaroo.log("There was problem with given key. Check if it's correct.")
      return
    }
    let composer = FetchSurveysComposer(siteId: credentials.siteId,
                                        deviceId: clientInfo.deviceId,
                                        environment: currentEnvironment())
    guard let fetchSurveysUrl = composer.url() else {
      Qualaroo.log("There was problem with given key. Check if it's correct.")
      return
    }
    let authentication = composer.authentication(apiKey: credentials.apiKey, apiSecret: credentials.apiSecret)
    fetchSurveysScheduler = FetchSurveysScheduler(url: fetchSurveysUrl,
                                                  authentication: authentication,
                                                  reachability: services.reachability,
                                                  imageStorage: services.imageStorage,
                                                  delegate: self)
    fetchSurveys()
    configured = true
  }
  
  /// Calling this function forces SDK to refresh survey list and schedules next survey update in 1 hour.
  @objc public func updateSurveysNow() {
    guard isConfigured() else {
      Qualaroo.log("""
      Cannot fetch survey list. Qualaroo module needs to be configured using configure(with:) function first.
      """)
      return
    }
    fetchSurveys()
  }
  
  /// Turn on auto showing surveys feature.
  /// If used survey will be shown on controller with same class name or title as survey name (alias)
  /// without any 'showSurvey' call.
  /// It's swizzling viewDidAppear. Use with caution.
  /// Can be disabled later with `turnOffAutotracking()`.
  public func turnOnAutoShow() {
    services.autotrackingManager.enableAutotracking()
  }
  
  /// Turning off auto showing surveys feature.
  public func turnOffAutoShow() {
    services.autotrackingManager.disableAutotracking()
  }

  /// Set dafault language that you want to use for surveys. If survey won't support preferred language it will try
  /// to use English, if it's also not supported then it will use first one from supported languages.
  ///
  /// Parameter must be passed as an ISO 639-1 Language Code. In some rare cases you may use it in conjuction with ISO 3166-1 alpha-2 code. Keep in mind that this is not yet fully supported.
  /// An example of such conjuction: "zh_TW"
  /// - Parameter language: valid language code 
  @objc public func setPreferredSurveysLanguage(_ language: String) throws {
    clientInfo.preferredLanguage = language
  }
  
  /// Way to set default image of logo used on surveys.
  /// If not set it will use application icon, or qualaroo logo if application icon is unavailable.
  /// Keep in mind it will be overriden by logo set in the dashboard.
  ///
  /// - Parameter name: Name of UIImage we want to use for logo.
  @objc public func setDefaultLogo(name: String) {
    services.persistentMemory.saveDefaultLogoName(name)
  }
  
  /// Way to identify user. This ID will be sent with every response user gave us. Can be changed between surveys.
  ///
  /// - Parameter userID: Unique ID of current user.
  @objc public func setUserID(_ userID: String) {
    self.clientInfo.clientId = userID
  }
  
  /// Set custom properties of current user.
  ///
  /// - Parameter userProperties: Dictionary containing additional info about current user. Used for custom survey
  /// targeting. Should match schema used by dashboard on web.
  @objc public func setUserProperties(_ userProperties: [String: String]) {
    clientInfo.customProperties = CustomProperties(userProperties)
  }
  
  /// Add or change one userProperty.
  ///
  /// - Parameters:
  ///   - key: String that is used as a key of property we want to add/update.
  ///   - value: New value of property that we are passing.
  @objc public func addUserProperty(_ key: String, withValue value: String) {
    clientInfo.customProperties.dictionary[key] = value
  }
  
  /// Remove userProperty if there is one. If there is no property with given key nothing happens.
  ///
  /// - Parameter key: String that is used as a key of property we want to remove.
  @objc public func removeUserProperty(_ key: String) {
    clientInfo.customProperties.dictionary.removeValue(forKey: key)
  }
  
  /// Gives copy of userProperties.
  ///
  /// - Returns: Dictionary with previously set userProperties.
  @objc public func userProperties() -> [String: String] {
    return clientInfo.customProperties.dictionary
  }
  
  // MARK: - Showing Surveys
  /// Way to show survey with selected name (alias).
  ///
  /// - Parameters:
  ///   - alias: Name of survey we want to show.
  /// Check "target" section of survey creation/editing on Qualaroo dashboard.
  ///   - viewController: UIViewController you want to show survey on.
  /// If you skip this param or send a nil, survey will be shown on the rootViewController.
  /// Otherwise it will try to use a navigationController of a given viewController to present survey view,
  /// or viewController itself if there no navigationController available.
  /// You need to be careful if with using view controllers that are not full screen.
  ///   - forced: skips all targeting checks if set to true.
  /// This will cause the survey to always be shown, as long as it's active. Use with precaution. Defaults to false.
  ///   - delegate: Object that will receive information about survey starting, dismissing and finishing.
  @objc public func showSurvey(with alias: String,
                               on viewController: UIViewController? = nil,
                               forced: Bool = false,
                               delegate: SurveyDelegate? = nil) {
    guard let survey = surveyToPresent(alias: alias, forced: forced) else { return }
    present(survey: survey, on: viewController, delegate: delegate)
  }
    
  /// Allows to check whether specific survey will be displayed after showSurvey call
  ///
  /// - Parameters:
  ///   - alias: alias of the survey
    @objc public func willSurveyBeShown(with alias: String) -> Bool {
      guard surveyToPresent(alias: alias, forced: false) != nil else {
        return false
      }
      return true
    }

  /// Way to ABTest surveys with selected names (aliases).
  ///
  /// - Parameters:
  ///   - aliases: List of survey names that we want to take part in AB test. Proablity of showing specific survey can
  /// be set on Qualaroo dashboard, under "Target" tab. Note that targetting options for all surveys (apart from target
  /// percent) should be exacly the same if we want AB test to be correct.
  ///   - viewController: UIViewController you want to show survey on.
  /// If you skip this param or send a nil, survey will be shown on the rootViewController.
  /// Otherwise it will try to use a navigationController of a given viewController to present survey view,
  /// or viewController itself if there no navigationController available.
  /// You need to be careful if with using view controllers that are not full screen.
  ///   - forced: skips all targeting checks if set to true.
  /// This will cause the survey to always be shown, as long as it's active. Use with precaution. Defaults to false.
  ///   - delegate: Object that will receive information about survey starting, dismissing and finishing.
  @objc public func abTestSurveys(with aliases: [String],
                                  on viewController: UIViewController? = nil,
                                  forced: Bool = false,
                                  delegate: SurveyDelegate? = nil) {
    let surveysToTest = aliases.map({ survey(forAlias: $0)}).removeNils()
    let filters = services.surveyAbFilter(clientInfo: clientInfo)
    let abTest = ABTest(surveys: surveysToTest, memory: services.persistentMemory, filters: filters)
    abTest.show(on: viewController, forced: forced, delegate: delegate)
  }
}
