//
//  VVDataBaseVersionRecord.swift
//  NetWork
//
//  Created by 王海洋 on 2017/8/19.
//  Copyright © 2019 王海洋. All rights reserved.
//
/** 数据库版本记录record
 */
import UIKit

class VVDataBaseVersionRecord: VVTableDataRecord {

    @objc var dataBaseName:String?
    @objc var dataBaseVersion:String?
    
    
    override init() {
        super.init()
    }
    
    override func avaliableAllKeys() -> [String] {
        return ["dataBaseName","dataBaseVersion"]
    }
    
}
