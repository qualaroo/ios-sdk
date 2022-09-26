//
//  AnswerEmojiView.swift
//  Qualaroo
//
//  Created by user181179 on 10/6/21.
//  Copyright © 2021 Mihály Papp. All rights reserved.
//

inport UIKit
class AnswerEmojiView: UIView {
    
//    @IBOutlet weak var stackContainer: UIStackView!
    
    @IBOutlet weak var firstEmojiContainer: UIView!
    @IBOutlet weak var secondEmojiContainer: UIView!
    @IBOutlet weak var thirdEmojiContainer: UIView!
    @IBOutlet weak var fourthEmojiContainer: UIView!
    @IBOutlet weak var fifthEmojiContainer: UIView!
    
    @IBOutlet weak var firstEMoji: UIImageView!
    @IBOutlet weak var secondEmoji: UIImageView!
    
    @IBOutlet weak var thirdEmoji: UIImageView!
    @IBOutlet weak var fourthEmoji: UIImageView!
    
    @IBOutlet weak var fifthEmoji: UIImageView!
    

    private var interactor: AnswerEmojiInteractor!
    func setupView(backgroundColor: UIColor, textColor: UIColor,  answers: [String?],interactor: AnswerEmojiInteractor) {
      self.backgroundColor = backgroundColor
        self.interactor = interactor
      
        firstEmojiContainer.layer.cornerRadius = 3
        firstEmojiContainer.layer.borderWidth = 2
        firstEmojiContainer.layer.borderColor = textColor.cgColor

        secondEmojiContainer.layer.cornerRadius = 3
        secondEmojiContainer.layer.borderWidth = 2
        secondEmojiContainer.layer.borderColor = textColor.cgColor

        thirdEmojiContainer.layer.cornerRadius = 3
        thirdEmojiContainer.layer.borderWidth = 2
        thirdEmojiContainer.layer.borderColor = textColor.cgColor

        fourthEmojiContainer.layer.cornerRadius = 3
        fourthEmojiContainer.layer.borderWidth = 2
        fourthEmojiContainer.layer.borderColor = textColor.cgColor

        fifthEmojiContainer.layer.cornerRadius = 3
        fifthEmojiContainer.layer.borderWidth = 2
        fifthEmojiContainer.layer.borderColor = textColor.cgColor


        loadEmoji(url:  URL(string: answers[0]!)!, imageView: firstEMoji)
        loadEmoji(url:  URL(string: answers[1]!)!, imageView: secondEmoji)
        loadEmoji(url:  URL(string: answers[2]!)!, imageView: thirdEmoji)
        loadEmoji(url:  URL(string: answers[3]!)!, imageView: fourthEmoji)
        loadEmoji(url:  URL(string: answers[4]!)!, imageView: fifthEmoji)

        let firstEmojiTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.firstEmojiTab(sender:)));        firstEMoji.isUserInteractionEnabled = true
            firstEMoji.addGestureRecognizer(firstEmojiTapGestureRecognizer)

        let secondEmojiTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.secondEmojiTab(sender:)));        secondEmoji.isUserInteractionEnabled = true
            secondEmoji.addGestureRecognizer(secondEmojiTapGestureRecognizer)

        let thirdEmojiTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.thirdEmojiTab(sender:)));        thirdEmoji.isUserInteractionEnabled = true
            thirdEmoji.addGestureRecognizer(thirdEmojiTapGestureRecognizer)

        let fourhtEmojiTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.fourhtEmojiTab(sender:)));        fourthEmoji.isUserInteractionEnabled = true
            fourthEmoji.addGestureRecognizer(fourhtEmojiTapGestureRecognizer)

        let fifthEmojiTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.fifthEmojiTab(sender:)));        fifthEmoji.isUserInteractionEnabled = true
            fifthEmoji.addGestureRecognizer(fifthEmojiTapGestureRecognizer)
    }
    
    @objc  func firstEmojiTab(sender: UITapGestureRecognizer){
        interactor.selectFirstEmoji()
    }

    @objc  func secondEmojiTab(sender: UITapGestureRecognizer){
        interactor.selectSecondEmoji()
    }

    @objc  func thirdEmojiTab(sender: UITapGestureRecognizer){
        interactor.selectThirdEmoji()
    }

    @objc  func fourhtEmojiTab(sender: UITapGestureRecognizer){
        interactor.selectFourthEmoji()
    }

    @objc  func fifthEmojiTab(sender: UITapGestureRecognizer){
        interactor.selectFifthEmoji()
    }

    
    func loadEmoji(url: URL,imageView: UIImageView) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }
            }
        }
}
