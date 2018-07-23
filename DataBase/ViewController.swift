//
//  ViewController.swift
//  FMDBDemo
//
//  Created by hyw on 2018/2/26.
//  Copyright © 2018年 haiyang_wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let insertBtn = UIButton.init(type: .custom)
        insertBtn.frame = CGRect.init(x: 30, y: 100, width: 100, height: 40)
        insertBtn.setTitle("插入", for: .normal)
        insertBtn.setTitleColor(UIColor.darkGray, for: .normal)
        insertBtn.addTarget(self, action: #selector(insertData(btn:)), for: .touchUpInside)
        self.view.addSubview(insertBtn)
        
        
        let queryBtn = UIButton.init(type: .custom)
        queryBtn.frame = CGRect.init(x: 150, y: 100, width: 100, height: 40)
        queryBtn.setTitle("查询", for: .normal)
        queryBtn.setTitleColor(UIColor.darkGray, for: .normal)
        queryBtn.addTarget(self, action: #selector(queryData(btn:)), for: .touchUpInside)
        self.view.addSubview(queryBtn)
        
        let deteteBtn = UIButton.init(type: .custom)
        deteteBtn.frame = CGRect.init(x: 30, y: 170, width: 100, height: 40)
        deteteBtn.setTitle("删除", for: .normal)
        deteteBtn.setTitleColor(UIColor.darkGray, for: .normal)
        deteteBtn.addTarget(self, action: #selector(deleteData(btn:)), for: .touchUpInside)
        self.view.addSubview(deteteBtn)
        
        
        let updateBtn = UIButton.init(type: .custom)
        updateBtn.frame = CGRect.init(x: 150, y: 170, width: 100, height: 40)
        updateBtn.setTitle("更新", for: .normal)
        updateBtn.setTitleColor(UIColor.darkGray, for: .normal)
        updateBtn.addTarget(self, action: #selector(updateData(btn:)), for: .touchUpInside)
        self.view.addSubview(updateBtn)
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func insertData(btn:UIButton) {
        let userDataCenter = UserCenterDataCenter.init()
        let flag = userDataCenter.insertUserInfo(record: UserCenterView())
        
        let videoFlag = userDataCenter.insertVideoDataInfo(record: VideoLogView())
        
        print("用户中心插入数据 = \(videoFlag) \(flag)")
    }
    @objc func queryData(btn:UIButton) {
        
        let userDataCenter = UserCenterDataCenter.init()
        let userInfo = userDataCenter.fetchUserinfo(queryItem: nil, queryFilter: nil)
        print("用户数据 = \(userInfo?.userName) \(userInfo?.videoName)")
        
    }
    
    @objc func deleteData(btn:UIButton) {
        let userDataCenter = UserCenterDataCenter.init()
        let flag = userDataCenter.deleteUserInfo(deleteFilter: ["name" : "='why'"])
        print("用户中心删除数据 = \(flag)")
    }
    
    @objc func updateData(btn:UIButton) {
        let userDataCenter = UserCenterDataCenter.init()
        let flag = userDataCenter.updateUserInfo(record: UserCenterView(), updateFilter: ["age" : "='26'"], shouldOverRide: true)
        print("用户中心更新数据 = \(flag)")
        
    }
}

