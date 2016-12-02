//
//  BSMePersonalCell.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/15.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

class BSMePersonalCell: UITableViewCell {
    
    let _cellHeight : CGFloat = 60.0
    var iconImageView = UIImageView()
    var titleLabel = UILabel()
    var levelBtn = UIButton()
    var rightArrowBtn = UIButton()
    var bottomView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            self.selectionStyle = UITableViewCellSelectionStyle.default
            self.addSubViews()
            self.laySubViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubViews() {
        iconImageView = UIImageView.init()
        iconImageView.image = UIImage.init(named: "BSMe_myicon_icon")
        iconImageView.sizeToFit()
        
        titleLabel = UILabel.init()
        titleLabel.text = "小蘑菇"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.sizeToFit()
     
        levelBtn = UIButton.init()
        levelBtn.setImage(UIImage.init(named: "BSMe_level_icon"), for: UIControlState.normal)
        levelBtn.sizeToFit()
        
        rightArrowBtn = UIButton.init()
        rightArrowBtn.setImage(UIImage.init(named: "BSMe_rightArrow_icon"), for: UIControlState.normal)
        rightArrowBtn.sizeToFit()
        
        bottomView = UIView.init()
        bottomView.backgroundColor = BSColor.colorWithHex(0xeeeeee)
        
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(levelBtn)
        self.contentView.addSubview(rightArrowBtn)
        self.contentView.addSubview(bottomView)
    }

    func laySubViews() {
        iconImageView.frame = CGRect.init(x: 10, y: (_cellHeight-35)/2, width: 35, height: 35)
        titleLabel.frame = CGRect.init(x: iconImageView.frame.maxX + 20, y: (_cellHeight-titleLabel.bounds.size.height)/2, width: titleLabel.bounds.size.width, height: titleLabel.bounds.size.height)
        levelBtn.frame = CGRect.init(x: titleLabel.frame.maxX + 10, y: (_cellHeight-levelBtn.bounds.size.height)/2, width: levelBtn.bounds.size.width, height: levelBtn.bounds.size.height)
        rightArrowBtn.frame = CGRect.init(x: ScreenWidth-45, y: (_cellHeight-30)/2, width: 30, height: 30)
        bottomView.frame = CGRect.init(x: 0, y: _cellHeight-1, width: ScreenWidth, height: 1)
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
