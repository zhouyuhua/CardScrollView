//
//  CardScrollView.swift
//  CardView
//
//  Created by zhouxf on 2016/11/11.
//  Copyright © 2016年 busap. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

let π = 3.14159265358979323846264338327950288

protocol CardScrollViewDataSource {
    func numberOfCards() -> Int
    func cardScrollView(cardScrollView:CardScrollView, cardAt index:Int) -> UIView
}

@objc protocol CardScrollViewDelegate {
    @objc optional func cardScrollView(cardScrollView:CardScrollView, didSelectedCardAt index:Int)
    @objc optional func cardScrollView(cardScrollView:CardScrollView, didScrollToCardAt index:Int)
}

class CardScrollView: UIView, UIScrollViewDelegate {
    
    // MARK: - property
    // MARK: public property
    /// 卡片的大小
    var cardSize = CGSize(width: 0, height: 0)
    /// 卡片之间的间距
    var cardPadding:CGFloat = 0
    /// 卡片移动时的最大弧度
    var cardAngle:CGFloat = (CGFloat(π) / 180) * 5
    /// 当前显示的卡片索引
    var currenIndex:Int = 0
    
    /// 数据源
    var dataSource:CardScrollViewDataSource?
    /// 代理
    var delegate:CardScrollViewDelegate?
    
    // MARK: private property
    private let scrollView = UIScrollView()
    private var cardViewArray:[UIView] = [UIView]()
    
    private var cardCount:Int = 0
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    // MARK: public func
    /// 重新加载
    func reloadData() {
        self.prapareToReload()
        
        self.loadData()
    }
    
    // MARK: private func
    private func createSubviews() {
        self.scrollView.isPagingEnabled = true
        self.scrollView.clipsToBounds = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = UIColor.black
        self.addSubview(self.scrollView)
    }
    
    /// 预加载
    private func prapareToReload() {
        if __CGSizeEqualToSize(cardSize, CGSize(width: 0, height: 0)) {
            self.cardSize = self.frame.size
        }
        
        let x = (self.frame.size.width - self.cardSize.width - self.cardPadding) / 2
        let y = (self.frame.size.height - self.cardSize.height) / 2
        let w = self.cardSize.width + self.cardPadding
        let h = self.cardSize.height
        self.scrollView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        self.cardCount = self.dataSource!.numberOfCards()
        
        self.scrollView.contentSize = CGSize(width: (self.cardSize.width + self.cardPadding) * CGFloat(self.cardCount), height: self.scrollView.frame.size.height)
        
        for card in self.cardViewArray {
            card.removeFromSuperview()
        }
        self.cardViewArray.removeAll()
        
        // 加载view，重复利用时需要修改此段代码
        for i in 0..<self.cardCount {
            let view = self.dataSource!.cardScrollView(cardScrollView: self, cardAt: i)
            self.scrollView.addSubview(view)
            self.cardViewArray.append(view)
            view.tag = i
            view.frame = CGRect(x: self.cardPadding / 2 + CGFloat(i) * (self.cardSize.width + self.cardPadding), y: (self.scrollView.frame.size.height - self.cardSize.height) / 2, width: self.cardSize.width, height: self.cardSize.height)
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(CardScrollView.cardOnClick(tapGR:)))
            view.addGestureRecognizer(tapGR)
        }
    }
    
    /// 卡片点击操作
    ///
    /// - Parameter tapGR: 单击手势
    @objc private func cardOnClick(tapGR:UITapGestureRecognizer) {
        guard tapGR.state == .ended else {
            return
        }
        
        if let view = tapGR.view {
            self.delegate?.cardScrollView?(cardScrollView: self, didSelectedCardAt: view.tag)
        }
    }
    
    /// 加载数据，重复利用时需要修改此段代码
    private func loadData() {
        let curScrollLeft = self.scrollView.contentOffset.x
        let curScrollCenter = self.scrollView.frame.size.width / 2 + curScrollLeft
        
        for view in self.cardViewArray {
            let mw = view.center.x - curScrollCenter
            if mw > self.scrollView.frame.size.width - 1 || mw < -self.scrollView.frame.size.width + 1 {
                view.transform = CGAffineTransform(rotationAngle: 0)
            } else {
                /// 计算弧度
                let angle = 2 * self.cardAngle / (self.scrollView.frame.size.width) * mw
                let transform = CGAffineTransform(rotationAngle: angle)
                view.transform = transform
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.reloadData()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return self.scrollView
        }
        
        return view
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.loadData()
        
        let idx = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5)
        if self.currenIndex != idx {
            self.currenIndex = idx
            self.delegate?.cardScrollView?(cardScrollView: self, didScrollToCardAt: idx)
        }
    }

}
