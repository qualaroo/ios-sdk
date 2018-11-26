//
//  ImageDownloader.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

typealias ImageFetchBlock = (UIImage) -> Void

class ImageStorage {
  
  weak var defaultLogoNameMemory: DefaultLogoNameMemoryProtocol?
  
  init(defaultLogoNameMemory: DefaultLogoNameMemoryProtocol) {
    self.defaultLogoNameMemory = defaultLogoNameMemory
  }
  
  func getImage(forUrl urlString: String, completion: @escaping ImageFetchBlock = { _ in }) {
    guard let url = URL(string: urlString) else { return }
    downloadImage(fromUrl: url) { (image) in
      completion(image)
    }
  }
  
  private func downloadImage(fromUrl url: URL, completion: @escaping ImageFetchBlock) {
    let request = URLRequest.init(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
    URLSession.shared.dataTask(with: request) { data, _, error in
      guard
        error == nil,
        let data = data,
        let image = UIImage(data: data) else { return }
      completion(image)
      }.resume()
  }
  
  func defaultLogoImage() -> UIImage? {
    if let image = customDefaultImage() {
      return image
    } else if let image = appIcon() {
      return image
    } else {
      return qualarooImage()
    }
  }
  
  private func customDefaultImage() -> UIImage? {
    guard let imageName = defaultLogoNameMemory?.getDefaultLogoName() else { return nil }
    return UIImage(named: imageName)
  }
  
  private func appIcon() -> UIImage? {
    guard
      let iconsDict = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
      let primaryIconsDict = iconsDict["CFBundlePrimaryIcon"] as? [String: Any],
      let iconName = primaryIconsDict["CFBundleIconName"] as? String else { return nil }
    return UIImage(named: iconName)
  }
  
  private func qualarooImage() -> UIImage? {
    return UIImage(named: "logo_ico",
                   in: Bundle.qualaroo(),
                   compatibleWith: nil)
  }
}
