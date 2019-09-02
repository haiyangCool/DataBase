//
//  UserRecord.swift
//  NetWork
//
//  Created by 王海洋 on 2018/3/6.
//  Copyright © 2019 王海洋. All rights reserved.
//

import UIKit

class UserRecord: VVTableDataRecord {

    @objc var name:String = ""
    @objc var age:Int = 0
    
    override init() {
        super.init()
        
    }
    
    override func avaliableAllKeys() -> [String] {
        return ["name","age"]
    }
}
