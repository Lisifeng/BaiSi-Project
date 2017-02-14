//
//  ViewController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/13.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire
import JHB_HUDView

class EssenceViewController: BSThemeViewController , UIScrollViewDelegate , UITableViewDelegate , UITableViewDataSource,BSPictueViewCellDelegate{
    //MARK: - 参数
    var mainScrollView = UIScrollView()
    var viewNumber : NSInteger = 0
    var topicsArray = NSArray()
    var tableViewArray = NSMutableArray()
    
    var contentViews = NSMutableArray()
    var _curPoint = CGPoint()
    var _curIndex = 0
    var _width : CGFloat = 0.0
    let placeHolderT = UITableView()
    
    var _currentPictruePage = 0
    var _currentVideoPage = 0
    
    var pictureMuArr = NSMutableArray()
    var videoMuArr = NSMutableArray()
    
    //MARK: - Interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topListView.isHidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.title("精华")
        topicsArray =  ["推荐","视频","图片","段子","网红","排行","社会","美女","冷知识","游戏","DJ","美食","汽车","风景","设计","听书","生活百科","影视","旅行","漫画","情感","搭配","健康养生"]
        self.topListView.topicsArray(topicsArray)
        viewNumber = topicsArray.count
        self.setUpSubViews()
        self.setFirstView()
    }
    func setUpSubViews() {
        
        mainScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y:topListView.frame.maxY , width: ScreenWidth, height: ScreenHeight-BSNavHeight-BSTabBarHeight))// BSNavHeight
        mainScrollView.contentSize = CGSize.init(width:3.0 * mainScrollView.bounds.size.width, height: mainScrollView.bounds.size.height)
        _width = mainScrollView.bounds.size.width
        mainScrollView.contentOffset = CGPoint.init(x: ScreenWidth, y: 0)
        mainScrollView.delegate = self
        mainScrollView.isPagingEnabled = true
        mainScrollView.tag = 2000
        mainScrollView.bounces = false
        mainScrollView.showsVerticalScrollIndicator = true
        mainScrollView.showsHorizontalScrollIndicator = true
        mainScrollView.backgroundColor = UIColor.red
        _curPoint = mainScrollView.contentOffset;
        self.view.addSubview(mainScrollView)
        
        for index in 0...2{
            let contentView = UIView.init(frame: CGRect.init(x: CGFloat(index)*_width, y: 0, width: _width, height: mainScrollView.bounds.size.height))
            contentView.backgroundColor = BSColor.colorWithHex(0xcccccc)
            contentView.tag = index
            mainScrollView.addSubview(contentView)
            contentViews.add(contentView)
        }
    }
    
    func setFirstView() {
        for _ in 0...(viewNumber-1) {
            tableViewArray.add(placeHolderT)
        }
        
        let contentV = contentViews[1] as! UIView
        contentV.addSubview(self.SetUpTableV(index: 0,primeV:contentV))
        mainScrollView.setContentOffset(CGPoint.init(x: mainScrollView.bounds.size.width, y: 0), animated: false)
        
    }
    func SetUpTableV(index:NSInteger,primeV:UIView) -> UITableView{
        let contentTableV = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: primeV.bounds.size.width, height: primeV.bounds.size.height))
        contentTableV.delegate = self
        contentTableV.dataSource = self
        contentTableV.tag = index

        
        // 顶部刷新
        let header = MJRefreshNormalHeader()
        // 底部刷新
        let footer = MJRefreshAutoNormalFooter()
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(EssenceViewController.headerRefresh(page:)))
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(EssenceViewController.footerRefresh(page:)))
 
        
        contentTableV.mj_header = header
        contentTableV.mj_footer = footer
        
        if index == 0 {
            contentTableV.isHidden = true
            contentTableV.register(BSPictueViewCell.self, forCellReuseIdentifier: "BSPictueViewCell")
            
        }else if index == 1{
            contentTableV.isHidden = true
            contentTableV.register(BSPictueViewCell.self, forCellReuseIdentifier: "BSVideoViewCell")
        }else{
            contentTableV.register(UITableViewCell.self, forCellReuseIdentifier: "Essence"+"\(index)")
        }
       
        tableViewArray.replaceObject(at: contentTableV.tag, with: contentTableV)
        
        if index == 1 {
            if self.videoMuArr.count <= 0 {
//                self.getVideoNetWorksWithPage(page: 1)
//                contentTableV.mj_header.beginRefreshing()
            }
        }
        contentTableV.mj_header.beginRefreshing()
        return contentTableV
    }
    
    //MARK: - BSTopListViewTopicDelegate
    override func BSTopListViewTopicBtnClicked(_ sender:UIButton){
        
        let tag : NSInteger = sender.tag
        
        print("_curIndex"+"\(_curIndex)")
        print("tag:"+"\(tag)")
        
        var offSetX : CGFloat = 0.0
        if tag > _curIndex {// 右移
            offSetX = _width*2
            _curIndex = self.pre(current: tag)
        }else if tag < _curIndex{// 左移
            offSetX = 0.0
            _curIndex = self.next(current: tag)
        }else{
            return
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.mainScrollView.contentOffset = CGPoint.init(x: offSetX, y: 0)
        }) { (false) in
            self.scrollViewDidEndDecelerating(self.mainScrollView)
        }
    }
    
    
    //MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 0 {
            return self.pictureMuArr.count
        }else if tableView.tag == 1 {
            return self.videoMuArr.count
        }
        return 15
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView.tag == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BSPictueViewCell") as! BSPictueViewCell
            if !(cell.isEqual(nil)) {
                cell = BSPictueViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "BSPictueViewCell")
                cell.delegate = self
            }
            let contentM = self.pictureMuArr[indexPath.row]
            cell.ReleaseContentModel(model: contentM as! BSContentModel )
            return cell
        }else if tableView.tag == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "BSVideoViewCell") as! BSPictueViewCell
            if !(cell.isEqual(nil)) {
                cell = BSPictueViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "BSVideoViewCell")
                cell.delegate = self
            }
            let contentM = self.videoMuArr[indexPath.row]
            cell.ReleaseContentModel(model: contentM as! BSContentModel )
            return cell
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "Essence"+"\(tableView.tag)" as String)
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "Essence"+"\(tableView.tag)" as String)
                cell?.selectionStyle = UITableViewCellSelectionStyle.none
            }
            cell?.textLabel?.text = "Essence"+"\(tableView.tag)"
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tag = tableView.tag
        if tag == 0 || tag == 1 {
            return
        }else{
            if (tag % 2)==0 {
                let nextVc = nextViewController()
                self.navigationController?.pushViewController(nextVc, animated: true)
            }else{
                let nextVc = secNextViewController()
                self.navigationController?.pushViewController(nextVc, animated: true)
            }
        }
        
    }
    
    
    //MARK: - UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.tag != 2000{
            return
        }
        
        self.topListView.topicClickedWithTAG(_curIndex)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag != 2000{
            return
        }
        if (abs(scrollView.contentOffset.x - _curPoint.x) < 0.001) {
            return;
        }
        
        if (scrollView.contentOffset.x > _curPoint.x){// 左滑
            // 把最左一张移到最右
            let minV = self.getMinView(contentViews: self.contentViews)
            let maxV = self.getMaxView(contentViews: self.contentViews)
            self.setNilView(view: maxV)
            self.setNilView(view: minV)
            var maxF = maxV.frame
            maxF.origin.x+=_width
            minV.frame = maxF
            //
            _curIndex = self.next(current: _curIndex)
            print("_curIndex"+"\(_curIndex)")
            
            
            if !(tableViewArray[_curIndex] as! UITableView).isEqual(placeHolderT){// 已存在对应的TableView对象
                let contentT = tableViewArray[_curIndex] as! UITableView
                maxV.addSubview(contentT)
            }else {// 还未创建对应TableView对象
                maxV.addSubview(self.SetUpTableV(index: _curIndex,primeV:maxV))
            }
            
            for index in 0...(self.contentViews.count-1) {
                let contentV = self.contentViews[index] as! UIView
                contentV.frame.origin.x -= _width
            }
            
            let next = self.next(current: _curIndex)
            if !(tableViewArray[next] as! UITableView).isEqual(placeHolderT){// 已存在对应的TableView对象
                let contentT = tableViewArray[next] as! UITableView
                minV.addSubview(contentT)
            }else{
                self.setNilView(view:minV)
            }
            
            let pre = self.pre(current: _curIndex)
            if !(tableViewArray[pre] as! UITableView).isEqual(placeHolderT){// 已存在对应的TableView对象
                let contentT = tableViewArray[pre] as! UITableView
                self.getMinView(contentViews: self.contentViews).addSubview(contentT)
            }else{
                self.setNilView(view: self.getMinView(contentViews: self.contentViews))
            }
            
            print("<-")
        }else{// 右滑
            
            // 把最左一张移到最右
            let minV = self.getMinView(contentViews: self.contentViews)
            let maxV = self.getMaxView(contentViews: self.contentViews)
            self.setNilView(view: minV)
            self.setNilView(view: maxV)
            var minF = minV.frame
            minF.origin.x-=_width
            maxV.frame = minF
            //
            _curIndex = self.pre(current: _curIndex)
            print("_curIndex"+"\(_curIndex)")
            
            if !(tableViewArray[_curIndex] as! UITableView).isEqual(placeHolderT){
                let contentT = tableViewArray[_curIndex] as! UITableView
                minV.addSubview(contentT)
            }else{
                minV.addSubview(self.SetUpTableV(index: _curIndex,primeV:minV))
            }
            
            for index in 0...(self.contentViews.count-1) {
                let contentV = self.contentViews[index] as! UIView
                contentV.frame.origin.x += _width
            }
            
            let pre = self.pre(current: _curIndex)
            if !(tableViewArray[pre] as! UITableView).isEqual(placeHolderT){
                let contentT = tableViewArray[pre] as! UITableView
                maxV.addSubview(contentT)
            }else{
                self.setNilView(view:maxV)
            }
            
            let next = self.next(current: _curIndex)
            if !(tableViewArray[next] as! UITableView).isEqual(placeHolderT){// 已存在对应的TableView对象
                let contentT = tableViewArray[next] as! UITableView
                self.getMaxView(contentViews: self.contentViews).addSubview(contentT)
            }else{
                self.setNilView(view: self.getMaxView(contentViews: self.contentViews))
            }
            print("->")
        }
        
        mainScrollView.setContentOffset(CGPoint.init(x: _width, y: 0), animated: false)
        _curPoint.x = mainScrollView.contentOffset.x;
        
    }
    
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        
    }
    
    
    //MARK: - Response
    func next(current:NSInteger) -> NSInteger {
        return (current+1) % viewNumber //队列指针+1
    }
    func pre(current:NSInteger) -> NSInteger {
        return (current-1+viewNumber) % viewNumber // 队列指针-1
    }
    
    func getMinView(contentViews:NSMutableArray) -> UIView {
        
        var minView = UIView()
        var minF = CGFloat.greatestFiniteMagnitude
        for contenV in contentViews {
            let curX = (contenV as! UIView).frame.origin.x
            
            if (curX) < minF {
                minF = (curX)
                minView = contenV as! UIView
            }
        }
        
        return minView
    }
    
    func getMaxView(contentViews:NSMutableArray) -> UIView {
        
        var maxView = UIView()
        var maxF = CGFloat.leastNormalMagnitude
        for contenV in contentViews {
            let curX = (contenV as! UIView).frame.origin.x
            
            if (curX) > maxF {
                maxF = (curX)
                maxView = contenV as! UIView
            }
        }
        
        return maxView
    }
    
    // 滞空View容器
    func setNilView(view:UIView) {
        let subVs = view.subviews
        _ = UIView()
        for contentV in subVs {
            contentV.removeFromSuperview()
        }
    }
    
    func headerRefresh(page:NSInteger) {
        switch _curIndex {
        case 0:
            self.getPictureNetWorksWithPage(page: 1)
            break
        case 1:
            self.getVideoNetWorksWithPage(page: 1)
            break
        default:
            self.oepration()
            break
        }
    }
    func footerRefresh(page:NSInteger) {
        switch _curIndex {
        case 0:
            self.getPictureNetWorksWithPage(page: 1+_currentPictruePage)
            break
        case 1:
            self.getVideoNetWorksWithPage(page: 1+_currentVideoPage)
            break
        default:
            self.oepration()
            break
        }
    }

    func oepration() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.65) {
            print("延时提交的任务")
            (self.tableViewArray[self._curIndex] as! UITableView).mj_header.endRefreshing()
            (self.tableViewArray[self._curIndex] as! UITableView).mj_footer.endRefreshing()
            JHB_HUDView.showMsg("假装刷新了数据")
        }
    }
    //MARK: - NetWork
    func getPictureNetWorksWithPage(page:NSInteger)  {
        JHB_HUDView.showProgressWithType(HUDType.kHUDTypeShowSlightly)
        _currentPictruePage = page
        let CurrentPage = "\(_currentPictruePage)"
        let params = ["showapi_appid":BSAPPID,"showapi_sign":BSAPPKEY,"type":"10","page":CurrentPage]
        
        Alamofire.request(BSAPPARRESS, method: .get,parameters: params).responseJSON { (response) in
            guard let JSON = response.result.value else { return }
            let codeValue = (JSON as! NSDictionary).object(forKey: "showapi_res_code") as! NSInteger
            (self.tableViewArray[0] as! UITableView).mj_header.endRefreshing()
            (self.tableViewArray[0] as! UITableView).mj_footer.endRefreshing()
            JHB_HUDView.hideProgress()
            if codeValue == 0{
                self.dealPictrueWithResult(JSON: JSON as! NSDictionary)
            }else {
                let error = (JSON as! NSDictionary).object(forKey: "showapi_res_error") as! NSString
                print("\(error)")
            }
        }
    }
    
    func dealPictrueWithResult(JSON:NSDictionary) {
        let showapi_res_bodyDic = JSON.object(forKey: "showapi_res_body")
        let pagebean = (showapi_res_bodyDic as! NSDictionary).object(forKey: "pagebean")
        let contentlist = (pagebean as! NSDictionary).object(forKey: "contentlist") as! NSArray
        
        if self._currentPictruePage == 1{
            self.pictureMuArr.removeAllObjects()
        }
        _ = NSDictionary()
        for contentDic in contentlist{
             let contentM = BSContentModel(dict: (contentDic as! NSDictionary) as! [String : Any] as! [String : NSObject])
            self.pictureMuArr.add(contentM)
        }
        (self.tableViewArray[0] as! UITableView).isHidden = false
        (self.tableViewArray[0] as! UITableView).reloadData()
    }

    //MARK: - NetWork
    func getVideoNetWorksWithPage(page:NSInteger)  {
        JHB_HUDView.showProgressWithType(HUDType.kHUDTypeShowSlightly)
        _currentVideoPage = page
        let CurrentPage = "\(_currentVideoPage)"
        let params = ["showapi_appid":BSAPPID,"showapi_sign":BSAPPKEY,"type":"41","page":CurrentPage]
        
        Alamofire.request(BSAPPARRESS, method: .get,parameters: params).responseJSON { (response) in
            guard let JSON = response.result.value else { return }
            let codeValue = (JSON as! NSDictionary).object(forKey: "showapi_res_code") as! NSInteger
            (self.tableViewArray[1] as! UITableView).mj_header.endRefreshing()
            (self.tableViewArray[1] as! UITableView).mj_footer.endRefreshing()
            JHB_HUDView.hideProgress()
            if codeValue == 0{
                self.dealVideoWithResult(JSON: JSON as! NSDictionary)
            }else {
                let error = (JSON as! NSDictionary).object(forKey: "showapi_res_error") as! NSString
                print("\(error)")
            }
        }
    }
    
    func dealVideoWithResult(JSON:NSDictionary) {
        let showapi_res_bodyDic = JSON.object(forKey: "showapi_res_body")
        let pagebean = (showapi_res_bodyDic as! NSDictionary).object(forKey: "pagebean")
        let contentlist = (pagebean as! NSDictionary).object(forKey: "contentlist") as! NSArray
        
        if self._currentVideoPage == 1{
            self.videoMuArr.removeAllObjects()
        }
        _ = NSDictionary()
        for contentDic in contentlist{
            let contentM = BSContentModel(dict: (contentDic as! NSDictionary) as! [String : Any] as! [String : NSObject])
            self.videoMuArr.add(contentM)
        }
        (self.tableViewArray[1] as! UITableView).isHidden = false
        (self.tableViewArray[1] as! UITableView).reloadData()
    }

    
    
    //MARK: - BSPictueViewCellDelegate
    func BSPictueViewCellShowImageViewClicked(cell:BSPictueViewCell){
        if _curIndex == 0 {
            let transiArray = NSMutableArray()
            let checkImageModel = BSCheckImageModel()
            checkImageModel.transiURL = (cell.currentModel?.image0)!
            checkImageModel.transiImageView = cell.showImageView
            checkImageModel.transiImage = cell.showImageView.image!
            
            transiArray.add(checkImageModel)
            
            let checkVc = BSCheckImageViewController()
            checkVc.imageArray = transiArray
            checkVc.presentedFromThisViewController(VC:self)
        }else if _curIndex == 1 {
            let checkVideoVc = BSCheckVideoController()
            checkVideoVc.setPlayerViewWithUrl(url: (cell.currentModel?.video_uri)! as NSString)
            self.present(checkVideoVc, animated: false, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

