//
//  BSTabBarController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/13.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

class BSTabBarController: UITabBarController,BSTabBarDelegate{
    //MARK: - 参数
    let childV = UIView.init()
    var customTabBar = BSTabBar()
    let essenceVc = EssenceViewController()
    let newestVc = NewestViewController()
    let releaseVc = ReleaseViewController()
    let concernVc = ConcernViewController()
    let meVc = MeViewController()
        
    //MARK: - interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = false
        self.setupCustomTabBar()

        self.tabBar.backgroundImage = UIImage.init();
        self.tabBar.shadowImage = UIImage.init();
        self.setupAllChildController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.bringSubview(toFront: self.customTabBar)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = UIView()
        for childV in self.tabBar.subviews {
            if childV.isKind(of: UIControl.self) {
                childV.removeFromSuperview()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 自定义tabBar
    func setupCustomTabBar() {
        
        let TabBarHeight = self.tabBar.bounds.size.height
        
        self.customTabBar = BSTabBar.init(frame: CGRect.init(x: 0, y:0, width: ScreenWidth, height: TabBarHeight))
        self.customTabBar.delegate = self
        self.tabBar.addSubview(self.customTabBar)
    }
    
    
    func TabBarHeight() -> CGFloat {
        return self.customTabBar.bounds.size.height
    }
    
   
}

//MARK: - 添加子控制器
extension BSTabBarController{
    func setupAllChildController() {
        let nav1 = BSPublicNavController.init(rootViewController: essenceVc)
        self.addChildViewController(nav1)
        
        let nav2 = BSPublicNavController.init(rootViewController: newestVc)
        self.addChildViewController(nav2)
        
        //        let nav3 = BSPublicNavController.init(rootViewController: releaseVc)
        //        self.addChildViewController(nav3)
        
        let nav4 = BSPublicNavController.init(rootViewController: concernVc)
        self.addChildViewController(nav4)
        
        let nav5 = BSPublicNavController.init(rootViewController: meVc)
        self.addChildViewController(nav5)
        
    }
}

//MARK: - BSTabBarDelegate
extension BSTabBarController{
    func TabBarItemClicked(_ Tag:NSInteger){
        switch Tag {
        case 1:
            self.selectedIndex = Tag-1
            break
        case 2:
            self.selectedIndex = Tag-1
            break
        case 3:
            // 弹出瀑布流选项控制器
            let releaseVc = BSReleaseItemsView.init(frame: CGRect.zero)
            releaseVc.showIn()
            JBLog("弹出瀑布流选项控制器✅")
            break
        case 4:
            self.selectedIndex = Tag-2
            break
        case 5:
            self.selectedIndex = Tag-2
            break
            
        default:
            JBLog("(错误)超出范围!")
            break
            
        }
    }
}
