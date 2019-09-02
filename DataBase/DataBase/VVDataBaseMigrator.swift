//
//  VVDataBaseMigrator.swift
//  NetWork
//
//  Created by 王海洋 on 2017/8/16.
//  Copyright © 2019 王海洋. All rights reserved.
//
/** 数据库版本迁移
 自定义数据库版本迁移记录继承（VVDataBaseMigrator）并实现 VVDataBaseMigratorProtocol*/
import UIKit

open class VVDataBaseMigrator: NSObject, VVDataBaseMigratorProtocol {

    override required public init() {
        super.init()
    }
    
    public func dataBaseMigrator() -> [VVDataBaseUpGrade] {
        return []
    }
    
}
