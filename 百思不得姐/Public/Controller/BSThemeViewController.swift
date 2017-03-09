//
//  BSThemeViewController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/17.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

class BSThemeViewController: UIViewController,BSNavgationViewButtonClickedDelegate,BSTopListViewTopicDelegate{
    //MARK: - 参数
    var bsNavigationBar = BSNavgationView()
    var statusBGView = UIView.init()
    var topListView = BSTopListView()
    
    //MARK: - Interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true;
        statusBGView = UIView.init(frame: UIApplication.shared.statusBarFrame)
        statusBGView.backgroundColor = BSColor.themeColor()
        
        self.addCustomNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (!bsNavigationBar.isEqual(nil) && !bsNavigationBar.isHidden){
            self.view.bringSubview(toFront: statusBGView)
            self.view.bringSubview(toFront: bsNavigationBar)
            self.view.bringSubview(toFront: topListView)
        }
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - 添加自定义及设置相关
    func addCustomNavigationBar() {
        
        self.view.addSubview(statusBGView)
        
        bsNavigationBar = BSNavgationView.init(frame: CGRect.init(x: 0, y: BSStatusHeight, width: ScreenWidth, height: (self.navigationController?.navigationBar.bounds.size.height)!))
        bsNavigationBar.delegate = self
        bsNavigationBar.setTitle("题目")
        self.view.addSubview(bsNavigationBar)

        topListView = BSTopListView.init(frame: CGRect.init(x: 0, y: BSStatusHeight, width: ScreenWidth-55, height: (self.navigationController?.navigationBar.bounds.size.height)!))
        topListView.isHidden = true
        topListView.delegate = self
        self.view.addSubview(topListView)
    }
    
    
    
    //MARK - BSNavgationViewButtonClickedDelegate
    // ←
    func BSNavgationViewButtonClickedWithLeftSide(_ sender:UIButton){
        
    }
    // →
    func BSNavgationViewButtonClickedWithRightSide(_ sender:UIButton){
        
    }
    
    //#MARK - BSTopListViewTopicDelegate
    func BSTopListViewTopicBtnClicked(_ sender:UIButton){
        JBLog("")
    }
}

//MARK: - 设置标题与返回
extension BSThemeViewController{
    
    // 设置标题
    func title(_ title:NSString) {
        bsNavigationBar.setTitle(title)
    }
    
    // 设置返回按钮
    func back(_ backTitle:NSString) {
        if backTitle == "" {
            let backBtn = UIButton.init(type: UIButtonType.custom)
            backBtn.setImage(UIImage.init(named: "back_image"), for: UIControlState.normal)
            backBtn.addTarget(self, action: #selector(BSThemeViewController.backToBefore), for: UIControlEvents.touchUpInside)
            backBtn.sizeToFit()
            backBtn.frame = CGRect.init(x: 15, y: (self.bsNavigationBar.bounds.size.height-backBtn.bounds.size.height)/2, width: backBtn.bounds.size.width, height: backBtn.bounds.size.height)
            self.bsNavigationBar.addSubview(backBtn)
        }
    }

    func backToBefore() {
        self.navigationController!.popViewController(animated: true)
    }
}

//MARK: - 设置左右诸按钮
extension BSThemeViewController{
    func leftBtns(_ btns:NSArray) {
        bsNavigationBar.setButtonsPartOf(btns, btnPType: ButtonPositionType.kButtonPositionTypeLeft)
    }
    
    func rightBtns(_ btns:NSArray) {
        bsNavigationBar.setButtonsPartOf(btns, btnPType: ButtonPositionType.kButtonPositionTypeRight)
    }
}
