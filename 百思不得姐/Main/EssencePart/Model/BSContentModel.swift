//
//  BSContentModel.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/25.
//  Copyright © 2016年 bruce. All rights reserved.
//


import UIKit

class BSContentModel: NSObject {
    // MARK: 定义属性
    // ✅图片类型cell模型
    /************************************************/
    var create_time : String = ""// 创建时间
    var hate : String = ""// 讨厌
    var love : String = ""// 喜欢
    var ID : String = ""//id号❌
    
    var height : String = ""// 资源高度
    var width : String = ""// 资源宽度
    var image0 : String = ""
    var image1 : String = ""
    var image2 : String = ""
    var image3 : String = ""
    
    var type : String = ""// 类型
    var name : String = ""// 昵称
    var profile_image : String = ""// 头像
    var text : String = ""// 描述
    var weixin_url : String = ""// 网页路径
    // ✅视频类型cell模型
    /************************************************/
    var video_uri : String = ""// 视频路径
    var videotime : String = ""// 视频时长
    // ✅声音类型cell模型
    /************************************************/
    var voiceuri : String = ""// 声频路径
    var voicelength : String = ""// 声频长度
    var voicetime : String = ""// 声频时长
    
    // 视频首帧图片
    var _showImage = UIImage()// 声频时长

    
    // MARK:- 自定义构造函数
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key=="id" {
            self.ID = value as! String
        }
    }
    
}
