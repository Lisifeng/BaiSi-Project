//
//  JHB_HUDPublicManager.swift
//  testHUD
//
//  Created by Leon_pan on 16/11/5.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

public class JHB_HUDPublicManager: UIView {

    // MARK: parameters
    fileprivate  var windowsTemp: [UIWindow] = []
    fileprivate  var timer: DispatchSource?
    let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    /*之前的屏幕旋转类型*//*The Screen Rotation Type Of Previous*/
    var PreOrientation = UIDevice.current.orientation
    /*初始化的屏幕旋转类型*//*The Screen Rotation Type Of Initial-status*/
    var InitOrientation = UIDevice.current.orientation
    /*核心视图尺寸*//*The Frame Of Core View Part*/
    var coreViewRect  = CGRect()
    /*核心视图内部统一间隔*//*The Uniformed Margin Inside Core View Part*/
    var kMargin : CGFloat = 10
    /*定义当前类型*//*Define Current Type*/
    var type : NSInteger = 0
    
    
    // MARK: About Screen Rotation
    // 1⃣️Remove Notification
    func RemoveNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 2⃣️register Notification
    func registerDeviceOrientationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.transformWindow(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // 3️⃣Transform Of Screen
    @objc func transformWindow(_ notification: Notification) {
        var rotation: CGFloat = 0
        if self.InitOrientation == .portrait{
            if self.PreOrientation == .portrait {
                switch UIDevice.current.orientation {
                case .portrait:
                    rotation = 0
                case .portraitUpsideDown:
                    rotation = CGFloat.pi
                case .landscapeLeft:
                    rotation = CGFloat.pi/2
                case .landscapeRight:
                    rotation = CGFloat.pi * 3 / 2
                default:
                    break
                }
            }else if self.PreOrientation == .portraitUpsideDown {
                switch UIDevice.current.orientation {
                case .portrait:
                    rotation = 0
                case .portraitUpsideDown:
                    rotation = CGFloat.pi / 2
                case .landscapeLeft:
                    rotation = CGFloat.pi/2
                case .landscapeRight:
                    rotation = CGFloat.pi * 3 / 2
                default:
                    break
                }
            }else if self.PreOrientation == .landscapeLeft {
                switch UIDevice.current.orientation {
                case .portrait:
                    rotation = 0
                case .portraitUpsideDown:
                    rotation = CGFloat.pi
                case .landscapeLeft:
                    rotation = 0
                case .landscapeRight:
                    rotation = CGFloat.pi * 3 / 2
                default:
                    break
                }
            }else if self.PreOrientation == .landscapeRight {
                switch UIDevice.current.orientation {
                case .portrait:
                    rotation = 0
                case .portraitUpsideDown:
                    rotation = CGFloat.pi
                case .landscapeLeft:
                    rotation = CGFloat.pi / 2
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
        
        if ((UIApplication.shared.keyWindow?.subviews.first as UIView!) != nil) {
            let window = UIWindow()
            window.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            window.backgroundColor = UIColor.clear
            window.windowLevel = UIWindowLevelAlert
            window.center = self.getCenter()
            window.isHidden = false
            window.addSubview(self)
            windowsTemp.append(window)
        }else{
            self.type = HUDType.kHUDTypeShowSlightly.hashValue
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2){
                self.ResetWindowPosition()
            }
        }
        // 💖Pre
        /*
         let window = UIWindow()
         window.backgroundColor = UIColor.clear
         window.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.bounds.size.width)!,height: (UIApplication.shared.keyWindow?.bounds.size.height)!)
         window.windowLevel = UIWindowLevelAlert
         window.center = self.getCenter()
         window.isHidden = false
         window.addSubview(self)
         windowsTemp.append(window)
         */
    }
    
    
    func hideHud() {
        
    }

    
    // 
    public func ifBeMoved(bool:Bool) {
        
    }

    
    
}
