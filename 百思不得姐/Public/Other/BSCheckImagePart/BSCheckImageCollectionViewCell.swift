//
//  BSCheckImageCollectionViewCell.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/28.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import Kingfisher

protocol BSCheckImageCollectionViewCellDelegate {
    func BSCheckImageCollectionViewCellScrollViewClicked()
}

class BSCheckImageCollectionViewCell: UICollectionViewCell {
    
    var delegate : BSCheckImageCollectionViewCellDelegate?
    var coreScrollView = BSCheckImageCoreScrollView()
    var _kIfDoubleTap = Bool.init()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(BSCheckImageCollectionViewCell.singleTapped))
        singleTap.numberOfTapsRequired = 1
        coreScrollView = BSCheckImageCoreScrollView.init(frame: self.bounds)
        coreScrollView.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(BSCheckImageCollectionViewCell.doubleTapped(tap:)))
        doubleTap.numberOfTapsRequired = 2
        coreScrollView.addGestureRecognizer(doubleTap)
        self.contentView.addSubview(coreScrollView)
    }
    //MARK: - Response
    func singleTapped() {
        _kIfDoubleTap = false
        self.perform(#selector(BSCheckImageCollectionViewCell.hide), with: self, afterDelay: 0.25)
    }
    func hide() {
        if _kIfDoubleTap == true {
            return
        }
        delegate?.BSCheckImageCollectionViewCellScrollViewClicked()
    }
    func doubleTapped(tap:UITapGestureRecognizer) {
        _kIfDoubleTap = true
        let touchPoint = tap.location(in: coreScrollView)
        
        if (self.coreScrollView.zoomScale == self.coreScrollView.maximumZoomScale) {
            self.coreScrollView.setZoomScale(1, animated: true)
        } else {
            self.coreScrollView.zoom(to: CGRect.init(x: touchPoint.x, y: touchPoint.y, width: 1, height: 1), animated: true)
        }
        
    }
    
    //MARK: - 展示图片
    func displayImage(image:NSString) -> UIImage {
        
        self.coreScrollView._zoomImageView.kf.setImage(with:URL(string: image as String), placeholder: UIImage.init(named: "tabBar_aboutMeVc_selected_icon"), options: [.transition(ImageTransition.fade(1.0))], progressBlock: { receivedSize, totalSize in
            /*
            if receivedSize < totalSize {
                self.coreScrollView.contentSize = CGSize.init(width: 80, height: 80)
                self.coreScrollView._zoomImageView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
            }
            */
            },completionHandler: { (image, error,cacheType, imageURL) in
        })

        let imageSize = self.coreScrollView._zoomImageView.image?.size
        let imageHeight = ScreenWidth * (imageSize?.height)! / (imageSize?.width)!
        
        if imageHeight <= ScreenHeight {
            self.coreScrollView.contentSize = CGSize.init(width: ScreenWidth, height: imageHeight)
            self.coreScrollView._zoomImageView.frame = CGRect.init(x: 0, y: (ScreenHeight-imageHeight)/2, width: ScreenWidth, height: imageHeight)
        }else{
            self.coreScrollView.contentSize = CGSize.init(width: ScreenWidth, height: imageHeight)
            self.coreScrollView._zoomImageView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: imageHeight)
        }
      
        return self.coreScrollView._zoomImageView.image!
    }

    func setCheckImageModel(model:BSCheckImageModel
        ) -> UIImage {
        if !model.transiImage.isEqual(nil) {
            self.coreScrollView._zoomImageView.image = model.transiImage
            let imageSize = model.transiImage.size
            let height = ScreenWidth * imageSize.height / imageSize.width
            if imageSize.height <= ScreenHeight {
                self.coreScrollView.contentSize = CGSize.init(width: ScreenWidth, height: height)
                self.coreScrollView._zoomImageView.frame = CGRect.init(x: 0, y: (ScreenHeight-imageSize.height)/2, width: ScreenWidth, height: height)
            }else if imageSize.height > ScreenHeight {
                self.coreScrollView.contentSize = CGSize.init(width: ScreenWidth, height: height)
                self.coreScrollView._zoomImageView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: height)
            }
            
            return model.transiImage
        }else{
            let resultImage = self.displayImage(image: model.transiURL as NSString)
            return resultImage
        }
        
    }
    
}
class BSCheckImageCoreScrollView : UIScrollView,UIScrollViewDelegate{
    
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
