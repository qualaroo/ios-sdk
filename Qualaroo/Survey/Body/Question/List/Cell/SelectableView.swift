//
//  SelectableView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

protocol SelectableViewDelegate: class {
  func viewWasSelected(_ selectedView: SelectableView)
  func viewTextChanged(_ selectedView: SelectableView)
}

protocol SelectionImageProvider {
  func normalAccessory() -> UIImage
  func selectedAccessory() -> UIImage
}

class ImageProvider: SelectionImageProvider {
  
  private let normalImage: UIImage
  private let selectedImage: UIImage
  
  init(normalColor: UIColor,
       normalImage: UIImage,
       selectedColor: UIColor,
       selectedImage: UIImage) {
    self.normalImage = normalImage.tinted(with: normalColor)
    self.selectedImage = selectedImage.tinted(with: selectedColor)
  }
  
  func normalAccessory() -> UIImage {
    return normalImage
  }
  func selectedAccessory() -> UIImage {
    return selectedImage
  }
}

class SelectableView: UIView {
  
  struct ViewModel {
    let title: String
    let textColor: UIColor
    let normalBorderColor: UIColor
    let selectedBorderColor: UIColor
    let expandabable: Bool
  }
  
  class Builder {
    
    let imageProvider: SelectionImageProvider
    weak var delegate: SelectableViewDelegate?
    let viewModel: ViewModel
    lazy var view: SelectableView = {
      guard
        let nib = Bundle.qualaroo()?.loadNibNamed("SelectableView", owner: nil, options: nil),
        let view = nib.first as? SelectableView else { return SelectableView() }
      return view
    }()
    
    init(imageProvider: SelectionImageProvider,
         delegate: SelectableViewDelegate,
         viewModel: ViewModel) {
      self.imageProvider = imageProvider
      self.delegate = delegate
      self.viewModel = viewModel
    }
    
    func build() -> SelectableView {
      transferViewModelConsts()
      setupFreeformTextView()
      setupColorsAndText()
      view.delegate = delegate
      view.isCommentAllowed = viewModel.expandabable
      view.updateAccessibilityIdentifier(isSelected: false)
      view.collapse()
      return view
    }
    
    private func transferViewModelConsts() {
      view.normalBorderColor = viewModel.normalBorderColor
      view.selectedBorderColor = viewModel.selectedBorderColor
      view.normalImage = imageProvider.normalAccessory()
      view.selectedImage = imageProvider.selectedAccessory()
    }

    private func setupFreeformTextView() {
      view.freeformTextView.layer.cornerRadius = SelectableView.Consts.cornerRadius
      view.freeformTextView.layer.borderWidth = SelectableView.Consts.textViewBorderWidth
      view.freeformTextView.layer.borderColor = viewModel.normalBorderColor.cgColor
      view.freeformTextView.delegate = view
    }
    
    private func setupColorsAndText() {
      view.answerContainer.backgroundColor = .clear
      view.freeformContainer.backgroundColor = .clear
      view.imageView.image = view.normalImage
      view.titleLabel.text = viewModel.title
      view.titleLabel.textColor = viewModel.textColor
    }
  }

  private struct Consts {
    static let collapsedHeight: CGFloat = 10
    static let expandedHeight: CGFloat = 64
    static let cornerRadius: CGFloat = 4
    static let textViewBorderWidth: CGFloat = 1
    static let disabledAlpha: CGFloat = 0.4
  }
  
  var isSelected = false {
    willSet(newIsSelected) {
      if isSelected == newIsSelected { return }
      newIsSelected ? selectedStateAnimation().run() : normalStateAnimation().run()
    }
  }
  
  var isDisabled = false {
    willSet(newIsDisabled) {
      if isDisabled == newIsDisabled { return }
      isSelected = false
      newIsDisabled ? disabledStateAnimation().run() : enabledStateAnimation().run()
    }
  }
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var freeformTextView: UITextView!
  @IBOutlet weak var freeformContainerHeight: NSLayoutConstraint!
  @IBOutlet weak var freeformContainer: UIView!
  @IBOutlet weak var answerContainer: UIView!
  
  private var normalImage: UIImage!
  private var selectedImage: UIImage!
  private weak var delegate: SelectableViewDelegate?
  
  private (set) var isCommentAllowed: Bool!
  
  private var normalBorderColor: UIColor = UIColor.clear
  private var selectedBorderColor: UIColor = UIColor.clear
  
  private func normalStateAnimation() -> Animatable {
    return Animation(duration: kAnimationTime) {
      self.imageView.image = self.normalImage
      self.collapseIfNeeded()
      self.superview?.layoutIfNeeded()
      self.updateAccessibilityIdentifier(isSelected: false)
    }
  }
  
  private func selectedStateAnimation() -> Animatable {
    return Animation(duration: kAnimationTime) {
      self.imageView.image = self.selectedImage
      self.expandIfNeeded()
      self.superview?.layoutIfNeeded()
      self.updateAccessibilityIdentifier(isSelected: true)
    }
  }
  
  private func enabledStateAnimation() -> Animatable {
    return Animation(duration: kAnimationTime) {
      self.alpha = 1
    }
  }
  
  private func disabledStateAnimation() -> Animatable {
    return Animation(duration: kAnimationTime) {
      self.alpha = Consts.disabledAlpha
    }
  }
  
  private func updateAccessibilityIdentifier(isSelected: Bool) {
    let title = self.titleLabel.text ?? ""
    self.accessibilityIdentifier = "\(text(forSelection: isSelected)) - \(title)"
  }
  
  private func text(forSelection isSelected: Bool) -> String {
    return isSelected ? "selected" : "unselected"
  }
  
  private func expandIfNeeded() {
    if isCommentAllowed { expand() }
  }
  
  private func expand() {
    superview?.endEditing(true)
    freeformContainerHeight.constant = SelectableView.Consts.expandedHeight
  }
  
  private func collapseIfNeeded() {
    if isCommentAllowed { collapse() }
  }
  
  private func collapse() {
    freeformTextView.resignFirstResponder()
    freeformContainerHeight.constant = SelectableView.Consts.collapsedHeight
  }
  
  @IBAction func answerPressed(_ sender: UITapGestureRecognizer) {
    if isDisabled { return }
    delegate?.viewWasSelected(self)
  }
  
  private func changeBorderColor(newColor: UIColor) {
    let animation = CABasicAnimation(keyPath: "borderColor")
    animation.fromValue = freeformTextView.layer.borderColor
    animation.toValue = newColor.cgColor
    animation.duration = kAnimationTime
    animation.repeatCount = 1
    freeformTextView.layer.add(animation, forKey: "borderColor")
    freeformTextView.layer.borderColor = newColor.cgColor
  }
  
}

extension SelectableView: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    changeBorderColor(newColor: selectedBorderColor)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    changeBorderColor(newColor: normalBorderColor)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    delegate?.viewTextChanged(self)
  }
  
}
