//
//  SurveysAssemblySpec.swift
//  QualarooTests
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit
import Quick
import Nimble
@testable import Qualaroo

class SurveysAssemblySpec: QuickSpec {
  override func spec() {
    super.spec()
    
    describe("SurveysAssembly") {
      it("creates surveys module and attach it to view") {
        let services = Services()
        let clientInfo = services.makeClientInfo()
        let assembly = SurveyAssembly(services: services, clientInfo: clientInfo, environment: .staging)
        let survey = try! SurveyFactory(with: JsonLibrary.survey(languagesList: ["en"])).build()
        let view = assembly.build(survey, delegate: nil)
        expect(view).to(beAnInstanceOf(SurveyView.self))
      }
    }
  }
}
