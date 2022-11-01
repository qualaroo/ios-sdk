//
//  AnswerNpsView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

class AnswerNpsView: UIView {
  
  private struct Const {
    static let minimumPressDuration: CFTimeInterval = 0.05
    static let longPressHeightOffset: CGFloat = 20
  }
  
  var interactor: AnswerNpsInteractor!
  
  @IBOutlet weak var npsSegmentedControl: UISegmentedControl!
  @IBOutlet weak var minLabel: UILabel!
  @IBOutlet weak var maxLabel: UILabel!

  func setupView(backgroundColor: UIColor,
                 minText: String,
                 maxText: String,
                 textColor: UIColor,
                 npsColor: UIColor,
                 interactor: AnswerNpsInteractor) {

    self.backgroundColor = backgroundColor
    minLabel.textColor = textColor
    minLabel.text = minText
    maxLabel.textColor = textColor
    maxLabel.text = maxText
    npsSegmentedControl.layer.borderColor = textColor.cgColor
    npsSegmentedControl.layer.borderWidth = 1
    npsSegmentedControl.setDividerImage(imageWithColor(color: textColor), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    npsSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: UIControl.State.normal)
    npsSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: backgroundColor], for: UIControl.State.selected)
    if #available(iOS 13.0, *) {
        npsSegmentedControl.selectedSegmentTintColor = npsColor
        npsSegmentedControl.backgroundColor = backgroundColor
    } else {
        //tint color does no longer work starting with iOS 13.0
        npsSegmentedControl.tintColor = npsColor
    }
    self.interactor = interactor
    enableTapAndSlide()
  }

      private func imageWithColor(color: UIColor) -> UIImage {
          let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
          UIGraphicsBeginImageContext(rect.size)
          let context = UIGraphicsGetCurrentContext()
          context!.setFillColor(color.cgColor);
          context!.fill(rect);
          let image = UIGraphicsGetImageFromCurrentImageContext();
          UIGraphicsEndImageContext();
          return image!
      }

  private func enableTapAndSlide() {
    let recognizer = UILongPressGestureRecognizer(target: self,
                                                  action: #selector(pressed))
    recognizer.minimumPressDuration = Const.minimumPressDuration
    npsSegmentedControl.addGestureRecognizer(recognizer)
  }
  @IBAction private func valueChanged(_ sender: UISegmentedControl) {
    if sender != npsSegmentedControl { return }
    answerWasSelected()
  }
  @objc func pressed(sender: UILongPressGestureRecognizer) {
    guard let segmentSelected = segment(forPoint: sender.location(in: npsSegmentedControl)) else { return }
    npsSegmentedControl.selectedSegmentIndex = segmentSelected
    answerWasSelected()
  }
  private func answerWasSelected() {
    let selectedIndex = npsSegmentedControl.selectedSegmentIndex
    interactor?.setAnswer(selectedIndex)
  }
  private func segment(forPoint point: CGPoint) -> Int? {
    let fullWidth = npsSegmentedControl.bounds.width
    let singleWidth = fullWidth / CGFloat(npsSegmentedControl.numberOfSegments)
    let height = npsSegmentedControl.bounds.height + Const.longPressHeightOffset
    if point.y < 0 || point.y > height || point.x < 0 || point.y > fullWidth {
      return nil
    }
    return Int(point.x / singleWidth)
  }
}
