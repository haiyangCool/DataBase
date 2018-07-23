//
//  UserInfoTable.swift
//  FMDBDemo
//
//  Created by hyw on 2018/7/23.
//  Copyright © 2018年 haiyang_wang. All rights reserved.
//
/// 用户信息表
import UIKit

class UserInfoTable: PersistanceTable {
    
    override init() {
        super.init()
    }
}

extension UserInfoTable: PersistanceTableProtocol {
    func dataBaseName() -> String {
        return "userInfo.sqlite"
    }
    
    func tableName() -> String {
        return "userInfo"
    }
    
    func tableColumnInfo() -> [String : Any] {
        return [
                "userid":"INTEGER PRIMARY KEY AUTOINCREMENT",
                "name":"TEXT",
                "sex":"TEXT",
                "age":"INTEGER",
                "updateTime":"TEXT"
                ]
    }
    
    func primaryKeyName() -> String {
        return "userid"
    }
    
    
}
