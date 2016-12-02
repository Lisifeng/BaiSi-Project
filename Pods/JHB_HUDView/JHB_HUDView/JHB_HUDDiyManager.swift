/****************** JHB_HUDDiyManager.swift *********************/
/*******  (JHB)  ************************************************/
/*******  Created by Leon_pan on 16/8/15. ***********************/
/*******  Copyright © 2016年 CoderBala. All rights reserved.*****/
/****************** JHB_HUDDiyManager.swift *********************/

import UIKit

open class JHB_HUDDiyManager: UIView {
    fileprivate  var windowsTemp: [UIWindow] = []
    fileprivate  var timer: DispatchSource?
    // MARK: parameters
    let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    /*透明背景*//*Clear Background*/
    var bgClearView   = UIView()
    /*核心视图*//*Core View Part*/
    var coreView      = JHB_HUDDiyProgressView()
    /*核心视图尺寸*//*The Frame Of Core View Part*/
    var coreViewRect  = CGRect()
    /*核心视图内部统一间隔*//*The Uniformed Margin Inside Core View Part*/
    var kMargin : CGFloat = 10
    /*定义当前类型*//*Current Type*/
    var type : NSInteger = 0
    /*之前的屏幕旋转类型*//*The Screen Rotation Type Of Previous*/
    var PreOrientation = UIDevice.current.orientation
    /*初始化的屏幕旋转类型*//*The Screen Rotation Type Of Initial-status*/
    var InitOrientation = UIDevice.current.orientation
    
    // MARK: - Interface
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    func setUp() {
        self.setSubViews()
        self.addSubview(self.bgClearView)
        self.addSubview(self.coreView)
        PreOrientation = UIDevice.current.orientation
        InitOrientation = UIDevice.current.orientation
        self.registerDeviceOrientationNotification()
        
        if PreOrientation != .portrait {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUDTopVcCannotRotated"), object: self.PreOrientation.hashValue, userInfo: nil)
        }

    }
    
    
    func setSubViews() {
        self.bgClearView = UIView.init()
        self.bgClearView.backgroundColor = UIColor.clear
        
        self.coreView = JHB_HUDDiyProgressView.init()
        self.coreView.sizeToFit()
        self.coreView.layer.cornerRadius = 10
        self.coreView.layer.masksToBounds = true
        self.coreView.backgroundColor = UIColor.black
        self.coreView.alpha = 0
        
        self.resetSubViews()
    }
    
