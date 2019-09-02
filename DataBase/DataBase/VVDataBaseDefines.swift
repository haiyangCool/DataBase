//
//  VVDataBaseDefines.swift
//  NetWork
//
//  Created by 王海洋 on 2017/8/14.
//  Copyright © 2019 王海洋. All rights reserved.
//

import Foundation
import UIKit

///  默认数据库名
let VVDATABASENAME = "vv.sqlite"
/// 数据库版本信息表名
let VVDataBaseVersionTableName = "VVDataBaseVersionTableName"
let VVDataBaseDefaultVersion = "1.0"


///  Where 运算符
let VV_EQUAL = " = "
let VV_LARGE = " > "
let VV_SMALL = " < "
let VV_NOTEQUAL = " <> "
let VV_LARGETHAN = " >= "
let VV_LESSTHAN = " <= "
let VV_LIKE = " LIKE "
let VV_BETWEEN = " BETWEEN "

///  收集业务层持久化数据 对数据库做到读写的隔离
public protocol VVTablePersistenceDelegate:NSObjectProtocol {
    
    ///  Save or Update
    ///
    /// - Parameters:
    ///   - info:  供业务层参考 ， 业务层提供对应的感兴趣的column 进行持久化
    ///   - name: 表名
    /// - Returns: 持久化的colum or [:]
    func persistenceColumnInfo(_ info:[String:Any],tableName name:String) -> [String:Any?]
}

/** 表结构-数据模型
    在进行数据的存储时,限定业务层只能通过VVTablePersistenceDelegate协议来插入或修改所关心的字段
 
 */
public protocol VVTableDataRecordProtocol: NSObjectProtocol {
    
    ///  合并数据
    ///
    /// - Parameters:
    ///   - record: record
    ///   - overRide: 是否覆盖 overRide 为 true 时，直接使用record中的值对之前的数据进行覆盖
    /// overRide 为false 时，当之前的value为空时，才使用record中的数据对其覆盖
    /// - Returns: record
    func merge<T:NSObject>(_ record:T,shouldOverRide overRide:Bool) -> VVTableDataRecordProtocol where T:VVTableDataRecordProtocol
    
    
    ///  转化表数据 为 recoord Class obj
    ///
    /// - Parameter tableDic:
    /// - Returns: class obj
    func modelClass(_ tableDic:[String:Any]) -> VVTableDataRecordProtocol
    
    
    /// 转化 recordClass 为 表数据（字典）
    ///
    /// - Parameter record: record
    /// - Returns: 字典数据
    func dictionaryObject<T:NSObject>(_ record:T) -> [String:Any] where T:VVTableDataRecordProtocol
    
    ///   记录的可用字段名
    ///
    /// - Returns: keys of avaliable
    func avaliableAllKeys() -> [String]
}

/// 数据表 需要实现的协议
public protocol VVTabelDelegate:NSObjectProtocol {
   
    /// 表名
    func tableName() -> String
    /// 字段
    func tableColumnInfo() -> [String:String]
    /// primary key
    func primaryKey() -> String
}

extension VVTabelDelegate {
    
    /// 数据库名 默认
    func dataBaseName() -> String {
        return VVDATABASENAME
    }
}

/** 数据库升级
 
 记录每一版数据库的改变
 记录当前的数据库的版本,跟迁移记录做比对
 
 */
/// 数据表状态
///
/// - create: 新建
/// - upgrade: 升级
public enum VVTableStatus:String {
    
    // 新建 -- 数据库升级时,对新建表的升级推迟,使用时对不存在的表进行创建
    case create
    // 升级
    case upgrade
    // 销毁
    case drop
}

public struct VVDataBaseUpGrade {
    /// 数据库版本
    var dataBaseVersion:String
    /// 数据库名
    var dataBaseName:String
    /// 待升级的表 [表名:操作类型]
    var tables:[String:VVTableStatus]
    /// 表中需要新建的字段 [表名:[[字段:类型]]]
    var tableColumn:[String:[[String:String]]]
    
    init(_ dataBaseName:String? = VVDATABASENAME, dataBaseVersion:String, tables:[String:VVTableStatus], tableColumn:[String:[[String:String]]]) {
        self.dataBaseName = dataBaseName!
        self.dataBaseVersion = dataBaseVersion
        self.tables = tables
        self.tableColumn = tableColumn
    }
}

/// 数据库迁移记录者需要实现该协议
public protocol VVDataBaseMigratorProtocol {
    
    
    ///  各个数据版本的信息变化
    ///
    /// - Returns: version change
    func dataBaseMigrator() -> [VVDataBaseUpGrade]
}
