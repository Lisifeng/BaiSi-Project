//
//  BSpch.swift
//  mySDK
//
//  Created by Leon_pan on 16/8/19.
//  Copyright © 2016年 bruce. All rights reserved.
//

import Foundation
import UIKit
// 实现自己的打印方法
/// 打印log， 格式: [时间(精确到毫秒)][文件名(类名) 方法名]: log message
func JBLog<T>(_ log: T?, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    
    let className = (fileName as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "", options: String.CompareOptions.backwards, range: nil)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let dateString = formatter.string(from: Date())
    
    
    #if DEBUG
        
        if let logMessage = log
        {
            print("\n[\(dateString)] [\(className) \(methodName)]: \n\(logMessage)")
        }
        else
        {
            print("\n[\(dateString)] [\(className) \(methodName)]: \n\(String(describing: log))")
        }
    #endif
}
// 屏幕宽高
let ScreenWidth : CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight : CGFloat = UIScreen.main.bounds.size.height

// 颜色管家
let BSColor = UIColor.init()

// 文件管家
let BSFileManager = FileManager.init()

// URL管家
let BSUrl = NSURL.init()

// 通用常规间距
let BSUsualmargin = 15

// 自定义导航高度
let BSNavHeight : CGFloat = 60

// 系统状态栏高度
let BSStatusHeight : CGFloat = UIApplication.shared.statusBarFrame.height

//// NAV控制器下顶部高度
//let BSNavTOPHeight : CGFloat = BSStatusHeight+BSNavHeight

// 百思TabBar高度
let BSTabBarHeight : CGFloat = BSTabBarController().TabBarHeight()


// 当前系统版本
let CurrentVersion = UIDevice.current.systemVersion.hashValue

// 手机型号
let KDEVICE_IS_IPHONE4_4S = (UIScreen.main.bounds.size.height == 480)
let KDEVICE_IS_IPHONE5_5S = (UIScreen.main.bounds.size.height == 568)
let KDEVICE_IS_IPHONE6_6S = (UIScreen.main.currentMode?.size)!.equalTo(CGSize.init(width: 750, height: 1334))
let KDEVICE_IS_IPHONE6_6S_PLUS = (UIScreen.main.currentMode?.size)!.equalTo(CGSize.init(width: 1242, height: 2208))


// 百思appid
let BSAPPID = "25538"
let BSAPPKEY = "7c85d8989bc642538cac106fb33e8d9b"
let BSAPPARRESS = "http://route.showapi.com/255-1"
