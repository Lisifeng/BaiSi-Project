//
//  BSPictueViewCell.swift
//  百思不得姐
//
//  Created by Bruce Jiang on 16/10/25.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

protocol BSPictueViewCellDelegate : class {
    func BSPictueViewCellShowImageViewClicked(cell:BSPictueViewCell)
}

class BSPictueViewCell: UITableViewCell {
    
    weak var delegate : BSPictueViewCellDelegate?
    fileprivate lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 10
        iconImageView.layer.masksToBounds = true
        iconImageView.image = #imageLiteral(resourceName: "tabBar_aboutMeVc_selected_icon.png")
        iconImageView.sizeToFit()
        return iconImageView
        }()
    fileprivate lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "name"
        nameLabel.textColor = BSColor.colorWithHex(0x000000)
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.systemFont(ofSize: 9)
        nameLabel.sizeToFit()
        return nameLabel
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "2066-6-6 06:06:06"
        timeLabel.textColor = BSColor.colorWithHex(0xbbbbbb)
        timeLabel.textAlignment = NSTextAlignment.left
        timeLabel.numberOfLines = 1
        timeLabel.font = UIFont.systemFont(ofSize: 8)
        timeLabel.sizeToFit()
        return timeLabel
    }()
    fileprivate lazy var markLabel : UILabel = {
        let markLabel = UILabel()
        markLabel.text = "揭秘地铁扫码创业者:扫1个码赚3元,月入两万!"
        markLabel.textColor = BSColor.colorWithHex(0x000000)
        markLabel.textAlignment = NSTextAlignment.left
        markLabel.numberOfLines = 0
        markLabel.font = UIFont.systemFont(ofSize: 15)
        markLabel.sizeToFit()
        return markLabel
    }()
    lazy var showImageView : UIImageView = {
        let showImageView = UIImageView()
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(BSPictueViewCell.showImageViewTap))
        showImageView.image = self.placeHolder
        showImageView.isUserInteractionEnabled = true
        showImageView.addGestureRecognizer(tapGes)
        showImageView.contentMode = UIViewContentMode.top//scaleAspectFill
        showImageView.clipsToBounds = true
        return showImageView
    }()
    fileprivate lazy var bottomView : UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = BSColor.colorWithHex(0xeeeeee)
        return bottomView
    }()
    fileprivate lazy var placeHolder : UIImage = {
        let placeHolder = UIImage.init(named: "tabBar_aboutMeVc_selected_icon")!
        return placeHolder
    }()
    var currentModel : BSContentModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            self.selectionStyle = UITableViewCellSelectionStyle.none
            self.addSubViews()
            self.laySubViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SetAndLayout
extension BSPictueViewCell{
    
    func addSubViews() {
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.markLabel)
        self.contentView.addSubview(self.showImageView)
        self.contentView.addSubview(self.bottomView)
        
    }
    func laySubViews() {
        iconImageView.frame = CGRect.init(x: 10, y: 5, width: 20, height: 20)
        nameLabel.frame = CGRect.init(x: iconImageView.frame.maxX+5, y: iconImageView.frame.minY, width: nameLabel.bounds.size.width, height: nameLabel.bounds.size.height)
        timeLabel.frame = CGRect.init(x: nameLabel.frame.minX, y: nameLabel.frame.maxY, width: timeLabel.bounds.size.width, height: timeLabel.bounds.size.height)
        markLabel.frame = CGRect.init(x: iconImageView.frame.minX, y: timeLabel.frame.maxY+10, width: ScreenWidth-(2*iconImageView.frame.minX), height: markLabel.bounds.size.height)
        showImageView.frame = CGRect.init(x:markLabel.frame.minX, y: markLabel.frame.maxY+10, width: ScreenWidth-(2*markLabel.frame.minX), height:200)
        bottomView.frame = CGRect.init(x: 0, y: showImageView.frame.maxY+10, width: ScreenWidth, height: 5)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//MARK: - BSPictueViewCellDelegate
extension BSPictueViewCell{
    func showImageViewTap() {
        delegate?.BSPictueViewCellShowImageViewClicked(cell: self)
    }
}


//MARK: - SetModel
extension BSPictueViewCell{
    func ReleaseContentModel(model:BSContentModel) {
        let type = (model.type as NSString).integerValue
        
        iconImageView.kf.setImage(with: URL(string: model.profile_image as String), placeholder: UIImage.init(named: "tabBar_aboutMeVc_selected_icon"), options: [.transition(ImageTransition.fade(1.0))], progressBlock: { receivedSize in
        }) { (image, error,cacheType, imageURL) in
        }
        
        nameLabel.text = model.name as String
        nameLabel.sizeToFit()
        timeLabel.text = model.create_time as String
        timeLabel.sizeToFit()
        markLabel.text = model.text as String
        markLabel.sizeToFit()
        
        switch type {
        case 10:
            showImageView.kf.setImage(with:URL(string: model.image0 as String), placeholder: UIImage.init(named: "tabBar_aboutMeVc_selected_icon"), options: [.transition(ImageTransition.fade(1.0))], progressBlock: { receivedSize, totalSize in
            },completionHandler: { (image, error,cacheType, imageURL) in
            })
            
            break
            
        case 41:
            if ((model._showImage.size.width) > 0) {
                self.showImageView.image = model._showImage
            }else{
                self.getShowImageWith(model: model)
            }
            break
        default:
            break
        }
        currentModel = model
        self.laySubViews()
    }
}

//MARK: - getShowImage
extension BSPictueViewCell{
    func getShowImageWith(model:BSContentModel) {
        DispatchQueue.global().async {
            JBLog("开一条全局队列异步执行任务")
            let showImage = self.getShowImageForAwhileWith(url:model.video_uri as NSString)
            model._showImage = showImage
            DispatchQueue.main.async {
                JBLog("在主队列执行任务")
                if showImage.isEqual(nil){
                    self.showImageView.image = UIImage.init(named: "tabBar_aboutMeVc_selected_icon")
                }else{
                    self.showImageView.image = model._showImage
                }
            }
        }
    }
    // 获取帧图片
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
}
