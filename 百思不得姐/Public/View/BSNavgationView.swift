//
//  BSNavgationView.swift
//  百思不得姐
//
//  Created by Bruce Jiang on 16/10/15.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
//MARK: - Button位置类型
public enum ButtonPositionType{
    case kButtonPositionTypeLeft
    case kButtonPositionTypeRight
}
//MARK: - BSNavgationViewButtonClickedDelegate
@objc protocol BSNavgationViewButtonClickedDelegate {
    @objc optional
    func BSNavgationViewButtonClickedWithLeftSide(_ sender:UIButton)
    func BSNavgationViewButtonClickedWithRightSide(_ sender:UIButton)
}
class BSNavgationView: UIView {

    //MARK: - 参数
    var kItemNumber = NSInteger.init()
    var delegate : BSNavgationViewButtonClickedDelegate?
    var titleLabel = UILabel.init()
    
    //MARK: - Interface
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            kItemNumber = 0
            self.backgroundColor = BSColor.themeColor()
            self.setSubViews()
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 私有方法
    private func setSubViews() {
        titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: (self.bounds.size.height-22)/2, width: ScreenWidth, height: 22))
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: 1.5)
        titleLabel.textColor = BSColor.themeCharacterColor()
        self.addSubview(titleLabel)
    }
}

//MARK: - 公共调用方法
extension BSNavgationView{
    // 设置左右按钮相关
    func setButtonsPartOf(_ PartArray:NSArray,btnPType:ButtonPositionType) {
        _ = Any.self
        for item in PartArray {
            let eventBtn = UIButton.init(frame: CGRect.init(x: (kItemNumber + 1)*BSUsualmargin, y: Int((self.bounds.size.height-25)/2), width: 25, height: 25))
            eventBtn.center.y = self.center.y
            eventBtn.setTitleColor(BSColor.themeCharacterColor(), for: UIControlState.normal)
            if (item as AnyObject).isKind(of: UIImage.self){
                eventBtn.setImage(item as? UIImage, for: UIControlState.normal)
            }else if(item as AnyObject).isKind(of: NSString.self){
                eventBtn.setTitle(item as? NSString as String?, for: UIControlState.normal)
            }else if(item as AnyObject).isKind(of: NSDictionary.self){
                let InsideDic = item as? NSDictionary
                // ※限定规则:image(图片),title(文字)
                let image = InsideDic?.object(forKey: "image") as? NSString
                let title = InsideDic?.object(forKey: "title") as? NSString
                
                guard (image != nil) else {
                    return
                }
                guard (title != nil) else {
                    return
                }
                eventBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                eventBtn.setImage(UIImage.init(named: image as! String), for: UIControlState.normal)
                eventBtn.setTitle(title as String?, for: UIControlState.normal)
                eventBtn.sizeToFit()
                eventBtn.frame = CGRect.init(x: self.bounds.size.width-eventBtn.bounds.size.width-CGFloat(BSUsualmargin), y: (self.bounds.size.height-eventBtn.bounds.size.height)/2, width: eventBtn.bounds.size.width, height: 25)
            }
            eventBtn.tag = kItemNumber
            if btnPType == ButtonPositionType.kButtonPositionTypeLeft{
                eventBtn.addTarget(self, action: #selector(BSNavgationView.EventWithLeftBtns(_:)), for: UIControlEvents.touchUpInside)
            }else if btnPType == ButtonPositionType.kButtonPositionTypeRight{
                eventBtn.addTarget(self, action: #selector(BSNavgationView.EventWithRightBtns(_:)), for: UIControlEvents.touchUpInside)
            }
            self.addSubview(eventBtn)
            kItemNumber += 1
        }
    }
}

//MARK: - 设置标题相关
extension BSNavgationView{
    func setTitle(_ title:NSString) {
        self.titleLabel.text = title as String
    }
    func setTitleColor(_ color:UIColor) {
        self.titleLabel.textColor = color
    }
}

//MARK: - 点击左右按钮
extension BSNavgationView{
    // 点击左部按钮
    func EventWithLeftBtns(_ sender:UIButton) {
        delegate?.BSNavgationViewButtonClickedWithLeftSide!(sender)
    }
    
    // 点击右部按钮
    func EventWithRightBtns(_ sender:UIButton) {
        delegate?.BSNavgationViewButtonClickedWithRightSide(sender)
    }
}

//MARK: - 设置本类相关(例如颜色)
extension BSNavgationView {
    func setBGColor(_ bgColor:UIColor) {
        self.backgroundColor = bgColor
    }
}
