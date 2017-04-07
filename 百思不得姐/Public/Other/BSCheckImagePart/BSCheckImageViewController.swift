//
//  BSCheckImageViewController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/28.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import JHB_HUDView

class BSCheckImageViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate ,BSCheckImageCollectionViewCellDelegate,BSCheckImageManagerDelegate{
    //MARK: - Parameters
    var imageArray = NSArray()
    var backBtn = UIButton()
    var saveBtn = UIButton()
    var indexlabel = UILabel()
    var transmitBtn = UIButton()
    var currentImage = UIImage()
    var resultImages = NSMutableArray()
    var browserAnimateManager = BSCheckImageManager()

    // //MARK: - Interface
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if !self.isEqual(nil) {
            //设置转场代理
            self.browserAnimateManager = BSCheckImageManager()
            self.browserAnimateManager.delegate = self
            self.transitioningDelegate = browserAnimateManager
            self.modalPresentationStyle = UIModalPresentationStyle.custom
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BSColor.colorWithHex(0xffffff)
        self.automaticallyAdjustsScrollViewInsets = false
        self.addSubViews()
        self.setSubViews()
    }

    
    func addSubViews() {
        let layout = UICollectionViewFlowLayout.init()
        let mainCollectionView = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        mainCollectionView.register(BSCheckImageCollectionViewCell.self, forCellWithReuseIdentifier: "BSCheckImageCollectionViewCell")
        mainCollectionView.dataSource = self;
        mainCollectionView.delegate = self;
        mainCollectionView.isPagingEnabled = true;
        mainCollectionView.showsHorizontalScrollIndicator = false;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSize.init(width: mainCollectionView.frame.size.width, height: mainCollectionView.frame.size.height)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        backBtn = UIButton.init()
        backBtn.setImage(#imageLiteral(resourceName: "redBack_image.png"), for: UIControlState.normal)
        backBtn.layer.cornerRadius = 15
        backBtn.layer.borderWidth = 1
        backBtn.layer.borderColor = BSColor.colorWithHex(0xed2840).cgColor
        backBtn.layer.masksToBounds = true
        backBtn.setTitleColor(BSColor.colorWithHex(0xed2840), for: UIControlState.normal)
        backBtn.backgroundColor = BSColor.colorWithHexAlpha(0x000000, alpha: 0.3)
        backBtn.addTarget(self, action: #selector(BSCheckImageViewController.backToPreVc), for: UIControlEvents.touchUpInside)
        
        saveBtn = UIButton.init()
        saveBtn.layer.cornerRadius = 3
        saveBtn.layer.borderWidth = 1
        saveBtn.layer.borderColor = BSColor.colorWithHex(0xffffff).cgColor
        saveBtn.layer.masksToBounds = true
        saveBtn.setTitle("保存", for: UIControlState.normal)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        saveBtn.setTitleColor(BSColor.colorWithHex(0xffffff), for: UIControlState.normal)
        saveBtn.backgroundColor = BSColor.colorWithHexAlpha(0x000000, alpha: 0.7)
        saveBtn.addTarget(self, action: #selector(BSCheckImageViewController.saveImage), for: UIControlEvents.touchUpInside)
        saveBtn.sizeToFit()
        
        indexlabel = UILabel.init()
        indexlabel.layer.cornerRadius = 3
        indexlabel.layer.borderWidth = 1
        indexlabel.layer.borderColor = BSColor.colorWithHex(0xffffff).cgColor
        indexlabel.layer.masksToBounds = true
        indexlabel.text = "1/1";
        indexlabel.textColor = BSColor.colorWithHex(0xffffff)
        indexlabel.textAlignment = NSTextAlignment.center
        indexlabel.backgroundColor = BSColor.colorWithHexAlpha(0x000000, alpha: 0.7)
        indexlabel.sizeToFit()
        
        self.view.addSubview(mainCollectionView)
        self.view.addSubview(backBtn)
        self.view.addSubview(saveBtn)
        self.view.addSubview(indexlabel)
    }

    func setSubViews() {
        
        backBtn.frame = CGRect.init(x: 15, y: 35, width:30,height: 30)
        saveBtn.frame = CGRect.init(x: 15, y: ScreenHeight-saveBtn.bounds.size.height-10, width: saveBtn.bounds.size.width+20, height: saveBtn.bounds.size.height)
        indexlabel.frame = CGRect.init(x: (ScreenWidth-indexlabel.bounds.size.width-20)/2, y: saveBtn.frame.minY, width: indexlabel.bounds.size.width+20, height: indexlabel.bounds.size.height)
        indexlabel.center.y = saveBtn.center.y
    }

    func presentedFromThisViewController(VC:UIViewController) {
        VC.present(self, animated: true, completion: nil)
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSCheckImageCollectionViewCell", for: indexPath) as! BSCheckImageCollectionViewCell
        cell.delegate = self
        let currentModel = imageArray[indexPath.row] as! BSCheckImageModel
        currentImage = cell.setCheckImageModel(model: currentModel)
        return cell
        
    }
    
    //MARK: -  BSCheckImageCollectionViewCellDelegate
    func BSCheckImageCollectionViewCellScrollViewClicked(){
        self.backToPreVc()
    }

    //MARK: - Response
    //--- Back ---
    func backToPreVc() {
        self.dismiss(animated: true, completion: nil)
    }
    //--- SaveImage ---
    func saveImage() {
        JHB_HUDView.showMsgWithType("<<<正在保存>>>", HudType: HUDType.kHUDTypeShowSlightly)
        UIImageWriteToSavedPhotosAlbum(currentImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject){
        JBLog("---")
        JHB_HUDView.hideProgressOfDIYType()
        if error != nil {
            JHB_HUDView.showMsg("\(String(describing: error))" as NSString)
            JBLog(error!)
            return
        }
        JHB_HUDView.showMsg("保存成功😁")
        JBLog("OK")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*******************************************/
    //MARK: - BSCheckImageManagerDelegate
    /**
     *  获取一个和被点击的imageView一模一样(相同大小,图片相同)的UIImageView
     *
     *  @return 放大动画使用的UIImageView
     */
    
    func browserAnimateFirstShowImageView() -> UIImageView{
        return self.createCurrentImage()
    }
    
    ///获取被点击cell相对于keywindow的frame
    func browserAnimationFromRect() -> CGRect{

        let imageView = (self.imageArray.firstObject as! BSCheckImageModel).transiImageView
        let fromRect = imageView.superview?.convert(imageView.frame, to: nil)
        return fromRect!
    }
    
    
    /// 获取被点击cell中的图片, 将来在图片浏览器中显示的尺寸
    func browserAnimationToRect() -> CGRect{
        
        let  image = (self.imageArray.firstObject as! BSCheckImageModel).transiImage
        let height = ScreenWidth * image.size.height / image.size.width
        var frame = CGRect()
        
        if height > ScreenHeight {
            frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: height)
        }else{
            let offsetY = (ScreenHeight - height)*0.5
            
            frame = CGRect.init(x: 0, y: offsetY, width: ScreenWidth, height: height)
        }
        
        return frame
    }
    
    /**
     *  获得结束时显示的UIImageView,缩小动画使用的UIImageView
     */
    func browserAnimateEndShowImageView() -> UIImageView{
        return self.createCurrentImage()
    }
    
    /**
     *  消失时位置,最终动画在这个rect区域消失.
     */
    func browserAnimateEndRect() -> CGRect{
        
        let imageView = (self.imageArray.firstObject as! BSCheckImageModel).transiImageView
        let endRect = imageView.superview?.convert(imageView.frame, to: nil)
        return endRect!
    }

    func createCurrentImage() -> UIImageView{
        let  image = (self.imageArray.firstObject as! BSCheckImageModel).transiImage
        let  imageView = UIImageView.init(image: image)
        imageView.contentMode = UIViewContentMode.scaleAspectFill;
        return imageView
    }
    
}
