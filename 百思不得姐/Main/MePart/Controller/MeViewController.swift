//
//  MeViewController.swift
//  百思不得姐
//
//  Created by Leon_pan on 16/10/17.
//  Copyright © 2016年 bruce. All rights reserved.
//

import UIKit

class MeViewController: BSThemeViewController,UITableViewDelegate,UITableViewDataSource,BSCategoryCellDelegate,BSContentCellDelegate{

    var mainTableView = UITableView()

    /// Interface
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title("我")
        self.setUpSubs()
        
        // Do any additional setup after loading the view.
    }

    func setUpSubs() {
        let dic = ["image":"BSMe_set_icon","title":"设置"]
        let arr = NSMutableArray.init(object: dic)
        self.rightBtns(arr)
        
        mainTableView = UITableView.init(frame: CGRect.init(x: 0, y: BSNavHeight, width: ScreenWidth, height: ScreenHeight-BSNavHeight-BSTabBarHeight))
        mainTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(BSMePersonalCell.self, forCellReuseIdentifier: "BSMePersonalCell")
        mainTableView.register(BSCategoryCell.self, forCellReuseIdentifier: "BSCategoryCell")
        mainTableView.register(BSContentCell.self, forCellReuseIdentifier: "BSContentCell")
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        self.view.addSubview(mainTableView)
    }
    
    
    //MARK: - BSCategoryCellDelegate
    func BSCategoryCellItemBtnClicked(itemBtn:DoubleLabelButton){
    
        
        
    }
    
    //MARK: -  BSContentCellDelegate
    func BSContentCellItemBtnClicked(btn:ItemButton){
    
        
        
    }
    
    // →
    override func BSNavgationViewButtonClickedWithRightSide(_ sender:UIButton){
        JBLog("💖"+"\(sender.tag)"+"\(String(describing: sender.titleLabel?.text))")
        
        let setVc = BSSetViewController()
        self.navigationController?.pushViewController(setVc, animated: true)
 
        //JBLog("xin💖"+"\(BSFileManager.getFolderSizeWithPath(folderpath:  "\(NSHomeDirectory())"+"/"+"Library"+"/"+"Caches"))")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - About TableView
extension MeViewController {
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 5
        case 3:
            return 3
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "BSMePersonalCell")
                if !(cell != nil) {
                    cell = BSMePersonalCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "BSMePersonalCell")
                }
                
                return cell!
            }else {
                var cell = tableView.dequeueReusableCell(withIdentifier: "BSCategoryCell") as! BSCategoryCell
                if !(cell.isEqual(nil)) {
                    cell = BSCategoryCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "BSCategoryCell")
                    cell.delegate = self
                }
                return cell
            }
        case 1:
            var cell = tableView.dequeueReusableCell(withIdentifier: "BSContentCell") as! BSContentCell
            if !(cell.isEqual(nil)) {
                cell = BSContentCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "BSContentCell")
                cell.delegate = self
            }
            return cell
        case 2:
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            if !((cell?.isEqual(nil))!) {
                cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell1")
            }
            cell?.textLabel?.text = "cell1"+"💖"+"\(indexPath.row)"
            return cell!
        case 3:
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            if !((cell?.isEqual(nil))!) {
                cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell2")
            }
            cell?.textLabel?.text = "cell2"+"💖"+"\(indexPath.row)"
            return cell!
        default:
            break
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "BSMePersonalCell")
        if !(cell != nil) {
            cell = BSMePersonalCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "BSMePersonalCell")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = BSMePersonalCell()
                return cell._cellHeight
            }else{
                let cell = BSCategoryCell()
                return cell._cellHeight
            }
        case 1:
            let cell = BSContentCell()
            return cell._cellHeight
        case 2:
            return 50
        case 3:
            return 50
        default:
            break
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.000001
        case 1:
            return 10
        case 2:
            return 10
        case 3:
            return 10
        default:
            break
        }
        return 0
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let homePageVc = BSHomePageViewController()
                self.navigationController?.pushViewController(homePageVc, animated: true)
            }
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
    }
}
