//
//  VVDataBaseManager.swift
//  NetWork
//
//  Created by 王海洋 on 2017/8/13.
//  Copyright © 2019 王海洋. All rights reserved.
//

import UIKit
import FMDB

public protocol VVDataBaseDelegate: NSObjectProtocol {
    
    /// 数据库名
    ///
    /// - Returns: string
    func dbName() -> String
    
    
    /// 表名
    ///
    /// - Returns: String
    func tabName() -> String
    
    ///  要访问的数据表不存在时创建
    ///
    /// - Parameters:
    ///   - dataBaseManager: dataBaseManager
    /// - Returns: 数据表名
    func createTableSql(_ dataBaseManager: VVDataBase) -> String
    
    
//    func updateTransToInsert() -> String
  
}

// 数据库升级配置
public protocol VVDataBaseUpgradeConfigure: NSObjectProtocol{
    func configure() -> [VVDataBaseUpGrade]
}

/** 数据库管理
    数据库创建
    数据表创建
    增删改查 sql 语句执行
 */
open class VVDataBase: NSObject {

    weak var delegate: VVDataBaseDelegate!
    weak var upgradeConfigre:VVDataBaseUpgradeConfigure?

    lazy var versionTable = VVDataBaseVersionTable()
    fileprivate var dataBaseQueue:FMDatabaseQueue?
    static let shared = VVDataBase()
    private override init() {
        super.init()
    }
}

extension VVDataBase {
    
    ///  关闭数据库
    open func closeDataBase() {
        if dataBaseQueue != nil {
            dataBaseQueue?.close()
            dataBaseQueue = nil
        }
    }
    
    ///  删除表
    ///
    /// - Parameters:
    ///   - name: 表名
    ///   - command: sql
    open func dropTable(dropCommand command:String) -> Bool {
        if !openDataBase(delegate.dbName()) {
            print("数据库打开失败")
            return false
        }
        var flag = false
        if tableExist(delegate.tabName()) {
            if dataBaseQueue != nil {
                dataBaseQueue?.inTransaction({ (db, rollBack) in
                   flag = db.executeUpdate(command, withArgumentsIn: [])
                })
            }
        }
        closeDataBase()
        return flag
    }
    
    ///  插入数据
    ///
    /// - Parameters:
    ///   - name: 表名
    ///   - command: sql 语句
    ///   - values: 数据
    /// - Returns: bool
    open func insertDataWithTableName(insertCommand command:String,insertValues values:[Any]) -> Bool {
        if !openDataBase(delegate.dbName()) {
            print("数据库打开失败")
            return false
        }
        var insertFlag = false
        if !tableExist(delegate.tabName()) {
            let sql = delegate.createTableSql(self)
            if !createTable(sql) {
                return false
            }
        }
        dataBaseQueue?.inTransaction({ (db, rollBack) in
            insertFlag = db.executeUpdate(command, withArgumentsIn: values)
        })
        closeDataBase()
        return insertFlag
    }
    
    
    ///  删除表数据
    ///
    /// - Parameters:
    ///   - name: 表名
    ///   - command: sql
    /// - Returns: bool
    open func deleteDataFromTable(deleteCommand command:String) -> Bool {
        if !openDataBase(delegate.dbName()) {
            print("数据库打开失败")
            return false
        }
        var deleteFlag = false
        if tableExist(delegate.tabName()) {
            dataBaseQueue?.inTransaction({ (db, rollBack) in
                deleteFlag = db.executeStatements(command)
            })
            
        }else {
            // 不存在该表时,返回删除成功
            deleteFlag = true
        }
        closeDataBase()
        return deleteFlag
    }
    
    
    ///  更新表数据
    ///  如果表不存在,则先创建表,然后插入数据
    /// - Parameters:
    ///   - name: 表名
    ///   - command: sql
    ///   - values: 数据
    /// - Returns: bool
    func updateDataWithTableName(updateCommand command:String,updateValues values:[Any]) -> Bool {
        if !openDataBase(delegate.dbName()) {
            print("数据库打开失败")
            return false
        }
        var updateFlag = false
        if !tableExist(delegate.tabName()) {
            let sql = delegate.createTableSql(self)
            if !createTable(sql) {
               return false
            }
        }
        dataBaseQueue?.inTransaction({ (db, rollBack) in
            updateFlag = db.executeUpdate(command, withArgumentsIn: values)
        })
        closeDataBase()
        return updateFlag
    }
    
    
    ///  查询数据
    ///
    /// - Parameters:
    ///   - name: 表名
    ///   - command: sql
    /// - Returns: bool
    open func queryDataFromTable(queryCommand command:String) -> [[String:Any]]? {
        if !openDataBase(delegate.dbName()) {
            print("数据库打开失败")
            return nil
        }
        var result:[[String:Any]]? = []
        print("表名 = \(delegate.tabName())")
        if tableExist(delegate.tabName()) {
            dataBaseQueue?.inTransaction({ (db, rollBack) in
                if let dataResult = db.executeQuery(command, withArgumentsIn: []) {
                    while dataResult.next() {
                        let dataDictiony = dataResult.resultDictionary
                        result?.append(dataDictiony as! [String : Any])
                    }
                    dataResult.close()
                } 
            })
        }else {
            return nil
        }
        closeDataBase()
        return result
    }
    
    
    /// 执行sql
    ///
    /// - Parameter commands:
    /// - Returns: Bool
    open func runSqlInTranction(sqlCommand commands:[String]) -> Bool {
        if !openDataBase(delegate.dbName()) {
            print("数据库打开失败")
            return false
        }
        var flag:Bool = true
        if dataBaseQueue != nil {
            dataBaseQueue?.inTransaction({ (db, rollBack) in
                
                for command in commands {
                    do {
                        try db.executeUpdate(command, values: nil)
                    } catch {
                        print("回滚")
                        flag = false
                        db.rollback()
                    }
                }
                
            })
        }
        closeDataBase()
        return flag
    }
}

// event methods
extension VVDataBase {
    
    ///  打开数据库（如果数据库存在）否则创建
    ///
    /// - Parameter name: 数据库名
    /// - Returns: open flag
    private func openDataBase(_ name:String) -> Bool {
        closeDataBase()
        var open:Bool = false
        if let dataBaseDir:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            dataBaseQueue = FMDatabaseQueue(path: "\(dataBaseDir)\\"+name)
            if dataBaseQueue != nil {
                open = true
            }
        }else {
            open = false
        }
        return open
    }
    
    ///  表是否存在
    ///
    /// - Parameter name: tableName
    /// - Returns: bool
    open func tableExist(_ name:String) -> Bool {
        if !openDataBase(delegate.dbName()) {
            return false
        }
        var isExist = false
        dataBaseQueue?.inDatabase({ (db) in
            isExist = db.tableExists(name)
        })
        if isExist == false {
            print("\(name) 表不存在")
        }
        return isExist
    }
    
    open func createTable(_ sql:String) -> Bool {
        
        print("创建表sql = \(sql)")
        var createFlag = false
        dataBaseQueue?.inDatabase { (db) in
            createFlag = db.executeStatements(sql)
        }
        
        if createFlag == false {
            print("该表创建失败")
        }
        return createFlag
    }
}
