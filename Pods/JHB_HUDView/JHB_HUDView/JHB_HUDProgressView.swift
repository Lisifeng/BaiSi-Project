/******************** JHB_HUDProgressView.swift *****************/
/*******  (JHB)  ************************************************/
/*******  Created by Leon_pan on 16/6/12. ***********************/
/*******  Copyright © 2016年 CoderBala. All rights reserved.*****/
/******************** JHB_HUDProgressView.swift *****************/

import UIKit

class JHB_HUDProgressView: UIView {
    // MARK: - Params
    /*指示视图*//*IndicatorView*/
    var actView         = UIActivityIndicatorView()
    /*备用指示视图*//*SpareIndicatorView*/
    var spareActView    = UIActivityIndicatorView()
    /*信息标签*//*MessageLabel*/
    var msgLabel        = UILabel()
    /*备用信息标签*//*SpareMessageLabel*/
    var spareMsgLabel   = UILabel()
    /*信息标签长度*//*TheLengthOfMessageLabel*/
    var msgLabelWidth   = CGFloat()
    /*信息标签高度*//*TheHeightOfMessageLabel*/
    var msgLabelHeight  = CGFloat()
    /*两边的间隔*//*TheMarginOfLeftAndRight*/
    var kMargin : CGFloat = 10
    /*两边的间隔*//*TheMarginOfLeftAndRight*/
    var kContent = NSString.init()
  
