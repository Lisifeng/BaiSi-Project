//
//  SecViewController.swift
//  百思不得姐
//
//  Created by CoderBala on 16/10/13.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

class NewestViewController: BSThemeViewController,UIScrollViewDelegate ,UITableViewDelegate , UITableViewDataSource{// , UIScrollViewDelegate ,
    //MARK: - 参数
    var mainScrollView = UIScrollView()
    //    var CellIdentifier = NSString()
    var viewNumber : NSInteger = 0
    var topicsArray = NSArray()
    var tableViewArray = NSMutableArray()
    
    
    var contentViews = NSMutableArray()
    var _curPoint = CGPoint()
    var _curIndex = 0
    var _width : CGFloat = 0.0
    let placeHolderT = UITableView()

    
    
    //MARK: - Interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topListView.isHidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.title("最新")
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
        contentTableV.register(UITableViewCell.self, forCellReuseIdentifier: "Newest"+"\(index)")
        tableViewArray.replaceObject(at: contentTableV.tag, with: contentTableV)
        return contentTableV
    }
    
    //MARK: - BSTopListViewTopicDelegate
    override func BSTopListViewTopicBtnClicked(_ sender:UIButton){
        
        let tag : NSInteger = sender.tag

        JBLog("_curIndex"+"\(_curIndex)")
        JBLog("tag:"+"\(tag)")
        
        
        let offSetX = _width*2
        if tag == _curIndex {// 右移
            return
        }else{
            _curIndex = self.pre(current: tag)
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
        return 15
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "Newest"+"\(tableView.tag)" as String)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "Newest"+"\(tableView.tag)" as String)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        cell?.textLabel?.text = "Newest"+"\(tableView.tag)"
        return cell!
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            
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
            JBLog("_curIndex"+"\(_curIndex)")
            
            
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
                self.getMaxView(contentViews: self.contentViews).addSubview(contentT)
            }else{
                self.setNilView(view: self.getMaxView(contentViews: self.contentViews))
            }
            
            let pre = self.pre(current: _curIndex)
            if !(tableViewArray[pre] as! UITableView).isEqual(placeHolderT){// 已存在对应的TableView对象
                let contentT = tableViewArray[pre] as! UITableView
                self.getMinView(contentViews: self.contentViews).addSubview(contentT)
            }else{
                self.setNilView(view: self.getMinView(contentViews: self.contentViews))
            }
            
            JBLog("<-")
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
            JBLog("_curIndex"+"\(_curIndex)")
            
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
                self.getMinView(contentViews: self.contentViews).addSubview(contentT)
            }else{
                self.setNilView(view: self.getMinView(contentViews: self.contentViews))
            }

            let next = self.next(current: _curIndex)
            if !(tableViewArray[next] as! UITableView).isEqual(placeHolderT){// 已存在对应的TableView对象
                let contentT = tableViewArray[next] as! UITableView
                self.getMaxView(contentViews: self.contentViews).addSubview(contentT)
            }else{
                self.setNilView(view: self.getMaxView(contentViews: self.contentViews))
            }
            JBLog("->")
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

