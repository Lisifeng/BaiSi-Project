//
//  BSReleaseItemsView.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/9.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

import Foundation

class BSReleaseItemsView: UIView {
    //MARK: - Parameters
    var popBtnArr = NSMutableArray()
    var timer = Timer()
    var index = 0
    
    //MARK: - Interface
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        if !self.isEqual(nil) {
            self.backgroundColor = BSColor.colorWithHexAlpha(0xffffff, alpha: 0.9)
            self.addSubViewsWithF(frame: frame)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(popBtns), userInfo: nil, repeats: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - addSubViews
extension BSReleaseItemsView {
    func addSubViewsWithF(frame:CGRect) {
        
        let topBtn = ItemButton.init()
        topBtn.setImage(UIImage.init(named: "ReleaseVc_topWelcome_image"), for: UIControlState.normal)
        topBtn.sizeToFit()
        topBtn.frame = CGRect.init(x: (ScreenWidth-topBtn.bounds.size.width)/2, y: 80, width: topBtn.bounds.size.width, height: topBtn.bounds.size.height)
        topBtn.tag = 0
        topBtn.transform = CGAffineTransform.init(translationX: 0, y: -ScreenHeight)
        popBtnArr.add(topBtn)
        self.addSubview(topBtn)
        
        let imageArr = ["ReleaseVc_video_image","ReleaseVc_picture_image","ReleaseVc_article_image","ReleaseVc_voice_image","ReleaseVc_great_image","ReleaseVc_link_image"]
        let titleArr = ["发视频","发图片","发段子","发声音","审帖","发链接"]
        
        let number = imageArr.count
        let cols : NSInteger = 3
        let margin : CGFloat = 15.0
        var col : NSInteger = 0
        var row : NSInteger = 0
        var x : CGFloat = 0
        var y : CGFloat = 0
        let w : CGFloat = (ScreenWidth-(CGFloat)(cols+1)*margin)/3
        let h : CGFloat = w+30
        
        for index in 1...number{
            
            col = (index-1)%cols
            row = (index-1)/cols
            x = CGFloat(col)*(margin+w)+margin
            y = CGFloat(row)*(margin+h)+margin + 120
            let itemBtn = ItemButton.init(frame: CGRect.init(x: x, y: y, width: w, height: h))
            let image = UIImage.init(named: imageArr[index-1])
            itemBtn.setUpContent(image: image!, title: titleArr[index-1] as NSString)
            itemBtn.tag = index
            itemBtn.addTarget(self, action: #selector(BSReleaseItemsView.itemBtnClicked(btn:)), for: UIControlEvents.touchUpInside)
            itemBtn.transform = CGAffineTransform.init(translationX: 0, y: -ScreenHeight)
            popBtnArr.add(itemBtn)
            self.addSubview(itemBtn)
        }
        
        
        let cancelBtn = UIButton.init(frame: CGRect.init(x: 0, y: ScreenHeight-35, width: ScreenWidth, height: 35))
        cancelBtn.backgroundColor = BSColor.colorWithHex(0xffffff)
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.setTitleColor(BSColor.colorWithHex(0x000000), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(BSReleaseItemsView.cancelBtnClicked(btn:)), for: UIControlEvents.touchUpInside)
        self.addSubview(cancelBtn)
        index = popBtnArr.count
    }
}

extension BSReleaseItemsView {
    /// 出现
    func showIn() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    /// 选项按钮点击
    func itemBtnClicked(btn:ItemButton) {
        JBLog("\(btn.tag)"+"\(String(describing: btn.titleL.text))")
    }
    
    /// 取消按钮点击
    func cancelBtnClicked(btn:UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(BSReleaseItemsView.drownBtn), userInfo: nil, repeats: true)
        JBLog("点击取消")
    }
    
    /// 出现
    func popBtns() {
        if index <= 0{
            timer.invalidate()
            index = popBtnArr.count
            return
        }
        let btn = popBtnArr[index-1]
        self.setUpPopBtn(btn: btn as! ItemButton)
        index-=1
    }
    
    func setUpPopBtn(btn:ItemButton) {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            btn.transform = CGAffineTransform.identity
        }) { (true) in
            let removeges = UITapGestureRecognizer.init(target: self, action: #selector(BSReleaseItemsView.cancelBtnClicked(btn:)))
            self.addGestureRecognizer(removeges)
        }
    }
    /// 消失
    func drownBtn() {
        if index <= 0{
            timer.invalidate()
            self.removeFromSuperview()
            return
        }
        let btn = popBtnArr[index-1]
        self.setDrownPopBtn(btn: btn as! ItemButton)
        index-=1
    }
    func setDrownPopBtn(btn:ItemButton) {
        UIView.animate(withDuration: 0.25) {
            btn.transform = CGAffineTransform(translationX: 0, y: self.bounds.size.height);
        }
    }
}

/// ------ItemButton------
class ItemButton: UIButton {
    
    var imageV = UIImageView()
    var titleL = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            self.addSubViewsWithF(frame)
        }
    }
    func addSubViewsWithF(_:CGRect)  {
        
        imageV = UIImageView.init(frame: CGRect.init(x: (frame.size.width-frame.size.height*0.6)/2, y: 0, width: frame.size.height*0.6,height: frame.size.height*0.6))
        titleL = UILabel.init(frame: CGRect.init(x: 0, y: imageV.frame.maxY, width: frame.size.width, height: frame.size.height-imageV.frame.maxY))
        titleL.textAlignment = NSTextAlignment.center
        titleL.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(imageV)
        self.addSubview(titleL)
        
    }
    
    func setUpContent(image:UIImage,title:NSString) {
        imageV.image = image
        
        titleL.text = title as String
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