    // MARK: - Interface
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSubViews()
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDProgressView.resetSubViewsForJHB_HUD_haveNoMsg), name: NSNotification.Name(rawValue: "JHB_HUD_haveNoMsg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDProgressView.resetSubViewsForJHB_HUD_haveNoMsgWithScale(_:)), name: NSNotification.Name(rawValue: "JHB_HUD_haveNoMsgWithScale"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDProgressView.resetSubViewsForJHB_HUD_haveMsg), name: NSNotification.Name(rawValue: "JHB_HUD_haveMsg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDProgressView.resetSubViewsForJHB_HUD_haveMsgWithScale(_:)), name: NSNotification.Name(rawValue: "JHB_HUD_haveMsg_WithScale"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDProgressView.resetSubViewsForJHB_HUD_onlyAMsgShow), name: NSNotification.Name(rawValue: "JHB_HUD_onlyAMsgShow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDProgressView.resetSubViewsForJHB_HUD_onlyAMsgShowWithScale(_:)), name: NSNotification.Name(rawValue: "JHB_HUD_onlyAMsgShowWithScale"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDProgressView.resetSubViewsForJHB_HUD_onlyAMsgMultipleShow), name: NSNotification.Name(rawValue: "JHB_HUD_onlyAMsgMultipleShow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDProgressView.resetSubViewsForJHB_HUD_onlyAMsgMultipleShowWithScale(_:)), name: NSNotification.Name(rawValue: "JHB_HUD_onlyAMsgMultipleShowWithScale"), object: nil)
        
        
        self.addSubview(self.actView)
        self.addSubview(self.spareActView)
        self.addSubview(self.spareMsgLabel)
        self.addSubview(self.msgLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews(){
        
        self.actView = UIActivityIndicatorView.init()
        self.actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.actView.hidesWhenStopped = true
        self.actView.startAnimating()
        
        self.spareActView = UIActivityIndicatorView.init()
        self.spareActView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.spareActView.hidesWhenStopped = true
        self.spareActView.stopAnimating()
        
        self.spareMsgLabel = UILabel.init()
        self.spareMsgLabel.textColor = UIColor.white
        self.spareMsgLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.spareMsgLabel.textAlignment = NSTextAlignment.center
        self.spareMsgLabel.isHidden = true
        self.spareMsgLabel.sizeToFit()
        
        self.msgLabel = UILabel.init()
        self.msgLabel.textColor = UIColor.white
        self.msgLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.msgLabel.textAlignment = NSTextAlignment.center
        self.msgLabel.sizeToFit()
    }
    
    func resetSubViews() {

        self.actView.frame = CGRect(x: self.bounds.size.width/2-25 ,y: self.bounds.midY-35 ,width: 50 ,height: 50 )
        self.msgLabel.frame = CGRect(x: (self.bounds.size.width - (msgLabelWidth - 2 * kMargin))/2, y: self.bounds.midY+10, width: msgLabelWidth - 2 * kMargin, height: 18)
        self.spareActView.frame = CGRect(x: (self.bounds.size.width - 50) / 2, y: (self.bounds.size.height - 50) / 2, width: 50, height: 50)
        self.spareMsgLabel.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.resetSubViews()
    }
    
    // MARK: - NotificationCenter
    func resetSubViewsForJHB_HUD_haveNoMsg() {
        self.actView.stopAnimating()
        self.spareActView.startAnimating()
    }
    func resetSubViewsForJHB_HUD_haveNoMsgWithScale(_ noti:Notification) {
        let obValue = noti.object as! CGFloat
        self.actView.stopAnimating()
        self.spareActView.startAnimating()
        self.spareActView.transform = self.actView.transform.scaledBy(x: 1/obValue, y: 1/obValue)
    }
    func resetSubViewsForJHB_HUD_haveMsg() {
        self.msgLabel.frame = CGRect(x: 0, y: self.actView.bounds.maxY, width: msgLabelWidth + 2 * kMargin, height: 18)
    }
    func resetSubViewsForJHB_HUD_haveMsgWithScale(_ noti:Notification){
        let obValue = noti.object as! CGFloat
        self.msgLabel.frame = CGRect(x: (self.bounds.size.width - msgLabelWidth)/2,  y: self.actView.bounds.maxY + 10, width: msgLabelWidth - 2 * kMargin, height: 18)
        self.actView.transform = self.actView.transform.scaledBy(x: 1/obValue, y: 1/obValue)
        self.msgLabel.transform = self.msgLabel.transform.scaledBy(x: 1/obValue, y: 1/obValue)
        
    }
    func resetSubViewsForJHB_HUD_onlyAMsgShow() {
        self.spareMsgLabel.isHidden = false
        self.msgLabel.isHidden = true
        self.spareMsgLabel.numberOfLines = 1
        self.spareMsgLabel.text = self.kContent as String
        self.spareMsgLabel.frame = CGRect(x: 0, y: 0, width: msgLabelWidth + 2 * kMargin, height: self.msgLabelHeight + 20)
        self.spareMsgLabel.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    func resetSubViewsForJHB_HUD_onlyAMsgShowWithScale(_ noti:Notification) {
        let obValue = noti.object as! CGFloat
        self.spareMsgLabel.isHidden = false
        self.msgLabel.isHidden = true
        self.spareMsgLabel.numberOfLines = 1
        self.spareMsgLabel.text = self.kContent as String
        self.spareMsgLabel.frame = CGRect(x: 0, y: 0, width: msgLabelWidth + 2 * kMargin, height: self.msgLabelHeight + 20)
        self.spareMsgLabel.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        self.spareMsgLabel.transform = self.spareMsgLabel.transform.scaledBy(x: 1/obValue, y: 1/obValue)
    }
    func resetSubViewsForJHB_HUD_onlyAMsgMultipleShow() {
        self.spareMsgLabel.isHidden = false
        self.msgLabel.isHidden = true
        self.spareMsgLabel.numberOfLines = 0
        self.spareMsgLabel.text = self.kContent as String
        self.spareMsgLabel.frame = CGRect(x: 0, y: 0, width: msgLabelWidth, height: self.msgLabelHeight + 20)
        self.spareMsgLabel.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    func resetSubViewsForJHB_HUD_onlyAMsgMultipleShowWithScale(_ noti:Notification) {
        let obValue = noti.object as! CGFloat
        self.spareMsgLabel.isHidden = false
        self.msgLabel.isHidden = true
        self.spareMsgLabel.numberOfLines = 0
        self.spareMsgLabel.text = self.kContent as String
        self.spareMsgLabel.frame = CGRect(x: 0, y: 0, width: msgLabelWidth - 2 * kMargin, height: self.msgLabelHeight + 20)
        self.spareMsgLabel.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        self.spareMsgLabel.transform = self.spareMsgLabel.transform.scaledBy(x: 1/obValue, y: 1/obValue)
    }
}
