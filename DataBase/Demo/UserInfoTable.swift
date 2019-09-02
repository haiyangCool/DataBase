//
//  UserInfoTable.swift
//  NetWork
//
//  Created by 王海洋 on 2018/3/6.
//  Copyright © 2019 王海洋. All rights reserved.
//

import UIKit
let UserTableName = "UserTableName"

class UserInfoTable: VVPersistenceTable {

    override init() {
        super.init()
        tableDelegate = self
    }
}

extension UserInfoTable:VVTabelDelegate {
    func tableName() -> String {
        return UserTableName
    }
    
    func tableColumnInfo() -> [String : String] {
        return [
            "iid":"INTEGER",
            "name":"TEXT",
            "age":"INTEGER"
        ]
    }

    func primaryKey() -> String {
        return "iid"
    }
    
    
}
