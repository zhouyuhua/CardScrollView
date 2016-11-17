//
//  ChatInputView.swift
//  CardView
//
//  Created by zhouxf on 2016/11/16.
//  Copyright © 2016年 busap. All rights reserved.
//

import UIKit

protocol ChatInputViewDelegate {
    
}

class ChatInputView: UIView {
    
    let voiceBtn = UIButton()
    let faceBtn = UIButton()
    let addBtn = UIButton()
    let textView = UITextView()
    var delegate:ChatInputView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.voiceBtn.addTarget(self, action: #selector(ChatInputView.voiceBtnAction(btn:)), for: .touchUpInside)
        self.voiceBtn.backgroundColor = UIColor.randomColor()
        self.voiceBtn.layer.cornerRadius = self.btnHeight() / 2
        self.addSubview(self.voiceBtn)
        
        self.faceBtn.addTarget(self, action: #selector(ChatInputView.faceBtnAction(btn:)), for: .touchUpInside)
        self.faceBtn.backgroundColor = UIColor.randomColor()
        self.faceBtn.layer.cornerRadius = self.btnHeight() / 2
        self.addSubview(self.faceBtn)
        
        self.addBtn.addTarget(self, action: #selector(ChatInputView.addBtnAction(btn:)), for: .touchUpInside)
        self.addBtn.backgroundColor = UIColor.randomColor()
        self.addBtn.layer.cornerRadius = self.btnHeight() / 2
        self.addSubview(self.addBtn)
        
        self.textView.backgroundColor = UIColor.purple
        self.addSubview(self.textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW = self.btnWidth()
        let btnH = self.btnHeight()
        let btnP = self.btnPadding()
        self.voiceBtn.frame = CGRect(x: btnP, y: (self.frame.size.height - btnH) /  2, width: btnW, height: btnH)
        
        let addX = self.frame.size.width - btnP - btnW
        self.addBtn.frame = CGRect(x: addX, y: self.voiceBtn.frame.origin.y, width: btnW, height: btnH)
        
        let faceX = self.addBtn.frame.origin.x - btnP - btnW
        self.faceBtn.frame = CGRect(x: faceX, y: self.voiceBtn.frame.origin.y, width: btnW, height: btnH)
        
        let textX = self.voiceBtn.frame.maxX + btnP
        let textW = self.faceBtn.frame.minX - btnP - textX
        let textH = btnH
        self.textView.frame = CGRect(x: textX, y: self.voiceBtn.frame.minY, width: textW, height: textH)
    }
    
    func btnWidth() -> CGFloat {
        return 40
    }
    
    func btnHeight() -> CGFloat {
        return self.btnWidth()
    }
    
    func btnPadding() -> CGFloat {
        return 10
    }
    
    func voiceBtnAction(btn:UIButton) {
        print("voiceBtnAction")
    }
    
    func faceBtnAction(btn:UIButton) {
        print("faceBtnAction")
    }
    
    func addBtnAction(btn:UIButton) {
        print("addBtnAction")
    }
    
}
