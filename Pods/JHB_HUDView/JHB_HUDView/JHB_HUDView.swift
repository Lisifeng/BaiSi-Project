/********************** JHB_HUDView.swift ***********************/
/*******  (JHB)  ************************************************/
/*******  Created by Leon_pan on 16/6/12. ***********************/
/*******  Copyright © 2016年 CoderBala. All rights reserved.*****/
/********************** JHB_HUDView.swift ***********************/
/// --- --- --- <= 0.1.5 --- --- --- ///
/*
 Points For Attention:
 Well, I want to say thanks for your support and concern firstly ! And at present,You can get the follows methods from the bottom to integrate into your projects according to your demands .In fact, there are two main parts : the regular-part and diy-part. In regular-part ,you can use most effects that comes from system, it is the initial part I designed, cooperated with follows nine display-dismiss types !
 And then I optimized some disadvantages , and expaned five methods to display-sidmiss diy-image(you'd better let it be lower or equal to imageView's size of 50×50) type of HUD,and it's a unique style belong to 'JHB_HUDView'. So you'd better make a distinction between the two parts! At the same times, the good news is that it can supprot the screen-rotation ,just including 'Portrait','PortraitUpsideDown','LandscapeLeft','LandscapeRight'. For example , if your project initialed with Portrait-type, it will also show in center of the screen ,and change appropriate angle by-itself,but if your project initialed with other types , the screen rotation will be limited except the HUD dismissed . At last but not least , You need let your 'Controller' inherits 'JHB_HUDTopViewController', and then it can be run !
 At last, I will tell you that I hope you can support me always ,becasue it's main reason I can go down all the way .And I will keep improving and perfecting it ,Thanks for reading .
 */
/// --- --- --- > 0.1.5 --- --- --- ///
/*
 New For Attention:
 Before 0.1.5,no matter normal-hud-type or diy-hud-type,This part of coreView is showed on another new Window ,So it's abrupted from Your coreView which's on Your coreWindo.So ,if a process that decide the show-HUD progress is seized up,it means the whole APP-progress is stopped. But ,it's also a good way to suit to the screen-rotation.So ,after 0.1.5, you can use 'ifCanBeMoved' to control that if it can be dismissed by longpress-gesture.
 After 0.1.5 ,it's expended with another system that can be added on A custom-view for each method.So its also can be controlled by your custom object.And the hide of the func is'n changed.
 */


import UIKit
/*
 There are nine 'HUDTypes' for coreview-hud's display provided,including 'Deafault','ShowImmediately','ShowSlightly','ShowFromBottomToTop','ShowFromTopToBottom','ShowFromLeftToRight','ShowFromRightToLeft','ScaleFromInsideToOutside','ScaleFromOutsideToInside' .
 */
public enum HUDType {
    /**Default**/
    case kHUDTypeDefaultly/*默认*/
    /**Show And Hide**/
    case kHUDTypeShowImmediately/*马上出现,没有延时*/
    case kHUDTypeShowSlightly/*淡入淡出,延时效果*/
    /**Top And Bottom**/
    case kHUDTypeShowFromBottomToTop/*从底部到顶部并有默认效果*/
    case kHUDTypeShowFromTopToBottom/*从顶部到底部并有默认效果*/
    /**Left And Right**/
    case kHUDTypeShowFromLeftToRight/*从左边到右边并有默认效果*/
    case kHUDTypeShowFromRightToLeft/*从右边到左边并有默认效果*/
    /**Inside And Outside**/
    case kHUDTypeScaleFromInsideToOutside/*从内部向外部放大*/
    case kHUDTypeScaleFromOutsideToInside/*从外部向内部缩小*/
}

/*********➕NewAddition➕NewAddition➕NewAddition➕*********/
/*
 There are four 'DiyHUDTypes' for diy-image's display provided,including 'Deafault','RotateWithY','RotateWithZ','ShakeWithX' .
 */
public enum DiyHUDType {
    
    case kDiyHUDTypeDefault/*默认*/
    case kDiyHUDTypeRotateWithY/*Y轴旋转*/
    case kDiyHUDTypeRotateWithZ/*Z轴旋转*/
    case kDiyHUDTypeShakeWithX/*Y轴左右摇晃*/

}

var hud = JHB_HUDManager()
var diyHud = JHB_HUDDiyManager()
open class JHB_HUDView:NSObject{
    
    /// --- Decide HUD-process can be stopped by Long-tap-gesture.
    open class func ifCanBeMoved(bool:Bool) {
        hud.ifBeMoved(bool:bool)
        diyHud.ifBeMoved(bool:bool)
    }
    
