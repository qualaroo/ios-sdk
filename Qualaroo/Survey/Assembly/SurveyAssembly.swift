//
//  SurveyAssembly.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class SurveyAssembly {

  private struct ViewNames {
    static let storyboard = "QualarooStoryboard"
    static let viewController = "SurveyView"
  }

  let services: Services
  let clientInfo: ClientInfo
  let environment: Qualaroo.Environment
  
  init(services: Services, clientInfo: ClientInfo, environment: Qualaroo.Environment) {
    self.services = services
    self.clientInfo = clientInfo
    self.environment = environment
  }

  func build(_ survey: Survey,
             delegate: SurveyDelegate?) -> UIViewController {
    let surveyView = viewInstance()
    let interactor = surveyInteractor(survey: survey, delegate: delegate)
    let presenter = surveyPresenter(survey: survey, interactor: interactor)
    interactor.surveyPresenter = presenter
    surveyView.attach(presenter: presenter, imageStorage: services.imageStorage)
    return surveyView
  }

  private func viewInstance() -> SurveyView {
    let storyboard = UIStoryboard(name: ViewNames.storyboard, bundle: Bundle.qualaroo())
    let viewController = storyboard.instantiateViewController(withIdentifier: ViewNames.viewController)
    guard let surveyView = viewController as? SurveyView else { return SurveyView() }
    return surveyView
  }

  private func surveyInteractor(survey: Survey, delegate: SurveyDelegate?) -> SurveyInteractor {
    var languages: [String] = []
    if let language = clientInfo.preferredLanguage {
        languages.append(language)
    }
    let deviceLanguages = Locale.preferredLanguages.map { String($0.split(separator: "-")[0]) }
    languages.append(contentsOf: deviceLanguages)
    let wireframe = SurveyWireframe(survey: survey, languages: languages)
    let client = reportClient(surveyId: survey.surveyId)
    let progressCalculator = ProgressCalculator(wireframe)
    return SurveyInteractor(wireframe: wireframe,
                            reportClient: client,
                            storage: services.persistentMemory,
                            urlOpener: UrlOpener(),
                            delegate: delegate,
                            progressCalculator: progressCalculator)
  }

  private func reportClient(surveyId: Int) -> ReportClient {
    let composer = urlComposer(surveyId: surveyId)
    let simpleRequestScheduler = SimpleRequestScheduler(reachability: services.reachability,
                                                        storage: services.persistentMemory)
    return ReportClient(simpleRequestScheduler, composer, services.persistentMemory)
  }

  private func urlComposer(surveyId: Int) -> UrlComposer {
    let session = SessionInfo(surveyId: surveyId,
                              clientId: clientInfo.clientId,
                              deviceId: clientInfo.deviceId,
                              sessionId: UUID().uuidString)
    return UrlComposer(sessionInfo: session,
                       customProperties: clientInfo.customProperties,
                       environment: environment,
                       sdkSession: SdkSession())
    
  }

  private func surveyPresenter(survey: Survey, interactor: SurveyInteractor) -> SurveyPresenter {
    let converter = PropertyInjector(customProperties: clientInfo.customProperties)
    return SurveyPresenter(theme: survey.theme, interactor: interactor, converter: converter)
  }
}
