//
//  BSHomePageViewController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/16.
//  Copyright © 2016年 bruce. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import PhotosUI

class BSHomePageViewController: BSThemeViewController,UITableViewDelegate,UITableViewDataSource ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var mainTableView = UITableView()
    var headerView = HeaderView()
    
    //MARk: - Interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title("小蘑菇")
        self.back("")
        self.automaticallyAdjustsScrollViewInsets = false
        self.bsNavigationBar.backgroundColor = UIColor.clear
        self.statusBGView.backgroundColor = UIColor.clear
        self.setSubViews()

        // Do any additional setup after loading the view.
    }

    func setSubViews() {
        mainTableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: self.view.bounds.size.height))
        mainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.backgroundColor = BSColor.colorWithHex(0xeeeeee);
        let header = HeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.mainTableView.bounds.size.width, height: 260))
         let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(changeIcon))
        header.iconImageView.isUserInteractionEnabled = true
        header.iconImageView.addGestureRecognizer(tapGes)
        mainTableView.tableHeaderView = header
        self.headerView = header
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
        self.view.addSubview(mainTableView)
    }


    func changeIcon() -> () {
        let alertC = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let action_cancel = UIAlertAction.init(title: "cancel", style: .cancel) {[weak self] (action) in
            self?.cancelPickingImages()
        }
        let action_camera = UIAlertAction.init(title: "Camera", style: .default) {[weak self] (action) in
            self?.openCamera()
        }
        let action_photos = UIAlertAction.init(title: "Album", style: .default) {[weak self] (action) in
            self?.openPhotoPicker()
        }
        alertC.addAction(action_cancel)
        alertC.addAction(action_camera)
        alertC.addAction(action_photos)
        
        present(alertC, animated: true) {
            
        }

    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK: - UIPickerViewDelegate
extension BSHomePageViewController {
    
    func openCamera() -> () {
        if !UIImagePickerController.isSourceTypeAvailable(.camera)  // 设备不支持相机
        {
            let alertC = UIAlertController.init(title: "设备不支持相机", message: nil, preferredStyle: .alert)
            let action_cancel = UIAlertAction.init(title: "明白了", style: .cancel, handler: {[weak self] (action) in
                self?.cancelPickingImages()
            })
            alertC.addAction(action_cancel)
            present(alertC, animated: true, completion: {
                
            })
            return
        }
        
        
        let authorization = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authorization == .denied || authorization == .restricted     //没有相机的访问权限
        {
            let alertC = UIAlertController.init(title: "没有相机的访问权限", message: "请先在 设置->隐私->相机 开启权限", preferredStyle: .alert)
            let action_cancel = UIAlertAction.init(title: "确定", style: .cancel, handler: {[weak self] (action) in
                self?.cancelPickingImages()
            })
            alertC.addAction(action_cancel)
            present(alertC, animated: true, completion: {
                
            })
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        present(imagePicker, animated: true) {
            
        }
    }
    
    func openPhotoPicker() -> () {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let autoStatus = PHPhotoLibrary.authorizationStatus()
            
            switch autoStatus {
            case .notDetermined:
                print("not determined !")
                let picker = UIImagePickerController.init()
                picker.view.backgroundColor = self.view.backgroundColor
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)

                
                break
            case .authorized:
                let picker = UIImagePickerController.init()
                picker.view.backgroundColor = self.view.backgroundColor
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
                break
            case .denied,.restricted:
                print("reject")
                break
            }
        }
    }
    
    func cancelPickingImages() -> () {
        /*
         QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
         imagePickerController.delegate = self;
         imagePickerController.allowsMultipleSelection = YES;
         imagePickerController.maximumNumberOfSelection = KMAXCOUNT_PHOTO - [_imageUrlArray count];
         imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
         imagePickerController.view.tag = 100;
         
         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
         [self presentViewController:navigationController animated:YES completion:nil];*/
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //cancel
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //select
        self.dismiss(animated: true, completion: nil)
        print("select")
    }

}

//MARK: - UITableViewDataSource
extension BSHomePageViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        if !((cell?.isEqual(nil))!) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell1")
        }
        cell?.textLabel?.text = "cell1"+"💖"+"\(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - UIScrollViewDelegate
extension BSHomePageViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        JBLog("💗"+"\(scrollView.contentOffset)")
        let offset = scrollView.contentOffset.y
        self.bsNavigationBar.backgroundColor = ((offset>0) ? BSColor.themeColor() : UIColor.clear)
        self.statusBGView.backgroundColor = ((offset>0) ? BSColor.themeColor() : UIColor.clear)
        self.headerView.setFirFrameWith(ScrollV:scrollView)
    }
}

/// -------HeaderView-------
class HeaderView: UIView {
    
    let _iconHeightAndWidth = 50
    var bgImageView = UIImageView()
    var iconImageView = UIImageView()
    var contentView = UIView()
    
    
    /// Interface
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !self.isEqual(nil) {
            self.addSubViewsWithF(frame:frame)
        }
    }
    
    func addSubViewsWithF(frame:CGRect) {
        
        bgImageView = UIImageView.init()
        bgImageView.image = UIImage.init(named: "BSMe_homeBgPlace_image")
        bgImageView.contentMode = UIViewContentMode.scaleAspectFill
        
        contentView = UIView.init()
        contentView.backgroundColor = UIColor.white
        
        iconImageView = UIImageView.init()
        iconImageView.image = UIImage.init(named: "BSMe_homeIconPlace_image")
        iconImageView.layer.cornerRadius = 25
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderColor = BSColor.colorWithHex(0xffffff).cgColor
        iconImageView.layer.borderWidth = 2
        iconImageView.contentMode = UIViewContentMode.scaleToFill
        
       
        
        
        self.addSubview(bgImageView)
        self.addSubview(contentView)
        self.addSubview(iconImageView)
        self.setSubViewsFrame(frame:frame)
    }
    
    func setSubViewsFrame(frame:CGRect) {
        bgImageView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height:  frame.size.height)
        contentView.frame = CGRect.init(x: 0, y: frame.size.height*0.6, width: frame.size.width, height: frame.size.height*0.4)
        iconImageView.frame = CGRect.init(x: 15, y: Int(contentView.frame.minY-20), width: _iconHeightAndWidth, height: _iconHeightAndWidth)
    }
    
    func setFirFrameWith(ScrollV:UIScrollView) {
        let contentOffsetY = ScrollV.contentOffset.y
        let h : CGFloat = self.bounds.size.height
        let height = contentOffsetY > 0 ? h : h - contentOffsetY
        let y = contentOffsetY > 0 ? 0 : contentOffsetY
        bgImageView.frame = CGRect.init(x: 0, y:y, width: self.bounds.size.width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
