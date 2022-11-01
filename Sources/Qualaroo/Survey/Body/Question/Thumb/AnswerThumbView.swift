//
//  AnswerThumbView.swift
//  Qualaroo
//
//  Created by Ajay Mandrawal on 09/06/22.
//  Copyright © 2022 Mihály Papp. All rights reserved.
//


import Foundation
import UIKit

class AnswerThumbView: UIView {
    
        @IBOutlet weak var thumUpContainer: UIView!
        @IBOutlet weak var thumbDownContainer: UIView!
        @IBOutlet weak var thumbUp: UIImageView!
        @IBOutlet weak var thumbDown: UIImageView!
    
    private var interactor: AnswerThumbInteractor!
    func setupView(backgroundColor: UIColor, textColor: UIColor,  answers: [String?],interactor:AnswerThumbInteractor){
        self.backgroundColor = backgroundColor
          self.interactor = interactor
        
          thumbDownContainer.layer.cornerRadius = 3
          thumbDownContainer.layer.borderWidth = 2
          thumbDownContainer.layer.borderColor = textColor.cgColor

          thumUpContainer.layer.cornerRadius = 3
          thumUpContainer.layer.borderWidth = 2
          thumUpContainer.layer.borderColor = textColor.cgColor

          loadEmoji(url:  URL(string: answers[0]!)!, imageView: thumbUp)
          loadEmoji(url:  URL(string: answers[1]!)!, imageView: thumbDown)


          let thumbUpTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.thumbUpTab(sender:)));

          thumbUp.isUserInteractionEnabled = true

          thumbUp.addGestureRecognizer(thumbUpTapGestureRecognizer)

          let thumbDownTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.thumbDownTab(sender:)));

          thumbDown.isUserInteractionEnabled = true

          thumbDown.addGestureRecognizer(thumbDownTapGestureRecognizer)


    }
    
    @objc  func thumbUpTab(sender: UITapGestureRecognizer){
        interactor.selectThumbUp()
    }
    
    @objc  func thumbDownTab(sender: UITapGestureRecognizer){
        interactor.selectThumbDown()
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

//import Foundation
//class AnswerThumbView: UIView {
//
    
    
//    @IBOutlet weak var thumUpContainer: UIView!
//    @IBOutlet weak var thumbDownContainer: UIView!
//    @IBOutlet weak var thumbUp: UIImageView!
//    @IBOutlet weak var thumbDown: UIImageView!

//    private var interactor: AnswerThumbInteractor!
//    func setupView(backgroundColor: UIColor, textColor: UIColor,  answers: [String?],interactor:AnswerThumbInteractor) {
//      self.backgroundColor = backgroundColor
//        self.interactor = interactor
//
//        thumbDownContainer.layer.cornerRadius = 3
//        thumbDownContainer.layer.borderWidth = 2
//        thumbDownContainer.layer.borderColor = textColor.cgColor
//
//        thumUpContainer.layer.cornerRadius = 3
//        thumUpContainer.layer.borderWidth = 2
//        thumUpContainer.layer.borderColor = textColor.cgColor
//
//        loadEmoji(url:  URL(string: answers[0]!)!, imageView: thumbUp)
//        loadEmoji(url:  URL(string: answers[1]!)!, imageView: thumbDown)
//
//
//        let thumbUpTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.thumbUpTab(sender:)));
//
//        thumbUp.isUserInteractionEnabled = true
//
//        thumbUp.addGestureRecognizer(thumbUpTapGestureRecognizer)
//
//        let thumbDownTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.thumbDownTab(sender:)));
//
//        thumbDown.isUserInteractionEnabled = true
//
//        thumbDown.addGestureRecognizer(thumbDownTapGestureRecognizer)
//
//    }
    
//    @objc  func thumbUpTab(sender: UITapGestureRecognizer){
//        interactor.selectThumbUp()
//    }
//
//    @objc  func thumbDownTab(sender: UITapGestureRecognizer){
//        interactor.selectThumbDown()
//    }
//
//
//    func loadEmoji(url: URL,imageView: UIImageView) {
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: url) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            imageView.image = image
//                        }
//                    }
//                }
//            }
//        }
//}
