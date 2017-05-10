/******************** JHB_HUDManager.swift **********************/
/*******  (JHB)  ************************************************/
/*******  Created by Leon_pan on 16/8/12. ***********************/
/*******  Copyright © 2016年 CoderBala. All rights reserved.*****/
/******************** JHB_HUDManager.swift **********************/

/// Provide methods that the HUD-process with new window .So it's limited because of its superview.
/// So if you want another hHUD-process without limits, you'd better browser methods in 'JHB_HUDManager+View.swift' ,you can finish th HUD-process on the View customed by yourself.
import UIKit

class JHB_HUDManager: JHB_HUDPublicManager {
    // MARK: parameters
    /*核心视图*//*Core View Part*/
    var coreView      = JHB_HUDProgressView()
    /*透明背景*//*Clear Background*/
    var bgClearView   = UIView()

    
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
        
        self.coreView = JHB_HUDProgressView.init()
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
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - ShowAndHideWithAnimation
    // 只显示信息内容时的CoreView的行为效果(The Behavior Effect Of 'CoreView' When Just Show Message-Content)
    @objc fileprivate func coreViewShowAndHideWithAnimation(_ delay:Double){
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }, completion: { (true) in
            self.perform(#selector(JHB_HUDManager.selfCoreViewRemoveFromSuperview), with: self, afterDelay: delay)
        }) 
    }
    
    @objc fileprivate func selfCoreViewRemoveFromSuperview(){
        
        switch self.type {
        case HUDType.kHUDTypeDefaultly.hashValue:
            self.EffectSelfCoreViewRemoveAboutTopAndBottom(.kHUDTypeShowFromBottomToTop)
            break
        case HUDType.kHUDTypeShowImmediately.hashValue:
            self.EffectSelfCoreViewRemoveAboutStablePosition(.kHUDTypeShowImmediately)
            break
        case HUDType.kHUDTypeShowSlightly.hashValue:
            self.EffectSelfCoreViewRemoveAboutStablePosition(.kHUDTypeShowSlightly)
            break
        case HUDType.kHUDTypeShowFromBottomToTop.hashValue:
            self.EffectSelfCoreViewRemoveAboutTopAndBottom(.kHUDTypeShowFromBottomToTop)
            break
        case HUDType.kHUDTypeShowFromTopToBottom.hashValue:
            self.EffectSelfCoreViewRemoveAboutTopAndBottom(.kHUDTypeShowFromTopToBottom)
            break
        case HUDType.kHUDTypeShowFromLeftToRight.hashValue:
            self.EffectSelfCoreViewRemoveAboutLeftAndRight(.kHUDTypeShowFromLeftToRight)
            break
        case HUDType.kHUDTypeShowFromRightToLeft.hashValue:
            self.EffectSelfCoreViewRemoveAboutLeftAndRight(.kHUDTypeShowFromRightToLeft)
            break
        case HUDType.kHUDTypeScaleFromInsideToOutside.hashValue:
            self.EffectSelfCoreViewRemoveAboutInsideAndOutSide(.kHUDTypeScaleFromInsideToOutside)
            break
        case HUDType.kHUDTypeScaleFromOutsideToInside.hashValue:
            self.EffectSelfCoreViewRemoveAboutInsideAndOutSide(.kHUDTypeScaleFromOutsideToInside)
            break
        default:
            
            break
        }
    }
    
    // 1⃣️原位置不变
    func EffectSelfCoreViewRemoveAboutStablePosition(_ HudType:HUDType){
        
        var al : CGFloat = 1
        switch HudType {
        case .kHUDTypeShowImmediately:
            al = 1
            break
        case .kHUDTypeShowSlightly:
            al = 0
            break
        default:
            
            break
        }
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = al
        }, completion: { (true) in
            self.SuperInitStatus()
        }) 
    }
    
    // 2⃣️上下相关
    func EffectSelfCoreViewRemoveAboutTopAndBottom(_ HudType:HUDType) {
        
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
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2 + value)
            self.setNeedsDisplay()
        }, completion: { (true) in
             self.SuperInitStatus()
        }) 
        
    }
    
    // 3⃣️左右相关
    func EffectSelfCoreViewRemoveAboutLeftAndRight(_ HudType:HUDType) {
        
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
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2 + value, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }, completion: { (true) in
             self.SuperInitStatus()
        }) 
        
    }
    
    // 4⃣️内外相关
    func EffectSelfCoreViewRemoveAboutInsideAndOutSide(_ HudType:HUDType) {
        
        var kScaleValue : CGFloat = 0
        switch HudType {
        case .kHUDTypeScaleFromInsideToOutside:
            kScaleValue = 1.05
            break
        case .kHUDTypeScaleFromOutsideToInside:
            kScaleValue = 0.95
            break
        default:
            
            break
        }
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 0
            self.coreView.transform = self.coreView.transform.scaledBy(x: 1/kScaleValue, y: 1/kScaleValue)
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2 , y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }, completion: { (true) in
             self.SuperInitStatus()
        }) 
        
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
    
    // MARK: - 隐藏(Hidden❤️Default Type:dissolveToTop)
    public func hideProgress() {// DEFAULT
        self.perform(#selector(JHB_HUDManager.hideWithAnimation), with: self, afterDelay: 0.6)
    }
    @objc internal override func hideHud() {
        self.hideProgress()
    }
    override func ifBeMoved(bool: Bool) {
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(JHB_HUDManager.hideHud))
        self.isUserInteractionEnabled = bool
        self.addGestureRecognizer(longTap)
    }

}

