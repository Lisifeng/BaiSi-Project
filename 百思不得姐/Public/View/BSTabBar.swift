//
//  BSTabBar.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/13.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

protocol  BSTabBarDelegate {
    func TabBarItemClicked(_ Tag:NSInteger)
}
class BSTabBar: UIView {
  // MARK: - Parameters
    var delegate : BSTabBarDelegate?
    var kNum : CGFloat = 5
    var buttonItem1 = BSTabBarButtonItem.init()
    var buttonItem2 = BSTabBarButtonItem.init()
    var buttonItem3 = BSTabBarButtonItem.init()
    var buttonItem4 = BSTabBarButtonItem.init()
    var buttonItem5 = BSTabBarButtonItem.init()
 // MARK: - Interface
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            self.backgroundColor = BSColor.colorWithHex(0xf5f5f5)
            self.addSubviews()
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   // MARK: - 添加子控件
     func addSubviews() {
   
        let kItemWidth = UIScreen.main.bounds.size.width/kNum
        let kItemHeight = self.bounds.size.height
        
        buttonItem1 = BSTabBarButtonItem.init(frame: CGRect.init(x: 0, y: 0, width: kItemWidth, height: kItemHeight))
        buttonItem1.tag = 1
        buttonItem1.addTarget(self, action: #selector(BSTabBar.setSubViewsWithButtonItem(_:)), for: UIControlEvents.touchUpInside)
        
        buttonItem2 = BSTabBarButtonItem.init(frame: CGRect.init(x: kItemWidth, y: 0, width: kItemWidth, height: kItemHeight))
        buttonItem2.tag = 2
        buttonItem2.addTarget(self, action: #selector(BSTabBar.setSubViewsWithButtonItem(_:)), for: UIControlEvents.touchUpInside)
        
        buttonItem3 = BSTabBarButtonItem.init(frame: CGRect.init(x: 2*kItemWidth, y: 0, width: kItemWidth, height: kItemHeight))
        buttonItem3.tag = 3
        buttonItem3.addTarget(self, action: #selector(BSTabBar.setSubViewsWithButtonItem(_:)), for: UIControlEvents.touchUpInside)
        
        buttonItem4 = BSTabBarButtonItem.init(frame: CGRect.init(x: 3*kItemWidth, y: 0, width: kItemWidth, height: kItemHeight))
        buttonItem4.tag = 4
        buttonItem4.addTarget(self, action: #selector(BSTabBar.setSubViewsWithButtonItem(_:)), for: UIControlEvents.touchUpInside)
        
        buttonItem5 = BSTabBarButtonItem.init(frame: CGRect.init(x: 4*kItemWidth, y: 0, width: kItemWidth, height: kItemHeight))
        buttonItem5.tag = 5
        buttonItem5.addTarget(self, action: #selector(BSTabBar.setSubViewsWithButtonItem(_:)), for: UIControlEvents.touchUpInside)
        
        buttonItem1.setImageAndContent(UIImage.init(named: "tabBar_timeLineVc_normal_icon")!, content: "精华")
        buttonItem2.setImageAndContent(UIImage.init(named: "tabBar_singhoodVc_normal_icon")!, content: "最新")
        buttonItem3.setImageAndContent(UIImage.init(named: "tabBar_makeFriendVc_4_5s_normal_icon")!, content: "")
        buttonItem4.setImageAndContent(UIImage.init(named: "tabBar_messageVc_normal_icon")!, content: "关注")
        buttonItem5.setImageAndContent(UIImage.init(named: "tabBar_aboutMeVc_normal_icon")!, content: "我")
        
        self.addSubview(buttonItem1)
        self.addSubview(buttonItem2)
        self.addSubview(buttonItem3)
        self.addSubview(buttonItem4)
        self.addSubview(buttonItem5)
        
        self.setSubViewsWithButtonItem(buttonItem1)
        
        let topLineView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 1))
        topLineView.backgroundColor = BSColor.colorWithHex(0xD3D3D3)
        self.addSubview(topLineView)
        
    }
    
    func setSubViewsWithButtonItem(_ buttonItem:BSTabBarButtonItem)  {
        if buttonItem.tag == 3 {
            delegate?.TabBarItemClicked(buttonItem.tag)
            return
        }
        buttonItem1.setImageAndContent(UIImage.init(named: "tabBar_timeLineVc_normal_icon")!, content: "精华")
        buttonItem2.setImageAndContent(UIImage.init(named: "tabBar_singhoodVc_normal_icon")!, content: "最新")
        buttonItem3.setImageAndContent(UIImage.init(named: "tabBar_makeFriendVc_4_5s_normal_icon")!, content: "")
        buttonItem4.setImageAndContent(UIImage.init(named: "tabBar_messageVc_normal_icon")!, content: "关注")
        buttonItem5.setImageAndContent(UIImage.init(named: "tabBar_aboutMeVc_normal_icon")!, content: "我")
        
        switch buttonItem.tag {
        case 1:
            buttonItem1.setSelectedImage(UIImage.init(named: "tabBar_timeLineVc_selected_icon")!)
            break
        case 2:
            buttonItem2.setSelectedImage(UIImage.init(named: "tabBar_singhoodVc_selected_icon")!)
            break
        case 3:
            buttonItem3.setSelectedImage(UIImage.init(named: "tabBar_makeFriendVc_normal_icon")!)
            break
        case 4:
            buttonItem4.setSelectedImage(UIImage.init(named: "tabBar_messageVc_selected_icon")!)
            break
        case 5:
            buttonItem5.setSelectedImage(UIImage.init(named: "tabBar_aboutMeVc_selected_icon")!)
            break
        default: break
            
        }

        delegate?.TabBarItemClicked(buttonItem.tag)
    }
    
    
}
class BSTabBarButtonItem: UIButton{
    // MARK: - Parameters
    var kPercent : CGFloat = 0.65
    var imageV = UIImageView.init()
    var labelT = UILabel.init()
    
    // MARK: - Interface
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            self.setSubviewsWithFrame(frame)
            self.addSubviews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addSubviews() {
        self.addSubview(imageV)
        self.addSubview(labelT)
    }
    func setSubviewsWithFrame(_ frame:CGRect) {
        imageV = UIImageView.init(frame: CGRect.init(x: (frame.width-20)/2, y: 5, width: 20, height: 20))
        
        labelT = UILabel.init(frame: CGRect.init(x: 0, y: imageV.frame.maxY+5, width: self.bounds.size.width, height: 20))
        labelT.font = UIFont.systemFont(ofSize: 12, weight: 1.2)
        labelT.textAlignment = NSTextAlignment.center
        
    }
    // MARK: - Method
    func setImageAndContent(_ image:UIImage,
                            content:NSString) {
        self.imageV.image = image
        self.labelT.text = content as String
        if content.isEqual(to: "") {
//            self.imageV.frame = CGRect.init(x: (self.bounds.size.width-40)/2, y: (self.bounds.size.height-35)/2, width: 40, height: 35)
            self.imageV.sizeToFit()
            self.imageV.frame = CGRect.init(x: (self.bounds.size.width-self.imageV.bounds.size.width)/2, y: (self.bounds.size.height-self.imageV.bounds.size.height)/2, width: self.imageV.bounds.size.width, height: self.imageV.bounds.size.height)
        }
        self.labelT.textColor = BSColor.themeBottomBarTitleNormalColor()
    }
    func setSelectedImage(_ selectedImage:UIImage) {
        self.imageV.image = selectedImage
        self.labelT.textColor = BSColor.themeColor()
    }
}
