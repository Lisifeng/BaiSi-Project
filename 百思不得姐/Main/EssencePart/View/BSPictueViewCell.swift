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
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let markLabel = UILabel()
    let showImageView = UIImageView()
    let bottomView = UIView()
    
    let placeHolder = #imageLiteral(resourceName: "tabBar_aboutMeVc_selected_icon.png")
    var currentModel : BSContentModel?
    var image0 = ""
    
    let queue = OperationQueue()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            self.selectionStyle = UITableViewCellSelectionStyle.none
            self.addSubViews()
            //self.laySubViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SetAndLayout
extension BSPictueViewCell{
    
    func addSubViews() {
        iconImageView.layer.cornerRadius = 10
        iconImageView.layer.masksToBounds = true
        iconImageView.image = #imageLiteral(resourceName: "tabBar_aboutMeVc_selected_icon.png")
        nameLabel.text = "name"
        nameLabel.textColor = BSColor.colorWithHex(0x000000)
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.systemFont(ofSize: 9)
        timeLabel.text = "2066-6-6 06:06:06"
        timeLabel.textColor = BSColor.colorWithHex(0xbbbbbb)
        timeLabel.textAlignment = NSTextAlignment.left
        timeLabel.numberOfLines = 1
        timeLabel.font = UIFont.systemFont(ofSize: 8)
        markLabel.text = "揭秘地铁扫码创业者:扫1个码赚3元,月入两万!"
        markLabel.textColor = BSColor.colorWithHex(0x000000)
        markLabel.textAlignment = NSTextAlignment.left
        markLabel.numberOfLines = 1
        markLabel.font = UIFont.systemFont(ofSize: 15)
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(BSPictueViewCell.showImageViewTap))
        showImageView.image = self.placeHolder
        showImageView.isUserInteractionEnabled = true
        showImageView.addGestureRecognizer(tapGes)
        showImageView.contentMode = UIViewContentMode.top//scaleAspectFill
        showImageView.clipsToBounds = true
        bottomView.backgroundColor = BSColor.colorWithHex(0xeeeeee)
        
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.markLabel)
        self.contentView.addSubview(self.showImageView)
        self.contentView.addSubview(self.bottomView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect.init(x: 10, y: 5, width: 20, height: 20)
        nameLabel.frame = CGRect.init(x: iconImageView.frame.maxX+5, y: iconImageView.frame.minY, width: contentView.bounds.width-35, height: 9)
        timeLabel.frame = CGRect.init(x: nameLabel.frame.minX, y: nameLabel.frame.maxY, width: contentView.bounds.width-35, height: 8)
        markLabel.frame = CGRect.init(x: iconImageView.frame.minX, y: timeLabel.frame.maxY+10, width: contentView.bounds.width-(2*iconImageView.frame.minX), height: 15)
        showImageView.frame = CGRect.init(x:markLabel.frame.minX, y: markLabel.frame.maxY+10, width: contentView.bounds.width-(2*markLabel.frame.minX), height:200)
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
extension BSPictueViewCell {
    func showImageViewTap() {
        delegate?.BSPictueViewCellShowImageViewClicked(cell: self)
    }
}


//MARK: - SetModel
extension BSPictueViewCell {
    func ReleaseContentModel(model:BSContentModel) {
        let type = (model.type as NSString).integerValue
        
        self.iconImageView.kf.setImage(with: URL(string: model.profile_image), placeholder: UIImage.init(named: "tabBar_aboutMeVc_selected_icon"), options: [.transition(ImageTransition.fade(1.0))], progressBlock: nil, completionHandler: nil)
        
        nameLabel.text = model.name
        nameLabel.sizeToFit()
        timeLabel.text = model.create_time
        timeLabel.sizeToFit()
        markLabel.text = model.text
        markLabel.sizeToFit()
        
        switch type {
        case 10:
            queue.cancelAllOperations()
            queue.addOperation {
                if !model.image0.contains(".gif") {
                    self.image0 = model.image0
                    DispatchQueue.main.async {
                        self.showImageView.kf.setImage(with:URL(string: model.image0), placeholder: UIImage.init(named: "tabBar_aboutMeVc_selected_icon"), options: [.transition(ImageTransition.fade(1.0))], progressBlock: nil,completionHandler: nil)                        
                    }
                }
            }
            //self.showImageView.kf.setImage(with: URL(string: model.profile_image), placeholder: UIImage.init(named: "tabBar_aboutMeVc_selected_icon"), options: [.transition(ImageTransition.fade(1.0))], progressBlock: nil, completionHandler: nil)
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
        //self.laySubViews()
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
        var resultImage: UIImage = UIImage()
        guard let URL = URL.init(string: url as String) else {return resultImage}
        let asset: AVURLAsset = AVURLAsset.init(url: URL, options: nil)
        let gen: AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMakeWithSeconds(1, 1)
        var actualTime: CMTime = CMTimeMake(0, 0)
        do {
            let image: CGImage = try gen.copyCGImage(at: time, actualTime: &actualTime)
            resultImage = UIImage(cgImage: image)
        } catch { }
        return resultImage
    }
}