    /*************✅显示进程************/
    /// --- new window --- ///
    open class func showProgress(){
        hud = JHB_HUDManager.init()
        hud.showProgress(ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showProgress(to:UIView){
        hud = JHB_HUDManager.init()
        hud.showProgress(ifCustom:true,to:to)
    }
    
    /***********✅显示进程+HUDType**********/
    /// --- new window --- ///
    open class func showProgressWithType(_ HudType:HUDType){
        hud = JHB_HUDManager.init()
        hud.showProgressWithType(HudType,ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showProgressWithType(_ HudType:HUDType,to:UIView){
        hud = JHB_HUDManager.init()
        hud.showProgressWithType(HudType,ifCustom:false, to: to)
    }
    
    /**********✅显示进程及信息************/
    /// --- new window --- ///
    open class func showProgressMsg(_ msg:NSString) {
        hud = JHB_HUDManager.init()
        hud.showProgressMsgs(msg,ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showProgressMsg(_ msg:NSString,to:UIView) {
        hud = JHB_HUDManager.init()
        hud.showProgressMsgs(msg,ifCustom:true,to:to)
    }
    
    /*********✅显示进程及信息+HUDType*********/
    /// --- new window --- ///
    open class func showProgressMsgWithType(_ msg:NSString,HudType:HUDType){
        hud = JHB_HUDManager.init()
        hud.showProgressMsgsWithType(msg, HudType: HudType,ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showProgressMsgWithType(_ msg:NSString,HudType:HUDType,to:UIView){
        hud = JHB_HUDManager.init()
        hud.showProgressMsgsWithType(msg, HudType: HudType,ifCustom:true,to:to)
    }
    
    /***********✅显示单行信息(自行执行Hide)**********/
    /// --- new window --- ///
    open class func showMsg(_ msg:NSString) {
        hud = JHB_HUDManager.init()
        hud.show(msg, ifCustom: false, to: UIView())
    }
    /// --- custom --- ///
    open class func jhb_showMsg(_ msg:NSString,to:UIView) {
        hud = JHB_HUDManager.init()
        hud.show(msg, ifCustom: true, to: to)
    }
    
    /********✅显示单行信息(自行执行Hide)+HUDType**********/
    /// --- new window --- ///
    open class func showMsgWithType(_ msg:NSString,HudType:HUDType) {
        hud = JHB_HUDManager.init()
        hud.showWithType(msg, HudType: HudType, ifCustom: false, to: UIView())
    }
    /// --- custom --- ///
    open class func jhb_showMsgWithType(_ msg:NSString,HudType:HUDType,to:UIView) {
        hud = JHB_HUDManager.init()
        hud.showWithType(msg, HudType: HudType, ifCustom: true, to: to)
    }
    /************✅显示多行信息(自行执行Hide)************/
    /// --- new window --- ///
    open class func showMsgMultiLine(_ msg:NSString, coreInSet: CGFloat, labelInSet: CGFloat, delay: Double) {
        hud = JHB_HUDManager.init()
        hud.showMultiLine(msg, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay,ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showMsgMultiLine(_ msg:NSString, coreInSet: CGFloat, labelInSet: CGFloat, delay: Double,to:UIView) {
        hud = JHB_HUDManager.init()
        hud.showMultiLine(msg, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay,ifCustom:true,to:to)
    }
    
    /*********✅显示多行信息(自行执行Hide)+HUDType***********/
    /// --- new window --- ///
    open class func showMsgMultiLineWithType(_ msg:NSString, coreInSet: CGFloat, labelInSet: CGFloat, delay: Double ,HudType:HUDType) {
        hud = JHB_HUDManager.init()
        hud.showMultiLineWithType(msg, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay, HudType: HudType,ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showMsgMultiLineWithType(_ msg:NSString, coreInSet: CGFloat, labelInSet: CGFloat, delay: Double ,HudType:HUDType,to:UIView) {
        hud = JHB_HUDManager.init()
        hud.showMultiLineWithType(msg, coreInSet: coreInSet, labelInSet: labelInSet, delay: delay, HudType: HudType,ifCustom:true,to:to)
    }
    
    /*********✅HIDE隐藏并移除(Pre + HUDType)**********/
    /*
     In current method lists ,there are two methods can hide your HUD, but it is different from each other , this one can only be used when you created HUD without diy-image
     */
    open class func hideProgress() {
        hud.hideProgress()
    }
    
    
    /*********➕NewAddition➕NewAddition➕NewAddition➕*********/
    
    
    /*
     There are four new methods can be used according to your demand , And those are basic of previous methods , Like these on the top , So each of method also has the param - 'HudType',as you know ,is shows the coreview display and dismiss's type.and except for that, there are some other params you should know well.So then I will give you the detail of each of them !And attention that if you want wo show a group of images ,there will be no 'diyHudType' can be selected !
     */
    
    /**********✅自定义展示图片+HUDType*********/
    /*
        -- img:the image file that you want to show ,it can be your program's logo or company's logo, etc.And attention that you can just delivery the image's name without suffix .
        -- diySpeed:if you set animation for your diy-image ,this param will limit your animation-speed .
        -- diyHudType:it comes from the enum 'DiyHUDType',it improve four types of diy-image's animation that you can choose .
     */
    /// --- new window --- ///
    open class func showProgressOfDIYTypeWith(_ img:NSString,diySpeed:CFTimeInterval,diyHudType:DiyHUDType, HudType:HUDType) {
        diyHud = JHB_HUDDiyManager.init()
        diyHud.showDIYProgressWithType(img,diySpeed:diySpeed, diyHudType: diyHudType, HudType: HudType,ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showProgressOfDIYTypeWith(_ img:NSString,diySpeed:CFTimeInterval,diyHudType:DiyHUDType, HudType:HUDType,to:UIView) {
        diyHud = JHB_HUDDiyManager.init()
        diyHud.showDIYProgressWithType(img,diySpeed:diySpeed, diyHudType: diyHudType, HudType: HudType,ifCustom:true,to:to)
    }
    /**********✅自定义展示图片+AnimationType+HUDType*********/
    /*
     -- imgsName:if you want show animation created by a group of images,you can pinpoint the images' main name that can be without suffix .
     -- imgsNumber:this param will let it knows that how many images will be showed ,it can not be null .
     -- diySpeed:this param will limit your animation-speed.
     */
    /// --- new window --- ///
    open class func showProgressOfDIYTypeWithAnimation(_ imgsName:NSString,imgsNumber:NSInteger,diySpeed:TimeInterval, HudType:HUDType){
        diyHud = JHB_HUDDiyManager.init()
        diyHud.showDIYProgressAnimated(imgsName,imgsNumber:imgsNumber,diySpeed:diySpeed, HudType:HudType,ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showProgressOfDIYTypeWithAnimation(_ imgsName:NSString,imgsNumber:NSInteger,diySpeed:TimeInterval, HudType:HUDType,to:UIView){
        diyHud = JHB_HUDDiyManager.init()
        diyHud.showDIYProgressAnimated(imgsName,imgsNumber:imgsNumber,diySpeed:diySpeed, HudType:HudType,ifCustom:true,to:to)
    }
    
    /**********✅自定义展示图片和信息+HUDType**********/
    /*
     -- msg:display the message that you need to show .
     -- img:the image file that you want to show ,it can be your program's logo or company's logo, etc.And attention that you can just delivery the image's name without suffix .
     -- diySpeed:if you set animation for your diy-image ,this param will limit your animation-speed .
     -- diyHudType:it comes from the enum 'DiyHUDType',it improve four types of diy-image's animation that you can choose .
     */
    /// --- new window --- ///
    open class func showProgressMsgOfDIYTypeWith(_ msg:NSString,img:NSString,diySpeed:CFTimeInterval,diyHudType:DiyHUDType, HudType:HUDType) {
        diyHud = JHB_HUDDiyManager.init()
        diyHud.showDIYProgressMsgsWithType(msg,img:img,diySpeed:diySpeed,diyHudType:diyHudType, HudType: HudType,ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showProgressMsgOfDIYTypeWith(_ msg:NSString,img:NSString,diySpeed:CFTimeInterval,diyHudType:DiyHUDType, HudType:HUDType,to:UIView) {
        diyHud = JHB_HUDDiyManager.init()
        diyHud.showDIYProgressMsgsWithType(msg,img:img,diySpeed:diySpeed,diyHudType:diyHudType, HudType: HudType,ifCustom:true,to:to)
    }
    /*********✅自定义展示图片和信息+AnimationType+HUDType**********/
    /*
     -- msg:display the message that you need to show .
     -- imgsName:if you want show animation created by a group of images,you can pinpoint the images' main name that can be without suffix .
     -- imgsNumber:this param will let it knows that how many images will be showed ,it can not be null .
     -- diySpeed:if you set animation for your diy-image ,this param will limit your animation-speed .
     */
    /// --- new window --- ///
    open class func showProgressMsgOfDIYTypeWithAnimation(_ msg:NSString,imgsName:NSString,imgsNumber:NSInteger, diySpeed:CFTimeInterval, HudType:HUDType) {
        diyHud = JHB_HUDDiyManager.init()
        diyHud.showDIYProgressMsgsAnimated(msg as NSString,imgsName:imgsName,imgsNumber:imgsNumber,diySpeed:diySpeed, HudType:HudType,ifCustom:false,to:UIView())
    }
    /// --- custom --- ///
    open class func jhb_showProgressMsgOfDIYTypeWithAnimation(_ msg:NSString,imgsName:NSString,imgsNumber:NSInteger, diySpeed:CFTimeInterval, HudType:HUDType,to:UIView) {
        diyHud = JHB_HUDDiyManager.init()
        diyHud.showDIYProgressMsgsAnimated(msg as NSString,imgsName:imgsName,imgsNumber:imgsNumber,diySpeed:diySpeed, HudType:HudType,ifCustom:true,to:to)
    }
    
    /*********✅自定义类型HIDE隐藏并移除+HUDType**********/
    /*
     In current method lists ,there are two methods can hide your HUD, but it is different from each other , this one can only be used when you created diy-image-type HUD
     */
    open class func hideProgressOfDIYType() {
        diyHud.hideProgress()
    }

}
