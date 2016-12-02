//
//  BSPublicNavController.swift
//  swiftTest2
//
//  Created by Leon_pan on 16/5/27.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

class BSPublicNavController: UINavigationController ,UIGestureRecognizerDelegate,UINavigationControllerDelegate{
    
    //MARK: - Interface
    override func viewDidLoad() {
        super.viewDidLoad()
        // ❤️通过这一步,可以实现被删除掉的侧滑功能!!!!❤️
        if self.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer!.delegate = self
        }
        
        self.navigationBar.isHidden = true
     }
    
    
    // ❤️1⃣️在重写pushViewController方法中来设置NavigationController下的根控制器的返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: true)
        /*
        // ❤️重写返回按钮
        if viewController.isKind(of: EssenceViewController.self) {
        }else {
            let newBackButton = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BSPublicNavController.back(_:)))
            
            viewController.navigationItem.leftBarButtonItem = newBackButton;
        }
         */
    }
    // ❤️2⃣️当然也可以在各个跟控制器中来设置新样式的navigationItem来代替原有的
    /*
     // ①隐藏原有
     self.navigationItem.hidesBackButton = true
     // ②创建新的
     let newBackButton = UIBarButtonItem(title: "<Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(publicNavController.back(_:)))
     // ③赋值替换
     self.navigationItem.leftBarButtonItem = newBackButton;
     */

    //#MARK - 修改状态栏相关
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - 返回
    func back(_ sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        self.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
