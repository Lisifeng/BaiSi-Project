//
//  BSCheckImageDetailView.swift
//  百思不得姐
//
//  Created by Bruce Jiang on 16/10/26.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import Kingfisher
class BSCheckImageDetailView: UIView,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    var topBtn = UIButton()
    var coreScrollView = BSCoreScrollView()
    var backBtn = UIButton()
    var saveBtn = UIButton()
    var transmitBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        if !self.isEqual(nil) {
            self.backgroundColor = BSColor.colorWithHex(0x000000)
            self.addSubViews()
            self.setSubViews()
//            self.setScrollEnableoTop(enable: true)
            self.alpha = 0.1
            UIView.animate(withDuration: 0.25, animations: {
                UIApplication.shared.keyWindow?.addSubview(self)
                self.alpha = 1
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setScrollEnableToTop(enable:Bool) {
        let windows = UIApplication.shared.windows
        _ = UIWindow.init()
        for window in windows {
            let subViews = window.subviews
            _ = UIView()
            for contentView in subViews {
                if contentView.isKind(of: BSCheckImageDetailView.self) {
                    self.coreScrollView.scrollsToTop = enable
                }else if (contentView.isKind(of: UIScrollView.self) || contentView.isKind(of: UITableView.self)){
                        (contentView as! UIScrollView).scrollsToTop = !enable
                    
                }
            }
        }
    }
    
    func addSubViews() {
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(BSCheckImageDetailView.back))
        coreScrollView = BSCoreScrollView.init(frame: UIScreen.main.bounds)
        coreScrollView.addGestureRecognizer(singleTap)
        
        backBtn = UIButton.init()
        backBtn.setImage(#imageLiteral(resourceName: "redBack_image.png"), for: UIControlState.normal)
        backBtn.layer.cornerRadius = 15
        backBtn.layer.borderWidth = 1
        backBtn.layer.borderColor = BSColor.colorWithHex(0xed2840).cgColor
        backBtn.layer.masksToBounds = true
        backBtn.setTitleColor(BSColor.colorWithHex(0xed2840), for: UIControlState.normal)
        backBtn.backgroundColor = BSColor.colorWithHexAlpha(0x000000, alpha: 0.3)
        backBtn.addTarget(self, action: #selector(BSCheckImageDetailView.back), for: UIControlEvents.touchUpInside)
        
        saveBtn = UIButton.init()
        saveBtn.layer.cornerRadius = 3
        saveBtn.layer.borderWidth = 1
        saveBtn.layer.borderColor = BSColor.colorWithHex(0xffffff).cgColor
        saveBtn.layer.masksToBounds = true
        saveBtn.setTitle("保存", for: UIControlState.normal)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        saveBtn.setTitleColor(BSColor.colorWithHex(0xffffff), for: UIControlState.normal)
        saveBtn.backgroundColor = BSColor.colorWithHexAlpha(0x000000, alpha: 0.7)
        saveBtn.addTarget(self, action: #selector(BSCheckImageDetailView.save), for: UIControlEvents.touchUpInside)
        saveBtn.sizeToFit()
        
        topBtn = UIButton.init()
        topBtn.backgroundColor = UIColor.clear
        topBtn.addTarget(self, action: #selector(BSCheckImageDetailView.scrollToTop), for: UIControlEvents.touchUpInside)
        
        self.addSubview(coreScrollView)
        self.addSubview(backBtn)
        self.addSubview(saveBtn)
        self.addSubview(topBtn)
    }
    
    func setSubViews() {
        topBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 20)
        coreScrollView.frame = self.bounds
        backBtn.frame = CGRect.init(x: 15, y: 35, width:30,height: 30)
        saveBtn.frame = CGRect.init(x: 15, y: ScreenHeight-saveBtn.bounds.size.height-10, width: saveBtn.bounds.size.width+20, height: saveBtn.bounds.size.height)
    }
    
    // MARK: - Response
    func scrollToTop() {
        print("点击了滚动到顶部")
        UIView.animate(withDuration: 0.25, animations: { 
            self.coreScrollView.frame.origin = CGPoint.init(x: 0, y: 0)
            }) { (true) in
        }
    }
    func back() {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: { 
            self.alpha = 0.1
            }) { (true) in
                 self.setScrollEnableToTop(enable: false)
                self.removeFromSuperview()
        }
    }
    
    func save() {
        UIImageWriteToSavedPhotosAlbum(self.coreScrollView._zoomImageView.image!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)// imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:
    }
    
// /Users/xsteach/Desktop/Personal Area/百思不得姐/百思不得姐/Public/View/BSCheckImageDetailView.swift:122:16: Method cannot be marked @objc because the type of the parameter 3 cannot be represented in Objective-C
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject){
        print("---")
        
        if error != nil {
            print(error)
            return
        }
        print("OK")
    }
    func displayImage(image:NSString) {
        
        self.coreScrollView._zoomImageView.kf.setImage(with:URL(string: image as String), placeholder: UIImage.init(named: "tabBar_aboutMeVc_selected_icon"), options: [.transition(ImageTransition.fade(1.0))], progressBlock: { receivedSize, totalSize in
            },completionHandler: { (image, error,cacheType, imageURL) in
        })

        let imageHeight = (self.coreScrollView._zoomImageView.image?.size.height)!
        
        
        if imageHeight <= ScreenHeight {
            self.coreScrollView.contentSize = CGSize.init(width: ScreenWidth, height: ScreenHeight)
            self.coreScrollView._zoomImageView.frame = CGRect.init(x: 0, y: (ScreenHeight-imageHeight)/2, width: ScreenWidth, height: imageHeight)
        }else{
            self.coreScrollView.contentSize = CGSize.init(width: (self.coreScrollView._zoomImageView.image?.size.width)!, height: (self.coreScrollView._zoomImageView.image?.size.height)!)
            self.coreScrollView._zoomImageView.frame = CGRect.init(x: 0, y: 0, width: (self.coreScrollView._zoomImageView.image?.size.width)!, height: (self.coreScrollView._zoomImageView.image?.size.height)!)
//            self.coreScrollView.contentSize = CGSize.init(width: ScreenWidth, height: (self.coreScrollView._zoomImageView.image?.size.height)!)
//            self.coreScrollView._zoomImageView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: (self.coreScrollView._zoomImageView.image?.size.height)!)
        }
 

        
    }
    
}

class BSCoreScrollView : UIScrollView,UIScrollViewDelegate{
    
    var _zoomImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            self.createZoomScrollView()
        }
    }
    
    func createZoomScrollView() {
        self.delegate = self
        self.minimumZoomScale = 1;
        self.maximumZoomScale = 2;
        
        _zoomImageView = UIImageView.init();
        _zoomImageView.frame = CGRect.init(x: 0, y: 20, width: ScreenWidth, height: ScreenHeight-20)
        _zoomImageView.isUserInteractionEnabled = true;
        self.addSubview(_zoomImageView)
    }
    
    
    //MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return _zoomImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        // 延中心点缩放
        var rect = _zoomImageView.frame
        rect.origin.x = 0
        rect.origin.y = 0
        
        let widthDisRatio = (self.frame.width - rect.size.width)/2.0
        let heightDisRatio = (self.frame.height - rect.size.height)/2.0
        
        if (rect.size.width < self.frame.width) {
            rect.origin.x = CGFloat(floorf(Float(widthDisRatio)))
        }
        if (rect.size.height < self.frame.height) {
            rect.origin.y = CGFloat(floorf(Float(heightDisRatio)))
        }
        
        _zoomImageView.frame = rect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
