//
//  BSCategoryCell.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/15.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

protocol BSCategoryCellDelegate {
    func BSCategoryCellItemBtnClicked(itemBtn:DoubleLabelButton)
}

class BSCategoryCell: UITableViewCell {

    var delegate : BSCategoryCellDelegate?
    let _cellHeight : CGFloat = 55
    let _itemWidth : CGFloat = ScreenWidth/4
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            self.selectionStyle = UITableViewCellSelectionStyle.none
            self.addSubViews()
        }
    }
    
    func addSubViews()  {
        let topContent = ["1","36","25","BSMe_message_icon"]
        let bottomText = ["帖子","关注","粉丝","消息中心"]
        for item in 0...(topContent.count-1) {
            let itemBtn = DoubleLabelButton.init(frame: CGRect.init(x:CGFloat(item)*_itemWidth, y: (_cellHeight-45)/2, width: _itemWidth, height: 45))
            if item == topContent.count-1{
                itemBtn.setTopImageV(image: UIImage.init(named: topContent[item])!)
            }else{
                itemBtn.setTopText(top: topContent[item] as NSString)
            }
            itemBtn.setBottomText(bottom: bottomText[item] as NSString)
            itemBtn.tag = item
            itemBtn.addTarget(self, action: #selector(BSCategoryCell.itemBtnClicked(itemBtn:)), for: UIControlEvents.touchUpInside)
            self.contentView.addSubview(itemBtn)
        }
    }
    
    
    func itemBtnClicked(itemBtn:DoubleLabelButton) {
        delegate?.BSCategoryCellItemBtnClicked(itemBtn:itemBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

class DoubleLabelButton: UIButton {
    
    var topLabel    = UILabel.init()
    var bottomLabel = UILabel.init()
    var topImageV   = UIImageView.init()
    
    //MARK: - Interface
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            self.addSubViewsWithF(frame:frame)
        }
    }
    func addSubViewsWithF(frame:CGRect) {
        
        topLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height*0.5))
        topLabel.textAlignment = NSTextAlignment.center
        topLabel.font = UIFont.boldSystemFont(ofSize: 15)
        topLabel.text = "topLabel"
        
        topImageV = UIImageView.init(frame: CGRect.init(x: (frame.size.width-frame.size.height*0.5)/2, y: 0, width: frame.size.height*0.5, height: frame.size.height*0.5))
        
        bottomLabel = UILabel.init(frame: CGRect.init(x: 0, y: topLabel.frame.maxY, width: frame.size.width, height: frame.size.height*0.5))
        bottomLabel.textAlignment = NSTextAlignment.center
        bottomLabel.font = UIFont.systemFont(ofSize: 14)
        bottomLabel.textColor = BSColor.colorWithHex(0xbbbbbb)
        bottomLabel.text = "bottomLabel"
        
        self.addSubview(topLabel)
        self.addSubview(topImageV)
        self.addSubview(bottomLabel)
    }
    
    func setTopText(top:NSString) {
        self.topImageV.isHidden = true
        self.topLabel.isHidden = false
        self.topLabel.text = top as String
    }
    
    func setTopImageV(image:UIImage) {
        self.topLabel.isHidden = true
        self.topImageV.isHidden = false
        self.topImageV.image = image
    }
    
    func setBottomText(bottom:NSString) {
        self.bottomLabel.text = bottom as String
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
