//
//  NameRecord.swift
//  NetWork
//
//  Created by 王海洋 on 2018/3/6.
//  Copyright © 2019 王海洋. All rights reserved.
//

import UIKit

class NameRecord: VVTableDataRecord {

    @objc var name:String = ""
    
    override init() {
        super.init()
    }
    
    override func avaliableAllKeys() -> [String] {
        return ["name"]
    }
}