extension JHB_HUDManager{
    
    // MARK: - 1⃣️单纯显示进程中(Just Show In Progress❤️Default Type:FromBottomType)

    public func showProgress(ifCustom:Bool,to:UIView) {// DEFAULT
        self.jhb_showProgress_setCoreView()
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        self.jhb_showProgress_setCoreView_moveAnimation()
    }

    /// 拆分组合PartOne:setPosition
    open func jhb_showProgress_setCoreView(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_haveNoMsg"), object: nil)
        /*重写位置*/
        self.coreView.msgLabel.isHidden = true
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - 80) / 2, y: (SCREEN_HEIGHT - 80) / 2, width: 80, height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 + 60)
    }
    /// 拆分组合PartOne:setAnimation
    open func jhb_showProgress_setCoreView_moveAnimation(){
        /*实现动画*/
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        })
    }
    
    public func showProgressWithType(_ HudType:HUDType,ifCustom:Bool,to:UIView) {// NEW
        self.type = HudType.hashValue
        
        switch HudType {
        case .kHUDTypeDefaultly:
            self.EffectShowProgressAboutTopAndBottom(.kHUDTypeShowFromBottomToTop,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowImmediately:
            self.EffectShowProgressAboutStablePositon(.kHUDTypeShowImmediately,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowSlightly:
            self.EffectShowProgressAboutStablePositon(.kHUDTypeShowSlightly,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromBottomToTop:
            self.EffectShowProgressAboutTopAndBottom(.kHUDTypeShowFromBottomToTop,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromTopToBottom:
            self.EffectShowProgressAboutTopAndBottom(.kHUDTypeShowFromTopToBottom,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromLeftToRight:
            self.EffectShowProgressAboutLeftAndRight(.kHUDTypeShowFromLeftToRight,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromRightToLeft:
            self.EffectShowProgressAboutLeftAndRight(.kHUDTypeShowFromRightToLeft,ifCustom:ifCustom,to:to)
        case .kHUDTypeScaleFromInsideToOutside:
            self.EffectShowProgressAboutInsideAndOutside(.kHUDTypeScaleFromInsideToOutside,ifCustom:ifCustom,to:to)
        case .kHUDTypeScaleFromOutsideToInside:
            self.EffectShowProgressAboutInsideAndOutside(.kHUDTypeScaleFromOutsideToInside,ifCustom:ifCustom,to:to)
        }
    }
    
    /// 拆分组合PartOne:setPosition
    /// <1.0> 原点与上下
    fileprivate func jhb_showProgressWithType_setCoreView_a(value:CGFloat){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_haveNoMsg"), object: nil)
        /*重写位置*/
        self.coreView.msgLabel.isHidden = true
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - 80) / 2, y: (SCREEN_HEIGHT - 80) / 2, width: 80, height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 - value)
        
    }
    /// <2.0> 左右
    fileprivate func jhb_showProgressWithType_setCoreView_b(value:CGFloat){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_haveNoMsg"), object: nil)
        /*重写位置*/
        self.coreView.msgLabel.isHidden = true
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - 80) / 2, y: (SCREEN_HEIGHT - 80) / 2, width: 80, height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2 + value, y: SCREEN_HEIGHT / 2)
        
    }
    /// <3.0> 内外
    fileprivate func jhb_showProgressWithType_setCoreView_c(kScaleValue:CGFloat, kInitValue:CGFloat){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_haveNoMsgWithScale"), object: kScaleValue)
        /*重写位置*/
        self.coreView.msgLabel.isHidden = true
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - kInitValue) / 2, y: (SCREEN_HEIGHT - kInitValue) / 2, width: kInitValue, height: kInitValue)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        
    }
    
    /// 拆分组合PartOne:setAnimation
    /// <1.0> 位置移动
    fileprivate func jhb_showProgressWithType_setCoreView_moveAnimation(){
        /*实现动画*/
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
        })
    }
    /// <2.0> 形变
    fileprivate func jhb_showProgressWithType_setCoreView_scaleAnimation(kScaleValue:CGFloat){
        /*实现动画*/
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.transform = self.coreView.transform.scaledBy(x: kScaleValue,y: kScaleValue)
        })
    }
    
    // 1⃣️原位置不变化
    func EffectShowProgressAboutStablePositon(_ type:HUDType,ifCustom:Bool,to:UIView) {
        
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
       
        self.jhb_showProgressWithType_setCoreView_a(value: 0)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        if kIfNeedEffect == false {
        }else if kIfNeedEffect == true {
            self.jhb_showProgressWithType_setCoreView_moveAnimation()
        }
    }
    // 2⃣️上下相关
    func EffectShowProgressAboutTopAndBottom(_ type:HUDType,ifCustom:Bool,to:UIView) {
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
        self.jhb_showProgressWithType_setCoreView_a(value: value)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        self.jhb_showProgressWithType_setCoreView_moveAnimation()
        
    }
    
    // 3⃣️左右相关
    func EffectShowProgressAboutLeftAndRight(_ type:HUDType,ifCustom:Bool,to:UIView){
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
        self.jhb_showProgressWithType_setCoreView_b(value: value)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        self.jhb_showProgressWithType_setCoreView_moveAnimation()
        
    }
    
    // 4⃣️内外相关
    func EffectShowProgressAboutInsideAndOutside(_ type:HUDType,ifCustom:Bool,to:UIView){
        
        var kInitValue : CGFloat = 0
        var kScaleValue : CGFloat = 0
        switch type {
        case .kHUDTypeScaleFromInsideToOutside:
            kInitValue = 45
            kScaleValue = 1.78
            break
        case .kHUDTypeScaleFromOutsideToInside:
            kInitValue = 120
            kScaleValue = 0.67
            break
        default:
            
            break
        }
        
        self.jhb_showProgressWithType_setCoreView_c(kScaleValue: kScaleValue, kInitValue: kInitValue)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        self.jhb_showProgressWithType_setCoreView_scaleAnimation(kScaleValue: kScaleValue)
        
    }
    
    // MARK: - 2⃣️显示进程及文字(Show InProgress-Status And The Words Message❤️Default Type:FromBottomType)
    public func showProgressMsgs(_ msgs:NSString,ifCustom:Bool,to:UIView) {
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        
        self.coreView.msgLabelWidth = msgLabelWidth + 20
        self.coreView.msgLabel.text = msgs as String
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_haveMsg"), object: nil)
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 80) / 2,width: msgLabelWidth + 2*kMargin , height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 + 60)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }) 
    }
    
    public func showProgressMsgsWithType(_ msgs:NSString, HudType:HUDType,ifCustom:Bool,to:UIView) {// NEW
        self.type = HudType.hashValue
        
        switch HudType {
        case .kHUDTypeDefaultly:
            self.EffectShowProgressMsgsAboutTopAndBottom(msgs,type: .kHUDTypeShowFromBottomToTop,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowImmediately:
            self.EffectShowProgressMsgsAboutStablePosition(msgs, type: .kHUDTypeShowImmediately,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowSlightly:
            self.EffectShowProgressMsgsAboutStablePosition(msgs, type: .kHUDTypeShowSlightly,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromBottomToTop:
            self.EffectShowProgressMsgsAboutTopAndBottom(msgs,type: .kHUDTypeShowFromBottomToTop,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromTopToBottom:
            self.EffectShowProgressMsgsAboutTopAndBottom(msgs,type:.kHUDTypeShowFromTopToBottom,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromLeftToRight:
            self.EffectShowProgressMsgsAboutLeftAndRight(msgs, type: .kHUDTypeShowFromLeftToRight,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromRightToLeft:
            self.EffectShowProgressMsgsAboutLeftAndRight(msgs, type: .kHUDTypeShowFromRightToLeft,ifCustom:ifCustom,to:to)
        case .kHUDTypeScaleFromInsideToOutside:
            self.EffectShowProgressMsgsAboutInsideAndOutside(msgs, type: .kHUDTypeScaleFromInsideToOutside,ifCustom:ifCustom,to:to)
        case .kHUDTypeScaleFromOutsideToInside:
            self.EffectShowProgressMsgsAboutInsideAndOutside(msgs, type: .kHUDTypeScaleFromOutsideToInside,ifCustom:ifCustom,to:to)
        }
    }
    
    // 1⃣️原位置不变
    fileprivate  func EffectShowProgressMsgsAboutStablePosition(_ msgs:NSString,type:HUDType,ifCustom:Bool,to:UIView) {
        
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
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_haveMsg"), object: nil)
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 80) / 2,width: msgLabelWidth + 2*kMargin , height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }) 
        
        self.coreView.msgLabelWidth = msgLabelWidth
        self.coreView.msgLabel.text = msgs as String
    }
    // 2⃣️上下相关
    fileprivate  func EffectShowProgressMsgsAboutTopAndBottom(_ msgs:NSString,type:HUDType,ifCustom:Bool,to:UIView){
        
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
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        self.coreView.msgLabelWidth = msgLabelWidth + 20
        self.coreView.msgLabel.text = msgs as String
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_haveMsg"), object: nil)
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 80) / 2,width: msgLabelWidth + 2*kMargin , height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 + value)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }) 
    }
    // 3⃣️左右相关
    fileprivate  func EffectShowProgressMsgsAboutLeftAndRight(_ msgs:NSString,type:HUDType,ifCustom:Bool,to:UIView){
        
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
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        self.coreView.msgLabelWidth = msgLabelWidth + 20
        self.coreView.msgLabel.text = msgs as String
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_haveMsg"), object: nil)
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 80) / 2,width: msgLabelWidth + 2*kMargin , height: 80)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2 + value, y: SCREEN_HEIGHT / 2)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }) 
    }
    
    // 4⃣️内外相关
    fileprivate  func EffectShowProgressMsgsAboutInsideAndOutside(_ msgs:NSString,type:HUDType,ifCustom:Bool,to:UIView){
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
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
            iniHeightValue = 80/kScaleValue
            break
        case .kHUDTypeScaleFromOutsideToInside:
            kScaleValue = 0.90
            iniWidthValue = CoreWidth/kScaleValue
            iniHeightValue = 80/kScaleValue
            break
        default:
            
            break
        }
        self.coreView.msgLabelWidth = iniWidthValue
        self.coreView.msgLabel.text = msgs as String
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_haveMsg_WithScale"), object: kScaleValue)
        
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - iniHeightValue) / 2,width: iniWidthValue , height: iniHeightValue)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.transform = self.coreView.transform.scaledBy(x: kScaleValue,y: kScaleValue)
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }) 
        
    }
    
    
    // MARK: - 3⃣️显示文字信息并完成隐藏(Show The Words_Message And Hidden When Finished❤️Default Type:FromBottomType)
    /*
     There Are Two Methods For The Type Of 'Just-Show-Message' , The First One is 'Show-Multi-Line',You Can Use This One To Sure That You Can Display Multi Line Message
     Parameters:
         --'msgs':It is The Content That You Want To Display
         --'coreInSet':It Is The Value That Decide The Margin Between CoreView And The Main-Window(Just Including CoreView's Left To Window's Left Or CoreView's Right To Window's Right)
         --'labelInSet':It Is The Value That Decide The Margin Between CoreView And The Message-Label(Just Including CoreView's Left To Label's Left Or CoreView's Right To Label's Right)
     PS : You'd Better Be Sure That  The Addition Of 'coreInSet'*2 And 'labelInSet'*2 Lower Than 'SCREEN_WIDTH - 30' ,Or It Will Reset The Margin Value Be 30 Both CoreView-To-Window And Label-To-Window     
     */
    // ❤️<一>:显示多行(Show Multi Line)
    public func showMultiLine(_ msgs:NSString, coreInSet:CGFloat, labelInSet:CGFloat, delay:Double,ifCustom:Bool,to:UIView){
        var KCore = coreInSet
        var KLabel = labelInSet
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        if coreViewRect.width > (SCREEN_WIDTH - coreInSet) {
            var paramSet : CGFloat = 0
            
            if (labelInSet+coreInSet)*2 > SCREEN_WIDTH-30 {
                KCore = 30
                KLabel = 30
                paramSet = (KCore+KLabel)*2
            }else{
                paramSet = (KCore+KLabel)*2
            }
            
            coreViewRect = msgs.boundingRect(with: CGSize(width: SCREEN_WIDTH-paramSet, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
                NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
                ], context: nil)
        }
        let msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: KCore, y: (SCREEN_HEIGHT - 60) / 2,width: SCREEN_WIDTH - KCore*2  , height: msgLabelHeight+20)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 + 60)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        self.coreView.msgLabelWidth = msgLabelWidth
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgMultipleShow"), object: nil)
        self.coreViewShowAndHideWithAnimation(delay)
    }
    public func showMultiLineWithType(_ msgs:NSString, coreInSet:CGFloat, labelInSet:CGFloat, delay:Double,HudType:HUDType,ifCustom:Bool,to:UIView){
        
        self.type = HudType.hashValue
        
        switch HudType {
        case .kHUDTypeDefaultly:
            self.EffectShowMultiMsgsAboutTopAndBottom(msgs,coreInSet: coreInSet,labelInSet: labelInSet,delay: delay,type: .kHUDTypeShowFromBottomToTop,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowImmediately:
            self.EffectShowMultiMsgsAboutStablePosition(msgs, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay, type: .kHUDTypeShowImmediately,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowSlightly:
            self.EffectShowMultiMsgsAboutStablePosition(msgs, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay, type: .kHUDTypeShowSlightly,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromBottomToTop:
            self.EffectShowMultiMsgsAboutTopAndBottom(msgs,coreInSet: coreInSet,labelInSet: labelInSet,delay: delay,type: .kHUDTypeShowFromBottomToTop,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromTopToBottom:
            self.EffectShowMultiMsgsAboutTopAndBottom(msgs,coreInSet: coreInSet,labelInSet: labelInSet,delay: delay,type: .kHUDTypeShowFromTopToBottom,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromLeftToRight:
            self.EffectShowMultiMsgsAboutLeftAndRight(msgs, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay, type: .kHUDTypeShowFromLeftToRight,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromRightToLeft:
            self.EffectShowMultiMsgsAboutLeftAndRight(msgs, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay, type: .kHUDTypeShowFromRightToLeft,ifCustom:ifCustom,to:to)
        case .kHUDTypeScaleFromInsideToOutside:
            self.EffectShowMultiMsgsAboutInsideAndOutside(msgs, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay, type: .kHUDTypeScaleFromInsideToOutside,ifCustom:ifCustom,to:to)
        case .kHUDTypeScaleFromOutsideToInside:
            self.EffectShowMultiMsgsAboutInsideAndOutside(msgs, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay, type: .kHUDTypeScaleFromOutsideToInside,ifCustom:ifCustom,to:to)
        }
        
    }
    // 1⃣️原位置不变
    fileprivate  func EffectShowMultiMsgsAboutStablePosition(_ msgs:NSString, coreInSet:CGFloat, labelInSet:CGFloat, delay:Double,type:HUDType,ifCustom:Bool,to:UIView){
        
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
        
        var KCore = coreInSet
        var KLabel = labelInSet
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        if coreViewRect.width > (SCREEN_WIDTH - coreInSet) {
            var paramSet : CGFloat = 0
            
            if (labelInSet+coreInSet)*2 > SCREEN_WIDTH-30 {
                KCore = 30
                KLabel = 30
                paramSet = (KCore+KLabel)*2
            }else{
                paramSet = (KCore+KLabel)*2
            }
            
            coreViewRect = msgs.boundingRect(with: CGSize(width: SCREEN_WIDTH-paramSet, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
                NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
                ], context: nil)
        }
        let msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: KCore, y: (SCREEN_HEIGHT - 60) / 2,width: SCREEN_WIDTH - KCore*2  , height: msgLabelHeight+20)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        self.coreView.msgLabelWidth = msgLabelWidth
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgMultipleShow"), object: nil)
        self.coreViewShowAndHideWithAnimation(delay)
    }
    
    // 2⃣️上下相关
    fileprivate  func EffectShowMultiMsgsAboutTopAndBottom(_ msgs:NSString, coreInSet:CGFloat, labelInSet:CGFloat, delay:Double,type:HUDType,ifCustom:Bool,to:UIView){
        
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
        
        var KCore = coreInSet
        var KLabel = labelInSet
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        if coreViewRect.width > (SCREEN_WIDTH - coreInSet) {
            var paramSet : CGFloat = 0
            
            if (labelInSet+coreInSet)*2 > SCREEN_WIDTH-30 {
                KCore = 30
                KLabel = 30
                paramSet = (KCore+KLabel)*2
            }else{
                paramSet = (KCore+KLabel)*2
            }
            
            coreViewRect = msgs.boundingRect(with: CGSize(width: SCREEN_WIDTH-paramSet, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
                NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
                ], context: nil)
        }
        let msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: KCore, y: (SCREEN_HEIGHT - 60) / 2,width: SCREEN_WIDTH - KCore*2  , height: msgLabelHeight+20)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 + value)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        self.coreView.msgLabelWidth = msgLabelWidth
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgMultipleShow"), object: nil)
        self.coreViewShowAndHideWithAnimation(delay)
    }
    
    // 3⃣️左右相关
    fileprivate  func EffectShowMultiMsgsAboutLeftAndRight(_ msgs:NSString, coreInSet:CGFloat, labelInSet:CGFloat, delay:Double,type:HUDType,ifCustom:Bool,to:UIView){
        
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
        
        var KCore = coreInSet
        var KLabel = labelInSet
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        if coreViewRect.width > (SCREEN_WIDTH - coreInSet) {
            var paramSet : CGFloat = 0
            
            if (labelInSet+coreInSet)*2 > SCREEN_WIDTH-30 {
                KCore = 30
                KLabel = 30
                paramSet = (KCore+KLabel)*2
            }else{
                paramSet = (KCore+KLabel)*2
            }
            
            coreViewRect = msgs.boundingRect(with: CGSize(width: SCREEN_WIDTH-paramSet, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
                NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
                ], context: nil)
        }
        let msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: KCore, y: (SCREEN_HEIGHT - 60) / 2,width: SCREEN_WIDTH - KCore*2  , height: msgLabelHeight+40)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2 + value, y: SCREEN_HEIGHT / 2)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        self.coreView.msgLabelWidth = msgLabelWidth
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgMultipleShow"), object: nil)
        self.coreViewShowAndHideWithAnimation(delay)
    }
    
    // 4⃣️内外相关
    fileprivate  func EffectShowMultiMsgsAboutInsideAndOutside(_ msgs:NSString, coreInSet:CGFloat, labelInSet:CGFloat, delay:Double,type:HUDType,ifCustom:Bool,to:UIView){
        
        var KCore = coreInSet
        var KLabel = labelInSet
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        if coreViewRect.width > (SCREEN_WIDTH - coreInSet) {
            var paramSet : CGFloat = 0
            
            if (labelInSet+coreInSet)*2 > SCREEN_WIDTH-30 {
                KCore = 30
                KLabel = 30
                paramSet = (KCore+KLabel)*2
            }else{
                paramSet = (KCore+KLabel)*2
            }
            
            coreViewRect = msgs.boundingRect(with: CGSize(width: SCREEN_WIDTH-paramSet, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
                NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
                ], context: nil)
        }
        
        let msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        
        var iniWidthValue : CGFloat = 0
        var iniHeightValue : CGFloat = 0
        var kScaleValue : CGFloat = 0
        
        switch type {
        case .kHUDTypeScaleFromInsideToOutside:
            kScaleValue = 1.05
            iniWidthValue = (msgLabelWidth + 2*KLabel)/kScaleValue
            iniHeightValue = (msgLabelHeight + 40)/kScaleValue
            break
        case .kHUDTypeScaleFromOutsideToInside:
            kScaleValue = 0.95
            iniWidthValue = (msgLabelWidth + 2*KLabel)/kScaleValue
            iniHeightValue = (msgLabelHeight + 40)/kScaleValue
            break
        default:
            
            break
        }
        
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: KCore, y: (SCREEN_HEIGHT - iniWidthValue) / 2,width: iniWidthValue , height: iniHeightValue+20)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        self.coreView.msgLabelWidth = msgLabelWidth
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgMultipleShowWithScale"), object: kScaleValue)
        
        
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.transform = self.coreView.transform.scaledBy(x: kScaleValue, y: kScaleValue)
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }, completion: { (true) in
            self.perform(#selector(JHB_HUDManager.selfCoreViewRemoveFromSuperview), with: self, afterDelay: delay)
        }) 
        
    }
    
    // ❤️<二>:显示单行(Show Single Line)
    /*
     There Is Only One Paramter,That Is The Content You Want To Display ,And If You Want To Show A Brief Message Or Just One-Line Message,You All Can Use The One!
     */
    public func show(_ msgs:NSString,ifCustom:Bool,to:UIView) {// DEFAULT
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 150000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 60) / 2,width: msgLabelWidth + 2*kMargin , height: 60)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 + 60)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        self.coreView.msgLabelWidth = msgLabelWidth + 10
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgShow"), object: nil)
        self.coreViewShowAndHideWithAnimation(0)
        
    }
    public func showWithType(_ msgs:NSString,HudType:HUDType,ifCustom:Bool,to:UIView){
        self.type = HudType.hashValue
        
        switch HudType {
        case .kHUDTypeDefaultly:
            self.EffectShowMsgsAboutTopAndBottom(msgs,type: .kHUDTypeShowFromBottomToTop,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowImmediately:
            self.EffectShowMsgsAboutStablePosition(msgs, type: .kHUDTypeShowImmediately,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowSlightly:
            self.EffectShowMsgsAboutStablePosition(msgs, type: .kHUDTypeShowSlightly,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromBottomToTop:
            self.EffectShowMsgsAboutTopAndBottom(msgs,type: .kHUDTypeShowFromBottomToTop,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromTopToBottom:
            self.EffectShowMsgsAboutTopAndBottom(msgs,type:.kHUDTypeShowFromTopToBottom,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromLeftToRight:
            self.EffectShowMsgsAboutLeftAndRight(msgs, type: .kHUDTypeShowFromLeftToRight,ifCustom:ifCustom,to:to)
        case .kHUDTypeShowFromRightToLeft:
            self.EffectShowMsgsAboutLeftAndRight(msgs, type: .kHUDTypeShowFromRightToLeft,ifCustom:ifCustom,to:to)
        case .kHUDTypeScaleFromInsideToOutside:
            self.EffectShowMsgsAboutInsideAndOutside(msgs, type: .kHUDTypeScaleFromInsideToOutside,ifCustom:ifCustom,to:to)
        case .kHUDTypeScaleFromOutsideToInside:
            self.EffectShowMsgsAboutInsideAndOutside(msgs, type: .kHUDTypeScaleFromOutsideToInside,ifCustom:ifCustom,to:to)
        }
    }
    
    // 1⃣️原位置不变
    fileprivate func EffectShowMsgsAboutStablePosition(_ msgs:NSString,type:HUDType,ifCustom:Bool,to:UIView) {
        
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
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 150000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 60) / 2,width: msgLabelWidth + 2*kMargin , height: 60)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 )
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        self.coreView.msgLabelWidth = msgLabelWidth-20
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgShow"), object: nil)
        self.coreViewShowAndHideWithAnimation(2)
    }
    
    // 2⃣️上下相关
    fileprivate func EffectShowMsgsAboutTopAndBottom(_ msgs:NSString,type:HUDType,ifCustom:Bool,to:UIView)  {
        
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
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 150000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 60) / 2,width: msgLabelWidth + 2*kMargin , height: 60)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2 + value)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        self.coreView.msgLabelWidth = msgLabelWidth-20
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgShow"), object: nil)
        self.coreViewShowAndHideWithAnimation(0)
    }
    
    // 3⃣️左右相关
    fileprivate func EffectShowMsgsAboutLeftAndRight(_ msgs:NSString,type:HUDType,ifCustom:Bool,to:UIView)  {
        
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
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 150000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - msgLabelWidth) / 2, y: (SCREEN_HEIGHT - 60) / 2,width: msgLabelWidth + 2*kMargin , height: 60)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2 + value, y: SCREEN_HEIGHT / 2 )
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        self.coreView.msgLabelWidth = msgLabelWidth-20
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgShow"), object: nil)
        self.coreViewShowAndHideWithAnimation(0)
    }
    
    // 4⃣️内外相关
    fileprivate func EffectShowMsgsAboutInsideAndOutside(_ msgs:NSString,type:HUDType,ifCustom:Bool,to:UIView)  {
        
        coreViewRect = msgs.boundingRect(with: CGSize(width: self.coreView.msgLabel.bounds.width, height: 150000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15.0)
            ], context: nil)
        var msgLabelWidth = coreViewRect.width
        let msgLabelHeight = coreViewRect.height
        if msgLabelWidth + 2*kMargin >= (SCREEN_WIDTH - 30) {
            msgLabelWidth = SCREEN_WIDTH - 30 - 2*kMargin
        }else if msgLabelWidth + 2*kMargin <= 80 {
            msgLabelWidth = 80
        }
        let CoreWidth = msgLabelWidth + 2*kMargin
        var iniWidthValue : CGFloat = 0
        var kScaleValue : CGFloat = 0
        
        switch type {
        case .kHUDTypeScaleFromInsideToOutside:
            kScaleValue = 1.05
            iniWidthValue = CoreWidth/kScaleValue
            break
        case .kHUDTypeScaleFromOutsideToInside:
            kScaleValue = 0.95
            iniWidthValue = CoreWidth/kScaleValue
            break
        default:
            
            break
        }
        
        self.coreView.msgLabelWidth = msgLabelWidth-20
        self.coreView.msgLabelHeight = msgLabelHeight
        self.coreView.kContent = msgs as String as String as NSString
        
        self.coreView.actView.stopAnimating()
        self.coreView.frame = CGRect(x: (SCREEN_WIDTH - iniWidthValue) / 2, y: (SCREEN_HEIGHT - 60) / 2,width: iniWidthValue + 2*kMargin , height: 60)
        self.coreView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        ifCustom == true ? self.addTo(to: to):self.ResetWindowPosition()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "JHB_HUD_onlyAMsgShowWithScale"), object: kScaleValue)
        UIView.animate(withDuration: 0.65, animations: {
            self.coreView.alpha = 1
            self.coreView.transform = self.coreView.transform.scaledBy(x: kScaleValue, y: kScaleValue)
            self.coreView.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
            self.setNeedsDisplay()
        }, completion: { (true) in
            self.perform(#selector(JHB_HUDManager.selfCoreViewRemoveFromSuperview), with: self, afterDelay: 1.5)
        }) 
        
    }
    
    ///
    public func addTo(to:UIView) {
        self.frame = to.frame
        self.center = to.center
        to.addSubview(self)
    }
}
