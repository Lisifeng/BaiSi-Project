//
//  BSContentModel.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/25.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import AVFoundation

class BSContentModel: NSObject {
    
    // ✅图片类型cell模型
    /************************************************/
    let createTime = "create_time"// 创建时间
    let hate = "hate"// 讨厌
    let love = "love"// 喜欢
    let ID = "id"//id号
    
    let height = "height"// 资源高度
    let width = "width"// 资源宽度
    let image0 = "image0"
    let image1 = "image1"
    let image2 = "image2"
    let image3 = "image3"

    let type = "type"// 类型
    let name = "name"// 昵称
    let profile_image = "profile_image"// 头像
    let text = "text"// 描述
    let weixin_url = "weixin_url"// 网页路径
    // ✅视频类型cell模型
    /************************************************/
    let videoUri = "video_uri"// 视频路径
    let videotime = "videotime"// 视频时长
    // ✅声音类型cell模型
    /************************************************/
    let voiceuri = "voiceuri"// 声频路径
    let voicelength = "voicelength"// 声频长度
    let voicetime = "voicetime"// 声频时长
    
    var _create_time : NSString = ""
    var _hate : NSString = ""
    var _love : NSString = ""
    var _ID : NSString = ""
    
    var _height : NSString = ""
    var _width : NSString = ""
    var _image0 : NSString = ""
    var _image1 : NSString = ""
    var _image2 : NSString = ""
    var _image3 : NSString = ""
    
    var _type : NSString = ""
    var _name : NSString = ""
    var _profile_image : NSString = ""
    var _text : NSString = ""
    
    var _videotime : NSString = ""
    var _videoUri : NSString = ""
    
    var _voicetime : NSString = ""
    var _voiceuri : NSString = ""
    var _voicelength : NSString = ""
    
    var _weixin_url : NSString = ""
    var _showImage : UIImage = UIImage.init()
    
    
    
    
    //MARK: -  Init
    
    func initWithDict(Dic:NSDictionary) -> BSContentModel {
       
        
        if !self.isEqual(nil) {

        
            /*
            let property = propertyKey?[Int(i)]                                         //获取模型中的某一个属性
            
            let propertyType = String(cString: property_getAttributes(property))  //属性类型
            
            let propertyKey = String(cString: property_getName(property))         //属性名称
            */
                
            // ✅图片类型cell模型
                /************************************************/
            var value : AnyObject
            
            value = Dic.object(forKey: createTime) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: createTime)! as AnyObject
                self._create_time = value.description as NSString
            }
            
            value = Dic.object(forKey: hate) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: hate)! as AnyObject
                self._hate = value.description as NSString
            }
            
            value = Dic.object(forKey: love) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: love)! as AnyObject
                self._love = value.description as NSString
            }
            
            value = Dic.object(forKey: ID) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: ID)! as AnyObject
                self._ID = value.description as NSString
            }
            
            value = Dic.object(forKey: height) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: height)! as AnyObject
                self._height = value.description as NSString
            }
            
            value = Dic.object(forKey: width) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: width)! as AnyObject
                self._width = value.description as NSString
            }
            
            value = Dic.object(forKey: image0) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: image0)! as AnyObject
                self._image0 = value.description as NSString
            }
            
            value = Dic.object(forKey: image1 ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: image1)! as AnyObject
                self._image1 = value.description as NSString
            }
            
            value = Dic.object(forKey: image2 ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: image2)! as AnyObject
                self._image2 = value.description as NSString
            }
            
            value = Dic.object(forKey: image3 ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: image3)! as AnyObject
                self._image3 = value.description as NSString
            }
            
            value = Dic.object(forKey: type ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: type)! as AnyObject
                self._type = value.description as NSString
            }
            
            value = Dic.object(forKey: name ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: name)! as AnyObject
                self._name = value.description as NSString
            }
            
            value = Dic.object(forKey: profile_image ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: profile_image)! as AnyObject
                self._profile_image = value.description as NSString
            }
            
            value = Dic.object(forKey: text ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: text)! as AnyObject
                self._text = value.description as NSString
            }
            
            value = Dic.object(forKey: weixin_url ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: weixin_url)! as AnyObject
                self._weixin_url = value.description as NSString
            }
            
            // ✅视频类型cell模型
            /************************************************/
            value = Dic.object(forKey: videoUri ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: videoUri)! as AnyObject
                self._videoUri = value.description as NSString
                /*
                DispatchQueue.global().async {
                    print("开一条全局队列异步执行任务")
                    let showImage = self.getShowImageForAwhileWith(url:self._videoUri)
                    DispatchQueue.main.async {
                        print("在主队列执行任务")
                        self._showImage = showImage
                    }
                }
                 */
            }
            value = Dic.object(forKey: videotime ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: videotime)! as AnyObject
                self._videotime = value.description as NSString
                
            }
            
            // ✅声音类型cell模型
            /************************************************/
            value = Dic.object(forKey: voicetime ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: voicetime)! as AnyObject
                self._voicetime = value.description as NSString
            }
            
            value = Dic.object(forKey: voiceuri ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: voiceuri)! as AnyObject
                self._voiceuri = value.description as NSString
            }
            
            value = Dic.object(forKey: voicelength ) as AnyObject
            if (value.description != "nil") {
                value = Dic.object(forKey: voicelength)! as AnyObject
                self._voicelength = value.description as NSString
            }
            
            
            
        }
        
        
        return self
    }
    //MARK: - 获取某一帧图片
    func getShowImageForAwhileWith(url:NSString) -> UIImage {
        
        let asset: AVURLAsset = AVURLAsset.init(url: URL.init(string: url as String)!, options: nil)
        let gen: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMakeWithSeconds(1, 1)
        var actualTime: CMTime = CMTimeMake(0, 0)
        var resultImage: UIImage = UIImage()
        do {
            let image: CGImage = try gen.copyCGImage(at: time, actualTime: &actualTime)
            resultImage = UIImage(cgImage: image)
        } catch { }
        return resultImage
 
    }
    //MARK: - 获取cell高度
    func cellHeight() -> CGFloat {
        var cellH : CGFloat = 0.0
        
        cellH = cellH + 5
        let nameLabelSize = self._name.size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 9)])
        let timeLabelSize = self._create_time.size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 8)])
        cellH = cellH + nameLabelSize.height + timeLabelSize.height + 10
        let markLabelSize = self._text.size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)])
        cellH = cellH + markLabelSize.height + 200 + 10 + 5
        
        return cellH
    }
    
}
