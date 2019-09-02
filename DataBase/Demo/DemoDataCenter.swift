//
//  DemoDataCenter.swift
//  DataBase
//
//  Created by 王海洋 on 2018/3/6.
//  Copyright © 2019 haiyang_wang. All rights reserved.
//

import UIKit

class DemoDataCenter: NSObject {
    lazy var userTable = UserInfoTable()

    override init() {
        super.init()
    }
}

extension DemoDataCenter {
    
    
    /// 写入数据库
    ///
    /// - Returns: s/f
    func insertData() -> Bool {
        
        let vc = ViewController()
        return userTable.insertDataWithTablePersistenceObject(vc)
        
    }
    
    
    /// 删除数据
    ///
    /// - Parameter pattern:
    /// - Returns: s/f
    func deleteData(pattern:[String:String]? = nil) -> Bool {
        
        return userTable.deleteDataWith(pattern)
    }
    
    
    
    /// 更新数据
    ///
    /// - Parameter pattern:
    /// - Returns: s/f
    func updateData(pattern: [String:String]?) -> Bool {
        let vc = ViewController()
        return userTable.updateDataWithTablePersistenceObject(vc, matchPattern: pattern)
    }
    

    
    /// 查询数据
    ///
    /// - Parameters:
    ///   - queryItems:
    ///   - pattern:
    /// - Returns: userList , nameList
    func queryData(queryItems:[String]?, pattern:[String:String]?) -> ([UserRecord],[NameRecord]) {
        
        var userRecordList:[UserRecord] = []
        var nameRecordList:[NameRecord] = []
        if let userInfo = userTable.queryData() {
            print("dataInfo = \(userInfo)")
            for info in userInfo {
                var userRecord = UserRecord()
                var nameRecord = NameRecord()
                
                userRecord = userRecord.modelClass(info) as! UserRecord
                nameRecord = nameRecord.merge(userRecord, shouldOverRide: true) as! NameRecord
            
                
                userRecordList.append(userRecord)
                nameRecordList.append(nameRecord)
            }
        }
        
        return (userRecordList,nameRecordList)
    }
}
