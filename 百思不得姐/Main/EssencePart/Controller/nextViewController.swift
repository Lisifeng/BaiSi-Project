//
//  nextViewController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/24.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh
import JHB_HUDView

class nextViewController: BSThemeViewController,UITableViewDelegate,UITableViewDataSource,BSPictueViewCellDelegate{

    var _currentPage = 0
    var contentModelArray = NSMutableArray()
    var mainTableView = UITableView()
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title("NEXT")
        self.back("")
        self.setTableView()
        self.getNetWorksWithPage(page: 1)
        // Do any additional setup after loading the view.
    }

    func setTableView() {
        self.view.backgroundColor = UIColor.white
        mainTableView = UITableView.init(frame: CGRect.init(x: 0, y: self.bsNavigationBar.frame.maxY, width: ScreenWidth, height: ScreenHeight-self.bsNavigationBar.frame.maxY))
        mainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.isHidden = true
        mainTableView.backgroundColor = BSColor.colorWithHex(0xeeeeee)
        mainTableView.register(BSPictueViewCell.self, forCellReuseIdentifier: "BSPictueViewCell")
        mainTableView.isHidden = true
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(nextViewController.headerRefresh(page:)))
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(nextViewController.footerRefresh(page:)))
        mainTableView.mj_header = header
        mainTableView.mj_footer = footer
        self.view.addSubview(mainTableView)
    }
    
    func headerRefresh(page:NSInteger) {
        self.getNetWorksWithPage(page: 1)
    }
    func footerRefresh(page:NSInteger) {
        self.getNetWorksWithPage(page: 1+_currentPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "BSPictueViewCell") as! BSPictueViewCell
        if !(cell.isEqual(nil)) {
            cell = BSPictueViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "BSPictueViewCell")
            cell.delegate = self
        }
        let contentM = self.contentModelArray[indexPath.row]
        cell.ReleaseContentModel(model: contentM as! BSContentModel )
        return cell
        
    }
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    //MARK: - BSPictueViewCellDelegate
    func BSPictueViewCellShowImageViewClicked(cell:BSPictueViewCell){

        let transiArray = NSMutableArray()
        let checkImageModel = BSCheckImageModel()
        checkImageModel.transiURL = (cell.currentModel?.image0)!
        checkImageModel.transiImageView = cell.showImageView
        checkImageModel.transiImage = cell.showImageView.image!
        
        transiArray.add(checkImageModel)
        
        let checkVc = BSCheckImageViewController()
        checkVc.imageArray = transiArray
        checkVc.presentedFromThisViewController(VC:self)
    }

    
    //MARK: - NetWork
    func getNetWorksWithPage(page:NSInteger)  {
        JHB_HUDView.showProgressWithType(HUDType.kHUDTypeShowSlightly)
        _currentPage = page
        let CurrentPage = "\(_currentPage)"
        let params = ["showapi_appid":BSAPPID,"showapi_sign":BSAPPKEY,"type":"10","page":CurrentPage]
                
        Alamofire.request(BSAPPARRESS, method: .get,parameters: params).responseJSON { (response) in
            guard let JSON = response.result.value else { return }
            let codeValue = (JSON as! NSDictionary).object(forKey: "showapi_res_code") as! NSInteger
            self.mainTableView.mj_header.endRefreshing()
            self.mainTableView.mj_footer.endRefreshing()
            self.mainTableView.isHidden = false
            JHB_HUDView.hideProgress()
            if codeValue == 0{
                self.dealWithResult(JSON: JSON as! NSDictionary)
            }else {
                let error = (JSON as! NSDictionary).object(forKey: "showapi_res_error") as! NSString
                JBLog("\(error)")
            }
        }
    }
    
    func dealWithResult(JSON:NSDictionary) {
        let showapi_res_bodyDic = JSON.object(forKey: "showapi_res_body")
        let pagebean = (showapi_res_bodyDic as! NSDictionary).object(forKey: "pagebean")
        let contentlist = (pagebean as! NSDictionary).object(forKey: "contentlist") as! NSArray
        
        if self._currentPage == 1{
            self.contentModelArray.removeAllObjects()
        }
        _ = NSDictionary()
        for contentDic in contentlist{
            let contentM = BSContentModel.init(dict: (contentDic as! NSDictionary) as! [String : Any] as! [String : NSObject])
            
            self.contentModelArray.add(contentM)
        }
        
        self.mainTableView.isHidden = false
        self.mainTableView.reloadData()
    }

}
