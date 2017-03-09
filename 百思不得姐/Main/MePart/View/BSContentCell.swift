//
//  BSContentCell.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/16.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

protocol BSContentCellDelegate {
    func BSContentCellItemBtnClicked(btn:ItemButton)
}

class BSContentCell: UITableViewCell {

    let _cellHeight = (ScreenWidth/5+30)*2
    var delegate : BSContentCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if !self.isEqual(nil) {
            self.selectionStyle = UITableViewCellSelectionStyle.none
            self.addSubViews()
        }
    }
    
    func addSubViews() {
        let imageArr = ["BSMe_paihang_icon","BSMe_readothers_icon","BSMe_mine_icon","BSMe_gongxianbang_icon","BSMe_byrandom_icon","BSMe_advice_icon","BSMe_bangpai_icon","BSMe_search_icon","BSMe_toutiao_icon","BSMe_more_icon"]
        let titleArr = ["排行榜","审帖","我的收藏","发声音","内容贡献榜","随机穿越","意见反馈","百思帮派","搜索","头条新闻","更多"]
        
        let number = imageArr.count
        let cols : NSInteger = 5
        let margin : CGFloat = 0
        var col : NSInteger = 0
        var row : NSInteger = 0
        var x : CGFloat = 0
        var y : CGFloat = 0
        let w : CGFloat = ScreenWidth/5
        let h : CGFloat = w+30
        
        for index in 1...number{
            
            col = (index-1)%cols
            row = (index-1)/cols
            x = CGFloat(col)*(margin+w)+margin
            y = CGFloat(row)*(margin+h)+5
            let itemBtn = ItemButton.init(frame: CGRect.init(x: x, y: y, width: w, height: h))
            let image = UIImage.init(named: imageArr[index-1])
            itemBtn.setUpContent(image: image!, title: titleArr[index-1] as NSString)
            itemBtn.tag = index
            itemBtn.addTarget(self, action: #selector(BSContentCell.itemBtnClicked(btn:)), for: UIControlEvents.touchUpInside)
            self.addSubview(itemBtn)
        }

    }
    
    func itemBtnClicked(btn:ItemButton) {
        
        delegate?.BSContentCellItemBtnClicked(btn:btn)
        
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
