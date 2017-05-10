/****************** JHB_HUDDiyProgressView.swift ****************/
/*******  (JHB)  ************************************************/
/*******  Created by Leon_pan on 16/6/15. ***********************/
/*******  Copyright © 2016年 CoderBala. All rights reserved.*****/
/****************** JHB_HUDDiyProgressView.swift ****************/

import UIKit
class JHB_HUDDiyProgressView: UIView {
    // MARK: - Params
    /*自定义图片*//*DiyImageView*/
    var diyImageView       = UIImageView()
    /*预备自定义图片*//*DiySpareImageView*/
    var diySpareImageView  = UIImageView()
    /*自定义信息标签*//*DiyMsgLabel*/
    var diyMsgLabel        = UILabel()
    /*用于展示图片*//*TheImageNeededToShow*/
    var diyShowImage       = NSString()
    /*图片展示类型*//*TheTypeOfImageShow*/
    var diyHudType         = NSInteger()
    /*判断是否使用预备ImageView*//*TheJudgementOfUsingSpareImageView*/
    var ifChangeImgView    = Bool()
    /*动画速度*//*TheSpeedOfAnimation*/
    var diySpeed           = CFTimeInterval()
    /*实现动画的图片个数*//*TheNumberOfImagesThatWithAnimation-Type*/
    var diyImgsNumber      = NSInteger()
    /*信息标签长度*//*TheLengthOfMessageLabel*/
    var diyMsgLabelWidth   = CGFloat()
    /*信息标签高度*//*TheHeightOfMessageLabel*/
    var diyMsgLabelHeight  = CGFloat()
    /*两边的间隔*//*TheMarginOfLeftAndRight*/
    var kMargin : CGFloat  = 10
    /*两边的间隔*//*TheMarginOfLeftAndRight*/
    var kContent = NSString.init()
    
