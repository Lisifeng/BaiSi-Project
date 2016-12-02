/****************** JHB_HUDTopViewController.swift ****************/
/*******  (JHB)  ************************************************/
/*******  Created by Leon_pan on 16/8/22. ***********************/
/*******  Copyright © 2016年 CoderBala. All rights reserved.*****/
/****************** JHB_HUDTopViewController.swift ****************/

import UIKit
class JHB_HUDTopViewController: UIViewController{
    // MARK: - Params
    var kIfCanRotated: Bool = true
    var orientation = UIDevice.current.orientation
    
    // MARK: - Interface
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDTopViewController.cannotRotate(_:)), name: NSNotification.Name(rawValue: "JHB_HUDTopVcCannotRotated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDTopViewController.canRotate), name: NSNotification.Name(rawValue: "JHB_HUDTopVcCanRotated"), object: nil)
        
    }
    
    // MARK: - 处理通知
    func cannotRotate(_ noti:Notification) {
        
        let kOrientation = noti.object as! CGFloat
        if kOrientation == 1 {
            orientation = .portrait
        }else if kOrientation == 2 {
            orientation = .portraitUpsideDown
        }else if kOrientation == 3 {
            orientation = .landscapeLeft
        }else if kOrientation == 4 {
            orientation = .landscapeRight
        }
        
        kIfCanRotated = false
        self.shouldAutorotate
        self.supportedInterfaceOrientations

    }
    
    func canRotate() {
        kIfCanRotated = true
        self.shouldAutorotate
        self.supportedInterfaceOrientations
    }
  
    // MARK: - 重写旋转方法
    // ❤️这是在当前使用的控制器中应该使用的重写方法,以阻止旋转后重新实现旋转
    override var shouldAutorotate : Bool {
    
        if kIfCanRotated == true {
            return true
        }else if kIfCanRotated == false {
            return false
        }
        return true
    }

    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if kIfCanRotated == true {
            return .all
        }else if kIfCanRotated == false {

            if orientation == .portrait {
                return .portrait
            }else if orientation == .portraitUpsideDown {
                return .portraitUpsideDown
            }else if orientation == .landscapeLeft {
                return .landscapeLeft
            }else if orientation == .landscapeRight {
                return .landscapeRight
            }
        }
        return .all
    }
    
}
