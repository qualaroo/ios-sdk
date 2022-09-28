//
//  Bundle.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

import Foundation

private class BundleFinder {}

extension Bundle {
  /// Convenience way to get Qualaroo bundle.
  ///
  /// - Returns: Bundle used internally by Qualaroo Framework.
    static func qualaroo() -> Bundle? {
        let bundle = Bundle(for: Qualaroo.self)
        if (containsQualarooResources(bundle)) {
            Qualaroo.log("Using Qualaroo.self bundle")
            return bundle
        }
        
        guard let url = bundle.resourceURL else {
            Qualaroo.log("Qualaroo.self bundle resourceUrl is nil.")
            return nil
        }
        
        let qualarooBundleUrl = url.appendingPathComponent("Qualaroo.bundle")
        let qualarooBundle = Bundle(url: qualarooBundleUrl)
        if (!containsQualarooResources(qualarooBundle)) {
            Qualaroo.log("Qualaroo.bundle does not exist or does not contain Qualaroo resources. Main path: \(url)")
        }
        return qualarooBundle
    }
    
    private static func containsQualarooResources(_ bundle: Bundle?) -> Bool {
        guard let bundle = bundle else { return false }
        let path = bundle.path(forResource: "AnswerBinaryView", ofType: "nib")
        return path != nil
    }
}