    // MARK: - Interface
    override init(frame: CGRect) {
        super.init(frame: frame)
        ifChangeImgView = false
        diyImgsNumber = 0
        self.setSubViews()
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDDiyProgressView.resetSubViewsForJHB_DIYHUD_haveNoMsg), name: NSNotification.Name(rawValue: "JHB_DIYHUD_haveNoMsg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDDiyProgressView.resetSubViewsForJHB_DIYHUD_haveNoMsgWithScale(_:)), name: NSNotification.Name(rawValue: "JHB_DIYHUD_haveNoMsgWithScale"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDDiyProgressView.resetSubViewsForJHB_DIYHUD_haveMsg), name: NSNotification.Name(rawValue: "JHB_DIYHUD_haveMsg"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(JHB_HUDDiyProgressView.resetSubViewsForJHB_DIYHUD_haveMsgWithScale(_:)), name: NSNotification.Name(rawValue: "JHB_DIYHUD_haveMsg_WithScale"), object: nil)
        self.addSubview(self.diyImageView)
        self.addSubview(self.diyMsgLabel)
        self.addSubview(self.diySpareImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews(){
        
        self.diyImageView = UIImageView.init()
        self.diyImageView.clipsToBounds = true
        self.diyImageView.sizeToFit()
        self.diyImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.diyMsgLabel = UILabel.init()
        self.diyMsgLabel.textColor = UIColor.white
        self.diyMsgLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.diyMsgLabel.textAlignment = NSTextAlignment.center
        self.diyMsgLabel.sizeToFit()
        
        self.diySpareImageView = UIImageView.init()
        self.diySpareImageView.isHidden = true
        self.diySpareImageView.clipsToBounds = true
        self.diySpareImageView.sizeToFit()
        self.diySpareImageView.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    func resetSubViews() {
        
        self.diyImageView.frame = CGRect(x: self.bounds.size.width/2-25 ,y: self.bounds.midY-35 ,width: 50 ,height: 50 )
        self.diyMsgLabel.frame = CGRect(x: (self.bounds.size.width - (diyMsgLabelWidth - 2 * kMargin))/2, y: self.bounds.midY+25, width: diyMsgLabelWidth - 2 * kMargin, height: 18)
        self.diySpareImageView.frame = CGRect(x: 0 ,y: 0 ,width: 50 ,height: 50 )
        self.diySpareImageView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            self.resetSubViews()
    }
    
    // MARK: - NotificationCenter
    func resetSubViewsForJHB_DIYHUD_haveNoMsg() {
        ifChangeImgView = true
        self.diyImageView.isHidden = true
        self.diyMsgLabel.isHidden = true
        self.diySpareImageView.isHidden = false
        self.JudgeIfNeedAnimation()
    }
    func resetSubViewsForJHB_DIYHUD_haveNoMsgWithScale(_ noti:Notification) {
        ifChangeImgView = true
        self.diyImageView.isHidden = true
        self.diyMsgLabel.isHidden = true
        self.diySpareImageView.isHidden = false
        self.JudgeIfNeedAnimation()
        self.diySpareImageView.transform = self.diySpareImageView.transform.scaledBy(x: 1, y: 1)
    }
    func resetSubViewsForJHB_DIYHUD_haveMsg() {
        ifChangeImgView = false
        self.diyImageView.isHidden = false
        self.diyMsgLabel.isHidden = false
        self.diySpareImageView.isHidden = true
        self.JudgeIfNeedAnimation()
    }
    func resetSubViewsForJHB_DIYHUD_haveMsgWithScale(_ noti:Notification) {
        ifChangeImgView = false
        self.diyImageView.isHidden = false
        self.diyMsgLabel.isHidden = false
        self.diySpareImageView.isHidden = true
        let obValue = noti.object as! CGFloat 
        self.diyImageView.transform = self.diyImageView.transform.scaledBy(x: 1/obValue, y: 1/obValue)
        self.diyMsgLabel.transform = self.diyMsgLabel.transform.scaledBy(x: 1/obValue, y: 1/obValue)
        self.JudgeIfNeedAnimation()
        
    }
    
    // MARK: - Judge Different Show-Type
    func JudgeIfNeedAnimation() {
        if self.diyShowImage.hasSuffix(".png") {
            self.diyShowImage.substring(to: self.diyShowImage.length-4)
        }
        if self.diyImgsNumber == 0 {
            if ifChangeImgView == true {
                self.diySpareImageView.image = UIImage.init(named: "\(self.diyShowImage)" + ".png" as String)
                self.RealizeEffectOfImageView()
            }else if ifChangeImgView == false {
                self.diyImageView.image = UIImage.init(named: "\(self.diyShowImage)" + ".png" as String)
                self.RealizeEffectOfImageView()
            }
        }else {
            self.RealizeAnimationOfImageView()
        }
    }
    
    // MARK: - Realize The Effect Of ImageView
    func RealizeEffectOfImageView() {
        switch self.diyHudType {
        case DiyHUDType.kDiyHUDTypeDefault.hashValue:// 单纯展示
            
            break
        case DiyHUDType.kDiyHUDTypeRotateWithY.hashValue:
            
            //绕哪个轴，那么就改成什么：这里是绕y轴 ---> transform.rotation.y
            let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.y")
            //旋转角度
            rotationAnimation.toValue = NSNumber.init(value: Double.pi)
            //每次旋转的时间（单位秒）
            rotationAnimation.duration = self.diySpeed
            rotationAnimation.isCumulative = true
            //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
            rotationAnimation.repeatCount = MAXFLOAT
            if ifChangeImgView == true {
                self.diySpareImageView.layer.add(rotationAnimation, forKey: "transform.rotation.y")
            }else if ifChangeImgView == false {
                self.diyImageView.layer.add(rotationAnimation, forKey: "transform.rotation.y")
            }
            break
        case DiyHUDType.kDiyHUDTypeRotateWithZ.hashValue:
            //绕哪个轴，那么就改成什么：这里是z轴 ---> transform.rotation.y
            let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
            //旋转角度
            rotationAnimation.toValue = NSNumber.init(value: Double.pi)
            //每次旋转的时间（单位秒）
            rotationAnimation.duration = self.diySpeed
            rotationAnimation.isCumulative = true
            //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
            rotationAnimation.repeatCount = MAXFLOAT
            if ifChangeImgView == true {
                 self.diySpareImageView.layer.add(rotationAnimation, forKey: "transform.rotation.z")
            }else if ifChangeImgView == false {
                 self.diyImageView.layer.add(rotationAnimation, forKey: "transform.rotation.z")
            }
           
            break
        case DiyHUDType.kDiyHUDTypeShakeWithX.hashValue:
             let shakeAnimation = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
             var currentTx = CGFloat()
             if ifChangeImgView == true {
                 currentTx = self.diySpareImageView.transform.tx
             }else if ifChangeImgView == false {
                 currentTx = self.diyImageView.transform.tx
             }
             
//             shakeAnimation.delegate = self
             shakeAnimation.duration = self.diySpeed
             shakeAnimation.repeatCount = MAXFLOAT
             // currentTx + 8, currentTx - 8, currentTx + 5, currentTx - 5,currentTx + 2, currentTx - 2, currentTx
             shakeAnimation.values = [currentTx,currentTx + 10,currentTx, currentTx - 10,currentTx,currentTx + 10,currentTx,currentTx - 10]
             shakeAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
             if ifChangeImgView == true {
                self.diySpareImageView.layer.add(shakeAnimation, forKey: "transform.translation.x")
             }else if ifChangeImgView == false {
                self.diyImageView.layer.add(shakeAnimation, forKey: "transform.translation.x")
             }
             
            break
        default:
            
            break
        }
    }
    // MARK: - Realize The Effect Of Animation
    func RealizeAnimationOfImageView() {
        _ = 0
        var images=[UIImage]()
        for num  in 1 ... self.diyImgsNumber {
            guard let img=UIImage(named: "\(self.diyShowImage)" + "\(num)"+".png") else {return}
            images.append(img)
        }
        
        if ifChangeImgView == true {
            self.diySpareImageView.animationImages = images
            self.diySpareImageView.animationDuration = self.diySpeed
            self.diySpareImageView.animationRepeatCount = 0
            self.diySpareImageView.startAnimating()
        }else if ifChangeImgView == false {
            self.diyImageView.animationImages = images
            self.diyImageView.animationDuration = self.diySpeed
            self.diyImageView.animationRepeatCount = 0
            self.diyImageView.startAnimating()
        }
    }
}
