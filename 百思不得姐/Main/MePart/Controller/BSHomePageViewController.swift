//
//  BSHomePageViewController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/16.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

class BSHomePageViewController: BSThemeViewController,UITableViewDelegate,UITableViewDataSource {

    var mainTableView = UITableView()
    var headerView = HeaderView()
    
    
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
        mainTableView.tableHeaderView = header
        self.headerView = header
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
        self.view.addSubview(mainTableView)
    }
    
    //MARK: - UITableViewDelegate
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
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("💗"+"\(scrollView.contentOffset)")
        let offset = scrollView.contentOffset.y
        self.bsNavigationBar.backgroundColor = ((offset>0) ? BSColor.themeColor() : UIColor.clear)
        self.statusBGView.backgroundColor = ((offset>0) ? BSColor.themeColor() : UIColor.clear)
        self.headerView.setFirFrameWith(ScrollV:scrollView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class HeaderView: UIView {
    
    let _iconHeightAndWidth = 50
    
    var bgImageView = UIImageView()
    var iconImageView = UIImageView()
    var contentView = UIView()
    
    
    //MARK: - Interface
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
