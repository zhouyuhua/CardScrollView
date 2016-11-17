//
//  ViewController.swift
//  CardView
//
//  Created by zhouxf on 2016/11/11.
//  Copyright © 2016年 busap. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CardScrollViewDataSource, CardScrollViewDelegate {

    let civ = ChatInputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let csv = CardScrollView()
        csv.cardPadding = 20
        csv.dataSource = self
        csv.delegate = self
        csv.cardSize = CGSize(width: 300, height: 360)
        csv.frame = CGRect(x: 0, y: 80, width: self.view.frame.size.width, height: 400)
        self.view.addSubview(csv)
        
//        let civ = ChatInputView()
        civ.backgroundColor = UIColor.randomColor()
        civ.frame = CGRect(x: 0, y: self.view.frame.size.height - 60, width: self.view.frame.size.width, height: 60)
        self.view.addSubview(civ)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGRAction(tapGR:)))
        self.view.addGestureRecognizer(tapGR)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillChangeFrame(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    func tapGRAction(tapGR:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func keyboardWillChangeFrame(notification:NSNotification) {
        print("keyboardWillChangeFrame notification = \(notification)")
        
        let animationCurve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        var tf = self.view.frame
        if endFrame.origin.y < self.view.frame.height {
            tf.origin.y = -(endFrame.height)
        } else {
            tf.origin.y = 0
        }
        
        UIView.animate(withDuration: animationDuration.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: animationCurve.uintValue), animations: {
        self.view.frame = tf
        }, completion: {(finished) in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CardScrollViewDataSource, CardScrollViewDelegate
    func numberOfCards() -> Int {
        return 10
    }

    func cardScrollView(cardScrollView: CardScrollView, cardAt index: Int) -> UIView {
        let card = UIView()
        
        card.backgroundColor = UIColor.randomColor()
        
        return card
    }
    
    func cardScrollView(cardScrollView: CardScrollView, didSelectedCardAt index: Int) {
        print("cardScrollView didSelectedCardAtIndex:\(index)")
    }
    
    func cardScrollView(cardScrollView: CardScrollView, didScrollToCardAt index: Int) {
        print("cardScrollView didScrollToCardAt:\(index)")
    }

}

