//
//  BSColor.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/14.
//  Copyright © 2016年 bruce. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    //MARK: - 十六进制返回颜色
    func colorWithHex(_ hexValue:u_long) ->  UIColor{
        
        let red = ((Float)((hexValue & 0xFF0000) >> 16))/255.0;
        let green = ((Float)((hexValue & 0xFF00) >> 8))/255.0;
        let blue = ((Float)(hexValue & 0xFF))/255.0;
        let ResultColor = UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
        return ResultColor
    }
    //MARK: - 十六进制与透明度返回颜色
    func colorWithHexAlpha(_ hexValue:u_long,alpha:CGFloat) -> UIColor {
        let red = ((Float)((hexValue & 0xFF0000) >> 16))/255.0;
        let green = ((Float)((hexValue & 0xFF00) >> 8))/255.0;
        let blue = ((Float)(hexValue & 0xFF))/255.0;
        let ResultColor = UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: Float(alpha))
        return ResultColor
    }
    //MARK: - RGB与透明度返回颜色
    func colorWithRGBAlpha(_ red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        let resultColor = UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
        return resultColor
    }
    //MARK: - 主体颜色
    func themeColor() -> UIColor {
        let themecolor = self.colorWithHex(0xFF1860)
        return themecolor
    }
    //MARK: - 主题字体颜色
    func themeCharacterColor() -> UIColor {
        let themecharactercolor = self.colorWithHex(0xFFFFFF)
        return themecharactercolor
    }
    //MARK: - 主题tabBar文字颜色
    func themeBottomBarTitleNormalColor() -> UIColor {
        let resultColor = self.colorWithHex(0xC0C0C0)
        return resultColor
    }
    
    
}
