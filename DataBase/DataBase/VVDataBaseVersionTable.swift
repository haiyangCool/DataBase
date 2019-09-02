//
//  VVDataBaseVersionTable.swift
//  NetWork
//
//  Created by 王海洋 on 2017/8/19.
//  Copyright © 2019 王海洋. All rights reserved.
//

import UIKit

class VVDataBaseVersionTable: VVPersistenceTable, VVTabelDelegate {
    
    func tableName() -> String {
        return VVDataBaseVersionTableName
    }
    
    func tableColumnInfo() -> [String : String] {
        return [
            "iid":"INTEGER",
            "dataBaseName":"TEXT",
            "dataBaseVersion":"TEXT"
        ]
    }
    
    func primaryKey() -> String {
        return "iid"
    }

    override init() {
        super.init()
        tableDelegate = self
    }
}
