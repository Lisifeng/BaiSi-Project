//
//  BSTopListView.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/18.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
//MARK: - BSTopListViewTopicDelegate
protocol BSTopListViewTopicDelegate {
    func BSTopListViewTopicBtnClicked(_ sender:UIButton)
}

class BSTopListView: UIView,UIScrollViewDelegate {

    //MARK: - 参数
    var delegate : BSTopListViewTopicDelegate?
    var mainScrollView = UIScrollView()
    var bottomLineView = UIView()
    var leftOpaqueView = UIView()
    var rightOpaqueView = UIView()
    var topicNumber : CGFloat = 0
    var preBtn = UIButton()
    var selectBtn = UIButton()
    var topicButtonArray = NSMutableArray()
    
    
    //MARK: - Interface
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            self.backgroundColor = BSColor.themeColor()
            self.addSubViewsWithF(frame)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViewsWithF(_ F:CGRect) {
        mainScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: F.size.width, height: F.size.height))
        mainScrollView.delegate = self
        mainScrollView.isScrollEnabled = true
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        bottomLineView = UIView.init(frame: CGRect.init(x: 0, y: F.size.height - 2, width: 20, height: 1))
        bottomLineView.backgroundColor = BSColor.themeCharacterColor()
        
        leftOpaqueView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 5, height: F.size.height))
        leftOpaqueView.backgroundColor = BSColor.colorWithHexAlpha(0xFF1860,alpha: 0.7)
        
        rightOpaqueView = UIView.init(frame: CGRect.init(x: F.size.width-5, y: 0, width: 5, height: F.size.height))
        rightOpaqueView.backgroundColor = BSColor.colorWithHexAlpha(0xFF1860,alpha: 0.3)
        
        
        self.addSubview(mainScrollView)
        self.addSubview(leftOpaqueView)
        self.addSubview(rightOpaqueView)
    }
    
    //MARK: - 顶部标签数组
    func topicsArray(_ topics:NSArray) {
        
        _ = Any.self
        for content in topics {
            let contentBtn = UIButton.init(type: UIButtonType.custom)
            contentBtn.setTitle(content as? String, for: UIControlState.normal)
            contentBtn.setTitleColor(BSColor.themeCharacterColor(), for: UIControlState.normal)
            contentBtn.backgroundColor = BSColor.themeColor()
            contentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            contentBtn.tag = Int(topicNumber)
            contentBtn.addTarget(self, action: #selector(BSTopListView.topicButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            contentBtn.sizeToFit()
            contentBtn.frame = CGRect.init(x: preBtn.frame.maxX, y: 0, width: contentBtn.bounds.size.width + 20, height: contentBtn.bounds.size.height)
            contentBtn.center.y = self.mainScrollView.center.y
            topicButtonArray.add(contentBtn)
            self.mainScrollView.addSubview(contentBtn)
            self.mainScrollView.contentSize = CGSize.init(width: contentBtn.frame.maxX, height: self.mainScrollView.bounds.size.height)
            preBtn = contentBtn
            
            if topicNumber == 0 {
                contentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                selectBtn = contentBtn
                bottomLineView.frame =  CGRect.init(x: 0, y: bottomLineView.frame.origin.y , width: contentBtn.bounds.size.width , height: 1)
            }
            
            topicNumber += 1
        }
        
        self.mainScrollView.addSubview(bottomLineView)
    }
    
    //MARK: - 顶部标签按钮吧点击方法
    func topicButtonClicked(_ sender:UIButton) {
        self.topicClickedWithTAG(sender.tag)
        delegate?.BSTopListViewTopicBtnClicked(sender)
    }
    
    func topicClickedWithTAG(_ tag:NSInteger) {
        if tag < 0 || tag >= topicButtonArray.count {
            return
        }
        let sender = topicButtonArray[tag] as! UIButton
        
        UIView.animate(withDuration: 0.35) {
            self.selectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            self.selectBtn = sender
            self.bottomLineView.frame = CGRect.init(x: sender.frame.minX, y: self.bottomLineView.frame.origin.y, width: sender.bounds.size.width, height: self.bottomLineView.bounds.size.height)
        }
        
        let scrollLength : CGFloat = self.mainScrollView.bounds.size.width
        let scrollContentLength : CGFloat =  self.mainScrollView.contentSize.width
        let senderCenter = sender.frame.minX + (sender.bounds.size.width) / 2
        
        print("\(senderCenter/(scrollLength/2))"+"💖💖💖💖")
        if (senderCenter >= (scrollLength/2.0)) && (senderCenter <= (scrollContentLength - scrollLength/2.0)) {
            UIView.animate(withDuration: 0.35) {
                self.mainScrollView.contentOffset = CGPoint.init(x: senderCenter-(scrollLength/2), y: 0)
            }
        }else {
            
            UIView.animate(withDuration: 0.35) {
                if senderCenter < (scrollLength / 2) {
                    self.mainScrollView.contentOffset = CGPoint.init(x: 0, y: 0)
                }else{
                    self.mainScrollView.contentOffset = CGPoint.init(x: scrollContentLength-self.bounds.size.width, y: 0)
                }
            }
        }
    }
    
    
}