    func resetSubViews() {
        self.bgClearView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - 70) / 2, y: (SCREEN_HEIGHT - 70) / 2, width: 70, height: 70)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 + 60)
    }
    
    
    
    // MARK: About Screen Rotation
    // 1⃣️Remove Notification
    fileprivate func RemoveNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 2⃣️register Notification
    fileprivate func registerDeviceOrientationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.transformWindow(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
        
    // 3️⃣Transform Of Screen
    @objc fileprivate func transformWindow(_ notification: Notification) {
        var rotation: CGFloat = 0
        if self.InitOrientation == .portrait{
            if self.PreOrientation == .portrait {
                switch UIDevice.current.orientation {
                case .portrait:
                    rotation = 0
                case .portraitUpsideDown:
                    rotation = CGFloat(M_PI)
                case .landscapeLeft:
                    rotation = CGFloat(M_PI/2)
                case .landscapeRight:
                    rotation = CGFloat(M_PI + (M_PI/2))
                default:
                    break
                }
            }else if self.PreOrientation == .portraitUpsideDown {
                switch UIDevice.current.orientation {
                case .portrait:
                    rotation = 0
                case .portraitUpsideDown:
                    rotation = CGFloat((M_PI/2))
                case .landscapeLeft:
                    rotation = CGFloat((M_PI/2))
                case .landscapeRight:
                    rotation = CGFloat(M_PI + M_PI/2)
                default:
                    break
                }
            }else if self.PreOrientation == .landscapeLeft {
                switch UIDevice.current.orientation {
                case .portrait:
                    rotation = 0
                case .portraitUpsideDown:
                    rotation = CGFloat(M_PI)
                case .landscapeLeft:
                    rotation = 0
                case .landscapeRight:
                    rotation = CGFloat(M_PI + M_PI/2)
                default:
                    break
                }
            }else if self.PreOrientation == .landscapeRight {
                switch UIDevice.current.orientation {
                case .portrait:
                    rotation = 0
                case .portraitUpsideDown:
                    rotation = CGFloat(M_PI)
                case .landscapeLeft:
                    rotation = CGFloat(M_PI/2)
                case .landscapeRight:
                    rotation = 0
                default:
                    break
                }
            }else if self.PreOrientation == .faceDown ||  self.PreOrientation == .faceDown {
                return
            }
        }else if self.InitOrientation == .landscapeLeft || self.InitOrientation == .landscapeRight || self.InitOrientation == .portraitUpsideDown {
            return
        }
        
        self.PreOrientation = UIDevice.current.orientation
        windowsTemp.forEach {_ in 
            window!.center = self.getCenter()
            window!.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
 
    // 4️⃣Get Center Of Screen
    fileprivate  func getCenter() -> CGPoint {
        let rv = UIApplication.shared.keyWindow?.subviews.first as UIView!
        let rvWidth = rv?.bounds.width.hashValue
        let rvHeight = rv?.bounds.height.hashValue
        if self.InitOrientation == .portrait{
            if self.PreOrientation == .portrait {
                return rv!.center
            }else {
                if rvWidth! > rvHeight! {
                    return CGPoint(x: rv!.bounds.height/2, y: rv!.bounds.width/2)
                }
            }
        }else if self.InitOrientation == .landscapeLeft {
            if self.PreOrientation == .landscapeLeft || self.PreOrientation == .landscapeRight {
                return rv!.center
            }else {
                if rvWidth! > rvHeight! {
                    return CGPoint(x: rv!.bounds.height/2, y: rv!.bounds.width/2)
                }
            }
        }else if self.InitOrientation == .landscapeRight {
            if self.PreOrientation == .landscapeLeft || self.PreOrientation == .landscapeRight {
                return rv!.center
            }else {
                if rvWidth! > rvHeight! {
                    return CGPoint(x: rv!.bounds.height/2, y: rv!.bounds.width/2)
                }
            }
        }
        return rv!.center

    }
    // 5️⃣Init Screen's Condition
    @objc fileprivate func dismiss() {
        var timer: DispatchSource?
        if let _ = timer {
            timer!.cancel()
            timer = nil
        }
        windowsTemp.removeAll(keepingCapacity: false)
    }
}


public extension JHB_HUDDiyManager{
    
    // MARK: - 1⃣️单纯显示DIY进程中(Just Show In DIY-Progress)
    public func showDIYProgressWithType(_ img:NSString,diySpeed:CFTimeInterval,diyHudType:DiyHUDType, HudType:HUDType) {
        self.coreView.diyShowImage = img
        self.coreView.diySpeed = diySpeed
        self.coreView.diyHudType = diyHudType.hashValue
        self.type = HudType.hashValue
        self.showDIYProgressWithHUDType(HudType)
    }
    // MARK: - 2⃣️单纯显示DIY进程中(Just Show In DIY-Progress:❤️播放图片数组)
    public func showDIYProgressAnimated(_ imgsName:NSString,imgsNumber:NSInteger,diySpeed:TimeInterval, HudType:HUDType){
        self.coreView.diyShowImage = imgsName
        self.coreView.diyImgsNumber = imgsNumber
        self.coreView.diySpeed = diySpeed
        self.type = HudType.hashValue
        self.showDIYProgressWithHUDType(HudType)
    }
    
    fileprivate func showDIYProgressWithHUDType(_ HudType:HUDType) {
        
        switch HudType {
        case .kHUDTypeDefaultly:
            self.EffectShowProgressAboutTopAndBottom(.kHUDTypeShowFromBottomToTop)
        case .kHUDTypeShowImmediately:
            self.EffectShowProgressAboutStablePositon(.kHUDTypeShowImmediately)
        case .kHUDTypeShowSlightly:
            self.EffectShowProgressAboutStablePositon(.kHUDTypeShowSlightly)
        case .kHUDTypeShowFromBottomToTop:
            self.EffectShowProgressAboutTopAndBottom(.kHUDTypeShowFromBottomToTop)
        case .kHUDTypeShowFromTopToBottom:
            self.EffectShowProgressAboutTopAndBottom(.kHUDTypeShowFromTopToBottom)
        case .kHUDTypeShowFromLeftToRight:
            self.EffectShowProgressAboutLeftAndRight(.kHUDTypeShowFromLeftToRight)
        case .kHUDTypeShowFromRightToLeft:
            self.EffectShowProgressAboutLeftAndRight(.kHUDTypeShowFromRightToLeft)
        case .kHUDTypeScaleFromInsideToOutside:
            self.EffectShowProgressAboutInsideAndOutside(.kHUDTypeScaleFromInsideToOutside)
        case .kHUDTypeScaleFromOutsideToInside:
            self.EffectShowProgressAboutInsideAndOutside(.kHUDTypeScaleFromOutsideToInside)
        }
        
    }
    
      // 1⃣️原位置不变化
    fileprivate func EffectShowProgressAboutStablePositon(_ type:HUDType) {
        
        var kIfNeedEffect : Bool = false
        switch type {
        case .kHUDTypeShowImmediately:
            kIfNeedEffect = false
            self.coreView.alpha = 1
            break
        case .kHUDTypeShowSlightly:
            kIfNeedEffect = true
            self.coreView.alpha = 0
            break
        default:
            
            break
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_DIYHUD_haveNoMsg"), object: nil)
        /*重写位置*/
        self.coreView.diyMsgLabel.isHidden = true
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - 80) / 2, y: (SCREEN_HEIGHT - 80) / 2, width: 80, height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 )
        self.ResetWindowPosition()
        
        if kIfNeedEffect == false {
        }else if kIfNeedEffect == true {
            /*实现动画*/
            UIView.animate(withDuration: 0.65, animations: {
                self.coreView.alpha = 1
                self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            }) 
        }
    }
    // 2⃣️上下相关
    fileprivate  func EffectShowProgressAboutTopAndBottom(_ type:HUDType) {
        var value : CGFloat = 0
        switch type {
        case .kHUDTypeShowFromBottomToTop:
            value = -60
            break
        case .kHUDTypeShowFromTopToBottom:
            value = 60
            break
        default:
            
            break
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_DIYHUD_haveNoMsg"), object: nil)
        /*重写位置*/
        self.coreView.diyMsgLabel.isHidden = true
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - 80) / 2, y: (SCREEN_HEIGHT - 80) / 2, width: 80, height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 - value)
        self.ResetWindowPosition()
        
        /*实现动画*/
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        }) 
        
    }
    
    // 3⃣️左右相关
    fileprivate  func EffectShowProgressAboutLeftAndRight(_ type:HUDType){
        var value : CGFloat = 0
        switch type {
        case .kHUDTypeShowFromLeftToRight:
            value = -60
            break
        case .kHUDTypeShowFromRightToLeft:
            value = 60
            break
        default:
            
            break
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_DIYHUD_haveNoMsg"), object: nil)
        /*重写位置*/
        self.coreView.diyMsgLabel.isHidden = true
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - 80) / 2, y: (SCREEN_HEIGHT - 80) / 2, width: 80, height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2 + value, y: SCREEN_HEIGHT / 2)
        self.ResetWindowPosition()
        
        /*实现动画*/
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        }) 
        
    }
    
    // 4⃣️内外相关
    fileprivate  func EffectShowProgressAboutInsideAndOutside(_ type:HUDType){
        
        var kInitValue : CGFloat = 0
        var kScaleValue : CGFloat = 0
        switch type {
        case .kHUDTypeScaleFromInsideToOutside:
            kInitValue = 85
            kScaleValue = 1.28
            break
        case .kHUDTypeScaleFromOutsideToInside:
            kInitValue = 130
            kScaleValue = 0.85
            break
        default:
            
            break
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_DIYHUD_haveNoMsgWithScale"), object: kScaleValue)
        /*重写位置*/
        self.coreView.diyMsgLabel.isHidden = true
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - kInitValue) / 2, y: (SCREEN_HEIGHT - kInitValue) / 2, width: kInitValue, height: kInitValue)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)

        self.ResetWindowPosition()
        /*实现动画*/
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.transform = self.coreView.transform.scaledBy(x: kScaleValue,y: kScaleValue)
        })
        
    }
   
    // MARK: - 3⃣️显示DIY进程及文字(Show DIY-InProgress-Status And The Words-Message)
    public func showDIYProgressMsgsWithType(_ msgs:NSString,img:NSString,diySpeed:CFTimeInterval,diyHudType:DiyHUDType, HudType:HUDType) {// NEW
        self.coreView.diySpeed = diySpeed
        self.coreView.diyHudType = diyHudType.hashValue
        self.coreView.diyShowImage = img
        self.type = HudType.hashValue
        self.showDIYProgressMsgsWithHUDType(msgs, HudType: HudType)
    }
    // MARK: - 4⃣️显示DIY进程及文字(Show DIY-InProgress-Status And The Words-Message❤️播放图片数组)
    public func showDIYProgressMsgsAnimated(_ msgs:NSString,imgsName:NSString,imgsNumber:NSInteger,diySpeed:TimeInterval, HudType:HUDType) {// NEW
        self.coreView.diyShowImage = imgsName
        self.coreView.diyImgsNumber = imgsNumber
        self.coreView.diySpeed = diySpeed
        self.type = HudType.hashValue
        self.showDIYProgressMsgsWithHUDType(msgs, HudType: HudType)
    }
    
    fileprivate func showDIYProgressMsgsWithHUDType(_ msgs:NSString,HudType:HUDType) {
        switch HudType {
        case .kHUDTypeDefaultly:
            self.EffectShowProgressMsgsAboutTopAndBottom(msgs,type: .kHUDTypeShowFromBottomToTop)
        case .kHUDTypeShowImmediately:
            self.EffectShowProgressMsgsAboutStablePosition(msgs, type: .kHUDTypeShowImmediately)
        case .kHUDTypeShowSlightly:
            self.EffectShowProgressMsgsAboutStablePosition(msgs, type: .kHUDTypeShowSlightly)
        case .kHUDTypeShowFromBottomToTop:
            self.EffectShowProgressMsgsAboutTopAndBottom(msgs,type: .kHUDTypeShowFromBottomToTop)
        case .kHUDTypeShowFromTopToBottom:
            self.EffectShowProgressMsgsAboutTopAndBottom(msgs,type:.kHUDTypeShowFromTopToBottom)
        case .kHUDTypeShowFromLeftToRight:
            self.EffectShowProgressMsgsAboutLeftAndRight(msgs, type: .kHUDTypeShowFromLeftToRight)
        case .kHUDTypeShowFromRightToLeft:
            self.EffectShowProgressMsgsAboutLeftAndRight(msgs, type: .kHUDTypeShowFromRightToLeft)
        case .kHUDTypeScaleFromInsideToOutside:
            self.EffectShowProgressMsgsAboutInsideAndOutside(msgs, type: .kHUDTypeScaleFromInsideToOutside)
        case .kHUDTypeScaleFromOutsideToInside:
            self.EffectShowProgressMsgsAboutInsideAndOutside(msgs, type: .kHUDTypeScaleFromOutsideToInside)
        }
    }
    
    // 1⃣️原位置不变
    fileprivate  func EffectShowProgressMsgsAboutStablePosition(_ msgs:NSString,type:HUDType) {
        
        switch type {
        case .kHUDTypeShowImmediately:
            self.coreView.alpha = 1
            break
        case .kHUDTypeShowSlightly:
            self.coreView.alpha = 0
            
            break
        default:
            
            break
        }
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.diyMsgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_DIYHUD_haveMsg"), object: nil)
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 80) / 2,width: msgLabelWidth + 2*kMargin , height: 105)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        self.ResetWindowPosition()
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }) 
        
        self.coreView.diyMsgLabelWidth = msgLabelWidth
        self.coreView.diyMsgLabel.text = msgs as String
    }
    // 2⃣️上下相关
    fileprivate  func EffectShowProgressMsgsAboutTopAndBottom(_ msgs:NSString,type:HUDType){
        
        var value : CGFloat = 0
        switch type {
        case .kHUDTypeShowFromBottomToTop:
            value = 60
            break
        case .kHUDTypeShowFromTopToBottom:
            value = -60
            break
        default:
            
            break
        }
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.diyMsgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        self.coreView.diyMsgLabelWidth = msgLabelWidth + 20
        self.coreView.diyMsgLabel.text = msgs as String
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_DIYHUD_haveMsg"), object: nil)
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 80) / 2,width: msgLabelWidth + 2*kMargin , height: 105)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 + value)
        self.ResetWindowPosition()
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }) 
    }
    // 3⃣️左右相关
    fileprivate  func EffectShowProgressMsgsAboutLeftAndRight(_ msgs:NSString,type:HUDType){
        
        var value : CGFloat = 0
        switch type {
        case .kHUDTypeShowFromLeftToRight:
            value = -60
            break
        case .kHUDTypeShowFromRightToLeft:
            value = 60
            break
        default:
            
            break
        }
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.diyMsgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        self.coreView.diyMsgLabelWidth = msgLabelWidth + 20
        self.coreView.diyMsgLabel.text = msgs as String
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_DIYHUD_haveMsg"), object: nil)
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 80) / 2,width: msgLabelWidth + 2*kMargin , height: 105)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2 + value, y: SCREEN_HEIGHT / 2)
        self.ResetWindowPosition()
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }) 
    }
    
    // 4⃣️内外相关
    fileprivate  func EffectShowProgressMsgsAboutInsideAndOutside(_ msgs:NSString,type:HUDType){
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.diyMsgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        let CoreWidth = msgLabelWidth + 2*kMargin
        var iniWidthValue : CGFloat = 0
        var iniHeightValue : CGFloat = 0
        var kScaleValue : CGFloat = 0
        
        switch type {
        case .kHUDTypeScaleFromInsideToOutside:
            kScaleValue = 1.05
            iniWidthValue = (CoreWidth + 10)/kScaleValue
            iniHeightValue = 105/kScaleValue
            break
        case .kHUDTypeScaleFromOutsideToInside:
            kScaleValue = 0.90
            iniWidthValue = CoreWidth/kScaleValue
            iniHeightValue = 105/kScaleValue
            break
        default:
            
            break
        }
        self.coreView.diyMsgLabelWidth = iniWidthValue
        self.coreView.diyMsgLabel.text = msgs as String
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_DIYHUD_haveMsg_WithScale"), object: kScaleValue)
        
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - iniHeightValue) / 2,width: iniWidthValue , height: iniHeightValue)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        self.ResetWindowPosition()
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.transform = self.coreView.transform.scaledBy(x: kScaleValue,y: kScaleValue)
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }) 
        
    }
    
    
    // MARK: - 隐藏(Hidden❤️Type:dissolveToTop)
    public func hideProgress() {// DEFAULT
        self.perform(#selector(JHB_HUDDiyManager.hideWithAnimation), with: self, afterDelay: 0.6)
    }
    fileprivate func hideHud() {
        self.hideProgress()
    }

    // MARK: - Self-Method Without Ask
    @objc fileprivate func hideWithAnimation() {
        
        switch self.type {
        case HUDType.kHUDTypeDefaultly.hashValue:
            // ❤️默认类型
            self.EffectRemoveAboutBottomAndTop(.kHUDTypeShowFromBottomToTop)
            break
        case HUDType.kHUDTypeShowImmediately.hashValue:
            self.EffectRemoveAboutStablePositon(.kHUDTypeShowImmediately)
            break
        case HUDType.kHUDTypeShowSlightly.hashValue:
            self.EffectRemoveAboutStablePositon(.kHUDTypeShowSlightly)
            break
        case HUDType.kHUDTypeShowFromBottomToTop.hashValue:
            self.EffectRemoveAboutBottomAndTop(.kHUDTypeShowFromBottomToTop)
            break
        case HUDType.kHUDTypeShowFromTopToBottom.hashValue:
            self.EffectRemoveAboutBottomAndTop(.kHUDTypeShowFromTopToBottom)
            break
        case HUDType.kHUDTypeShowFromLeftToRight.hashValue:
            self.EffectRemoveAboutLeftAndRight(.kHUDTypeShowFromLeftToRight)
            break
        case HUDType.kHUDTypeShowFromRightToLeft.hashValue:
            self.EffectRemoveAboutLeftAndRight(.kHUDTypeShowFromRightToLeft)
            break
        case HUDType.kHUDTypeScaleFromInsideToOutside.hashValue:
            self.EffectRemoveAboutInsideAndOutside(.kHUDTypeScaleFromInsideToOutside)
            break
        case HUDType.kHUDTypeScaleFromOutsideToInside.hashValue:
            self.EffectRemoveAboutInsideAndOutside(.kHUDTypeScaleFromOutsideToInside)
            break
        default:
            
            break
        }
        
    }
    // 1⃣️原位置不变
    func EffectRemoveAboutStablePositon(_ HudType:HUDType) {
        
        var  kIfNeedEffect : Bool = false
        switch HudType {
        case .kHUDTypeShowImmediately:
            kIfNeedEffect = false
            break
        case .kHUDTypeShowSlightly:
            kIfNeedEffect = true
            break
        default:
            
            break
        }
        
        if kIfNeedEffect == false {
            self.SuperInitStatus()
        }else if kIfNeedEffect == true {
            UIView.animate(withDuration: 0.65, animations: {
                self.coreView.alpha = 0
                self.coreView.center = CGPoint(x: self.bgClearView.bounds.size.width / 2, y: self.bgClearView.bounds.size.height / 2)
            }, completion: { (true) in
                self.SuperInitStatus()
            }) 
        }
    }
    // 2⃣️上下相关
    func EffectRemoveAboutBottomAndTop(_ HudType:HUDType) {
        
        var value : CGFloat = 0
        switch HudType {
        case .kHUDTypeShowFromBottomToTop:
            value = -60
            break
        case .kHUDTypeShowFromTopToBottom:
            value = 60
            break
        default:
            
            break
        }
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 0
            self.coreView.center = CGPoint(x: self.bgClearView.bounds.size.width / 2, y: self.bgClearView.bounds.size.height / 2 + value)
        }, completion: { (true) in
            self.SuperInitStatus()
        }) 
    }
    
    // 3⃣️左右相关
    func EffectRemoveAboutLeftAndRight(_ HudType:HUDType) {
        var value : CGFloat = 0
        
        switch HudType {
        case .kHUDTypeShowFromLeftToRight:
            value = 60
            break
        case .kHUDTypeShowFromRightToLeft:
            value = -60
            break
        default:
            
            break
        }
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 0
            self.coreView.center = CGPoint(x: self.bgClearView.bounds.size.width / 2 + value, y: self.bgClearView.bounds.size.height / 2)
        }, completion: { (true) in
            self.SuperInitStatus()
        }) 
    }
    
    // 4⃣️内外相关
    func EffectRemoveAboutInsideAndOutside(_ HudType:HUDType) {
        
        var kScaleValue : CGFloat = 0
        switch HudType {
        case .kHUDTypeScaleFromInsideToOutside:
            kScaleValue = 1.78
            break
        case .kHUDTypeScaleFromOutsideToInside:
            kScaleValue = 0.67
            break
        default:
            
            break
        }
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 0
            self.coreView.transform = self.coreView.transform.scaledBy(x: 1/kScaleValue,y: 1/kScaleValue)
            self.coreView.center = CGPoint(x: self.bgClearView.bounds.size.width / 2, y: self.bgClearView.bounds.size.height / 2)
        }, completion: { (true) in
            self.SuperInitStatus()
        }) 
    }
    
    // MARK: - 新增适应屏幕旋转相关
    /*************➕保持适应屏幕旋转前提下实现移除➕************/
    
    func SuperInitStatus() {
        self.RemoveNotification()
        self.dismiss()
        InitOrientation = UIDevice.current.orientation
    NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUDTopVcCanRotated"), object: nil, userInfo: nil)
        self.removeFromSuperview()
    }
    /*************➕保持适应屏幕旋转前提下实现添加➕************/
    func ResetWindowPosition() {
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.bounds.size.width)!,height: (UIApplication.shared.keyWindow?.bounds.size.height)!)
        window.windowLevel = UIWindowLevelAlert
        window.center = self.getCenter()
        window.isHidden = false
        window.addSubview(self)
        windowsTemp.append(window)
    }

}
