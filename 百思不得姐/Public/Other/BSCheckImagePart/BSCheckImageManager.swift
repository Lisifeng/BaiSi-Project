//
//  BSCheckImageManager.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/31.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import Foundation

protocol BSCheckImageManagerDelegate {
    /**
     *  获取一个和被点击的imageView一模一样(相同大小,图片相同)的UIImageView
     *
     *  @return 放大动画使用的UIImageView
     */

    func browserAnimateFirstShowImageView() -> UIImageView
    
    ///获取被点击cell相对于keywindow的frame
    func browserAnimationFromRect() -> CGRect

    
    /// 获取被点击cell中的图片, 将来在图片浏览器中显示的尺寸
    func browserAnimationToRect() -> CGRect
    
    /**
     *  获得结束时显示的UIImageView,缩小动画使用的UIImageView
     */
    func browserAnimateEndShowImageView() -> UIImageView
    
    /**
     *  消失时位置,最终动画在这个rect区域消失.
     */
    func browserAnimateEndRect() -> CGRect

}

class BSCheckImageManager: NSObject,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var presented = Bool()
    var delegate : BSCheckImageManagerDelegate?
    var cover = UIView()
    var transitionInterval : TimeInterval = 0.5
    
    
    //MARK ------------------------------------------
    //MARK : - UIViewControllerTransitioningDelegate
    ///该代理方法用于返回负责转场的控制器对象
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        /**
         创建一个负责管理自定义转场动画的控制器
         
         - parameter presentedViewController:  被弹出的控制(菜单)
         - parameter presentingViewController: 发起modal的 源控制器
         Xocde7以前系统传递给我们的是nil, Xcode7开始传递给我们的是一个野指针
         
         - returns: 负责管理自定义转场动画的控制器
         */
        return UIPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
    
    /// 该代理方法用于告诉系统谁来负责控制器如何弹出
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presented = true
        return self
    }
    
    /// 该代理方法用于告诉系统谁来负责控制器如何消失
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presented = false
        return self
    }
    
    //MARK ------------------------------------------
    //MARK : - UIViewControllerAnimatedTransitioning
    ///用于返回动画的时长, 默认用不上
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    /// 该方法用于负责控制器如何弹出和如何消失
    // 只要是自定义转场, 控制器弹出和消失都会调用该方法
    // 需要在该方法中告诉系统控制器如何弹出和如何消失
    
    // 注意点: 但凡告诉系统我们需要自己来控制控制器的弹出和消失
    // 也就是实现了代理UIViewControllerAnimatedTransitioning的方法之后, 那么系统就不会再控制我们控制器的动画了, 所有的操作都需要我们自己完成
    
    // 系统调用该方法时会传递一个transitionContext参数, 该参数中包含了我们所有需要的值
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presented == true { //弹出
            self.animatePresentedController(transitionContext: transitionContext)
        }else{
            self.animateDismissedController(transitionContext: transitionContext)
        }

    }
    
    
    //MARK ------------------------------------------
    //MARK : - private
    /// 弹出动画
    func animatePresentedController(transitionContext:UIViewControllerContextTransitioning) {
        assert(self.delegate != nil, "必须有代理对象才能执行动画")
        self.addCover()
        //1.得到当前点击的imageView
        let imageView = self.delegate?.browserAnimateFirstShowImageView()
        imageView?.layer.masksToBounds = true
        //2.设置初始frame
        imageView?.frame = (self.delegate?.browserAnimationFromRect())!
        //3.将新建的UIImageView添加到容器视图上
        transitionContext.containerView.addSubview(imageView!)
        //4.执行动画,使imageView放大到最大
        let toRect = (self.delegate?.browserAnimationToRect())!
        UIView.animate(withDuration: transitionInterval, animations: {
            imageView?.frame = toRect
            }) { (true) in
                UIView.animate(withDuration: 0.25, animations: { 
                    //5.移除imageView(新添加的imageView的使命就是让用户看到这个动画过程),不然遮挡browser,collectionView不能滑动
                    imageView?.removeFromSuperview()
                    //6.添加原来的图片浏览器
                    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
                    
                    transitionContext.containerView.addSubview(toView!)
                    }, completion: { (true) in
                        //7.通知系统,动画执行完毕
                        //注意点: 但凡是自定义转场, 一定要在自定义动画完成之后告诉系统动画已经完成了, 否则会出现一些未知异常
                        transitionContext.completeTransition(true)
                })
        }
        
    }
    
    
    /// 隐藏动画
    func animateDismissedController(transitionContext:UIViewControllerContextTransitioning) {
        let imageView = self.delegate?.browserAnimateEndShowImageView()
        imageView?.frame = (self.delegate?.browserAnimationToRect())!
        imageView?.layer.masksToBounds = true
        transitionContext.containerView.addSubview(imageView!)
        let endRect = self.delegate?.browserAnimateEndRect()
        let browserVcView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        browserVcView?.removeFromSuperview()
        self.dismissCover()
        UIView.animate(withDuration: transitionInterval, animations: { 
            imageView?.frame = endRect!
            }) { (true) in
                imageView?.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
    
    func addCover() {
        cover = UIView.init(frame: UIScreen.main.bounds)
        cover.backgroundColor = UIColor.black
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(cover)
    }
    
    func dismissCover() {
        cover.removeFromSuperview()
    }
    
}
