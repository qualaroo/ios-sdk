//
//  AnswerListView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import UIKit

class AnswerListView: UIView {
  
  class Builder {
    
    let question: Question
    let buttonHandler: SurveyButtonHandler
    let answerHandler: SurveyAnswerHandler
    let selecter: AnswerSelectionConfigurator
    let theme: Theme
    let onImage: UIImage
    let offImage: UIImage

    init(question: Question,
         buttonHandler: SurveyButtonHandler,
         answerHandler: SurveyAnswerHandler,
         selecter: AnswerSelectionConfigurator,
         theme: Theme,
         onImage: UIImage,
         offImage: UIImage) {
      self.question = question
      self.buttonHandler = buttonHandler
      self.answerHandler = answerHandler
      self.selecter = selecter
      self.theme = theme
      self.onImage = onImage
      self.offImage = offImage
    }
    
    func build() -> AnswerListView {
      let view = answerListView()
      let viewModels = selectableViewModels(colors: theme.colors, answers: question.answerList)
      let imageProvider = ImageProvider(normalColor: theme.colors.uiNormal,
                                        normalImage: offImage,
                                        selectedColor: theme.colors.uiSelected,
                                        selectedImage: onImage)
      let interactor = answerListInteractor(buttonHandler: buttonHandler,
                                            answerHandler: answerHandler,
                                            question: question)
      let presenter = AnswerListPresenter(view: view, interactor: interactor, selecter: selecter)
      view.setupView(backgroundColor: theme.colors.background,
                     selectableViewModels: viewModels,
                     imageProvider: imageProvider,
                     selectionHandler: presenter)
      return view
    }
    
    private func answerListView() -> AnswerListView {
      guard
        let nib = Bundle.qualaroo()?.loadNibNamed("AnswerListView", owner: nil, options: nil),
        let view = nib.first as? AnswerListView else { return AnswerListView() }
      return view
    }
    
    private func selectableViewModels(colors: ColorTheme,
                                      answers: [Answer]) -> [SelectableView.ViewModel] {
      return answers.map { SelectableView.ViewModel(title: $0.title,
                                                    textColor: colors.text,
                                                    normalBorderColor: colors.uiNormal,
                                                    selectedBorderColor: colors.uiSelected,
                                                    expandabable: $0.isFreeformCommentAllowed) }
    }
    
    private func answerListInteractor(buttonHandler: SurveyButtonHandler,
                                      answerHandler: SurveyAnswerHandler,
                                      question: Question) -> AnswerListInteractor {
      let responseBuilder = AnswerListResponseBuilder(question: question)
      let validator = AnswerListValidator(question: question)
      return AnswerListInteractor(responseBuilder: responseBuilder,
                                  validator: validator,
                                  buttonHandler: buttonHandler,
                                  answerHandler: answerHandler,
                                  question: question)
    }
  }
  
  private struct Const {
    static let cellMargin: CGFloat = 20
    static let cellSpacing: CGFloat = 8
    static let cellEstimatedHeight: CGFloat = 48
  }
  
  private var presenter: SelectableViewDelegate?

  @IBOutlet weak var buttonsContainerHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonsScrollContainer: UIScrollView!
  
  var selectableViews = [SelectableView]()

  func setupView(backgroundColor: UIColor,
                 selectableViewModels: [SelectableView.ViewModel],
                 imageProvider: SelectionImageProvider,
                 selectionHandler: SelectableViewDelegate) {
    self.backgroundColor = backgroundColor
    translatesAutoresizingMaskIntoConstraints = false
    selectableViews = selectableViewModels.map {
      SelectableView.Builder(imageProvider: imageProvider,
                             delegate: selectionHandler,
                             viewModel: $0).build()
    }
    self.presenter = selectionHandler
    setupWithViews(selectableViews)
  }
  
  func resize() {
    Animation(duration: kAnimationTime) {
      self.buttonsContainerHeightConstraint.constant = self.buttonsScrollContainer.contentSize.height
      self.superview?.superview?.superview?.layoutIfNeeded()
    }.run()
  }
  
  private func setupWithViews(_ views: [SelectableView]) {
    NSLayoutConstraint.fillScrollView(buttonsScrollContainer,
                                      with: views,
                                      margin: Const.cellMargin,
                                      spacing: Const.cellSpacing)
    let prepareInitialState = Animation(duration: kAnimationTime/3) {
      let cellsCount = CGFloat(views.count)
      self.buttonsContainerHeightConstraint.constant = cellsCount * Const.cellEstimatedHeight
      }
    let resize = Animation(duration: kAnimationTime * 2/3) {
      self.resize()
    }
    prepareInitialState.then(resize).run()
  }    
}
