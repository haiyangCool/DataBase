//
//  DataBaseMigrator.swift
//  NetWork
//
//  Created by 王海洋 on 2018/8/16.
//  Copyright © 2019 王海洋. All rights reserved.
//

import UIKit

class DataBaseMigrator: VVDataBaseMigrator {

    required init() {
        super.init()
    }
    
    override func dataBaseMigrator() -> [VVDataBaseUpGrade] {
        
        let database = VVDataBaseUpGrade.init(dataBaseVersion: "2.0", tables: [UserTableName : .upgrade], tableColumn: [UserTableName : [["company" : "TEXT"],["address":"TEXT"]]])
        
        let database2 = VVDataBaseUpGrade.init(dataBaseVersion: "3.0", tables: [UserTableName : .upgrade], tableColumn: [UserTableName : [["ceo" : "TEXT"],["cdo":"TEXT"]]])
        return [database,database2]
//        return []
    }
}
