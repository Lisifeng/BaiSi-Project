//
//  BSSetViewController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/11/25.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit
import JHB_HUDView

class BSSetViewController: BSThemeViewController,UITableViewDelegate,UITableViewDataSource{//FileManagerDelegate

    var mainTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.back("")
        self.title("设置")
        self.setSubViews()
        // Do any additional setup after loading the view.
    }
    
    func setSubViews() {
        mainTableView = UITableView.init(frame: CGRect.init(x: 0, y: BSNavHeight, width: ScreenWidth, height: ScreenHeight-BSNavHeight-BSTabBarHeight))
        mainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
        self.view.addSubview(mainTableView)

    }
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        if !(cell?.isEqual(nil))! {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell1")
        }
        cell?.textLabel?.text = "清楚缓存"+"\(Int(BSFileManager.getFolderSizeWithPath(folderpath:  "\(NSHomeDirectory())"+"/"+"Library"+"/"+"Caches")))"+"M"
        
        return cell!
    }
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = NSHomeDirectory()
        print(path)
        
//        BSFileManager.delegate = self
        let ifClear = BSFileManager.clearFolderWithPath(folderpath: "\(NSHomeDirectory())"+"/"+"Library"+"/"+"Caches")
        if ifClear {
            JHB_HUDView.showMsg("清楚成功!")
            self.mainTableView.reloadData()
        }
    }

    /*
    //MARK: - FileManagerDelegate
    func fileManager(_ fileManager: FileManager, shouldRemoveItemAtPath path: String) -> Bool {
        print("💗"+"\(path)")
        
        
        return true
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}
