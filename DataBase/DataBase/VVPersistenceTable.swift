//
//  VVPersistenceTable.swift
//  NetWork
//
//  Created by 王海洋 on 2017/8/14.
//  Copyright © 2019 王海洋. All rights reserved.
//

import UIKit

///  持久化  实现弱业务逻辑，对数据库中的表进行增删改@objc @objc @objc 查操作
@objc open class VVPersistenceTable: NSObject {

    private lazy var dataBase = VVDataBase.shared
    lazy var sqlCommand = VVSQLCommand.shared
    weak var tableDelegate:VVTabelDelegate?

    override init() {
        super.init()
        dataBase.delegate = self
        
    }
    deinit {
        dataBase.closeDataBase()
    }
}

// MARK: - 插入数据 ------------------------------------------
extension VVPersistenceTable {
    
    ///  向数据表插入数据
    /// 如果需要同时从两个或多个业务对象获取数据并同时存储到一个表时，则需要在上层进行数据合并，得到最终的数据
    /// - Parameter column: 列数据
    /// - Returns: success or faild
    open func insertDataWith(_ column:[String:Any]) -> Bool {
        validatorTableDelegate()
        let tableName = tableDelegate!.tableName()
        let command = sqlCommand.insertCommand(tableName, insertItems: column)
        return dataBase.insertDataWithTableName(insertCommand: command.0, insertValues: command.1)
        
    }
    
    ///  通过实现了持久化协议的对象直接插入数据
    ///
    ///
    /// - Parameter tablePersistenceObj: 实现了持久化协议的对象（一般为View）
    /// - Returns:  bool
    open func insertDataWithTablePersistenceObject(_ tablePersistenceObj:VVTablePersistenceDelegate) -> Bool {
        validatorTableDelegate()
        let tableName = tableDelegate!.tableName()
        let command = sqlCommand.insertCommand(tableName, insertItems: tablePersistenceObj.persistenceColumnInfo(tableDelegate!.tableColumnInfo(), tableName: tableName) as [String : Any])
        return dataBase.insertDataWithTableName(insertCommand: command.0, insertValues: command.1)
        
    }
    
    
    /// 通过 Record 插入数据
    ///
    /// - Parameter record: 表的model 对象
    /// - Returns: bool
    open func insertDataWithTableRecord(_ record:VVTableDataRecord) -> Bool {
        validatorTableDelegate()
        let tableName = tableDelegate!.tableName()
        let columnInfo = record.dictionaryObject(record)
        let command = sqlCommand.insertCommand(tableName, insertItems: columnInfo)
        return dataBase.insertDataWithTableName(insertCommand: command.0, insertValues: command.1)
    }
}
// MARK: - 删除数据 ------------------------------------------
extension VVPersistenceTable {
    
    /// 删除数据表中的数据
    ///
    /// - Parameter matchPattern: 匹配字段 如果条件为空，则会清空数据表
    /// - Returns: success or faild
    open func deleteDataWith(_ matchPattern:[String:String]? = nil) -> Bool {
        validatorTableDelegate()
        let tableName = tableDelegate!.tableName()
        let command = sqlCommand.deleteCommand(tableName, matchPattern: matchPattern)
        return dataBase.deleteDataFromTable(deleteCommand: command)
    }
}
// MARK: - 修改数据 ------------------------------------------
extension VVPersistenceTable {
    
    /// 更新数据
    ///
    /// - Parameters:
    ///   - column: 更新的字段
    ///   - matchPattern: 匹配字段
    /// - Returns: success or faild
    open func updataDataWith(_ column:[String:Any], matchPattern pattern:[String:String]? = nil) -> Bool{
        validatorTableDelegate()
        let tableName = tableDelegate!.tableName()
        let command = sqlCommand.updateCommand(tableName, updateItems: column, matchPattern: pattern)
        return dataBase.updateDataWithTableName(updateCommand: command.0, updateValues: command.1)
    }
    
    
    ///  更新数据
    ///
    /// - Parameters:
    ///   - tablePersistenceObj: 实现了持久化协议的对象
    ///   - pattern:
    /// - Returns: bool
    open func updateDataWithTablePersistenceObject(_ tablePersistenceObj:VVTablePersistenceDelegate, matchPattern pattern:[String:String]? = nil) -> Bool {
        validatorTableDelegate()
        let tableName = tableDelegate!.tableName()
        let command = sqlCommand.updateCommand(tableName, updateItems: tablePersistenceObj.persistenceColumnInfo(tableDelegate!.tableColumnInfo(), tableName: tableName) as [String : Any], matchPattern: pattern)
        return dataBase.updateDataWithTableName(updateCommand: command.0, updateValues: command.1)
    }
    
    
    ///  通过record 更新数据
    ///
    /// - Parameters:
    ///   - record:
    ///   - pattern:
    /// - Returns:
    open func updateDataWithRecord(_ record:VVTableDataRecord, matchPattern pattern:[String:String]? = nil) -> Bool {
        validatorTableDelegate()
        let tableName = tableDelegate!.tableName()
        let columnInfo = record.dictionaryObject(record)
        let command = sqlCommand.updateCommand(tableName, updateItems: columnInfo, matchPattern: pattern)
        return dataBase.updateDataWithTableName(updateCommand: command.0, updateValues: command.1)
        
    }
}
// MARK: - 查询数据 ------------------------------------------
extension VVPersistenceTable {
    
    ///  查询数据
    ///
    /// - Parameters:
    ///   - queryItems: 查询的字段
    ///   - pattern: 需要匹配的信息
    /// - Returns:
    open func queryData(_ queryItems:[String]? = nil, matchPattern pattern:[String:String]? = nil) -> [[String:Any]]? {
        validatorTableDelegate()
        let tableName = tableDelegate!.tableName()
        let command = sqlCommand.selectCommand(tableName, selectItems: queryItems, matchPattern: pattern)
        return dataBase.queryDataFromTable(queryCommand: command)
    }
}


// MARK: - 修改数据表，添加字段
extension VVPersistenceTable {
    
    open func alterTable(column:[String:String]) -> Bool {
        validatorTableDelegate()
        let tableName = tableDelegate!.tableName()
        let commands = sqlCommand.addColumnCommand(tableName, columns: column)
        return dataBase.runSqlInTranction(sqlCommand: [commands])
    }
    
    
    ///批量 执行sql 命令
    ///
    /// - Parameter commands:
    /// - Returns: Bool
    open func runSql(sqlCommands commands:[String]) -> Bool {
        
        return dataBase.runSqlInTranction(sqlCommand: commands)
    }

}
// MARK: - Private methods
// MARK: - VVDataBaseDelegate Methods
extension VVPersistenceTable: VVDataBaseDelegate {
   
    ///  数据库名
    ///
    /// - Returns: String
    public func dbName() -> String {
        return tableDelegate!.dataBaseName()
    }
    
    public func tabName() -> String {
        return tableDelegate!.tableName()
    }
    
    /// 创建表 SQL
    ///
    /// - Parameter dataBaseManager:
    /// - Returns: sql
    public func createTableSql(_ dataBaseManager: VVDataBase) -> String {
        validatorTableDelegate()
        var createSql = ""
        if let tableName:String = tableDelegate?.tableName(), let columnInfo:[String:String] = tableDelegate?.tableColumnInfo(),let primaryKey:String = tableDelegate?.primaryKey() {
            createSql = sqlCommand.createTableCommand(tableName, columnInfo: columnInfo, primaryKey: primaryKey)
        }
        return createSql
    }
    
    
    /// 过滤primaryKey
    ///primaryKey 字段对应的内容, 不进行sql操作
    /// - Parameter columnInfo:
    /// - Returns: new column
    fileprivate func filterPrimaryKeyColumn(columnInfo:[String:Any]) -> [String:Any] {
        var newColumn = columnInfo
        let primaryKeyName = tableDelegate!.primaryKey()
        for key in newColumn.keys.reversed() {
            if key == primaryKeyName {
                newColumn.removeValue(forKey: key)
            }
        }
        return newColumn
    }
    
    
    /// 过滤掉值为空的column
    ///
    /// - Parameter itemInfo:
    /// - Returns:
    fileprivate func filterNilColumn(itemInfo:[String:Any]) -> [String:Any] {
        var filterItemInfo = itemInfo
        for (key,value) in filterItemInfo {

            if Optional(value) == nil || value is NSNull {
                filterItemInfo.removeValue(forKey: key)
            }

        }
        return filterItemInfo
    }
    
    /// 使用 持久化表必须实现VVPersistenceTabelDelegate
    private func validatorTableDelegate() {
        dataBase.delegate = self
        assert(tableDelegate != nil, "VVPersistenceTabelDelegate必须实现，在table中设置[delegate = self]")
    }
}
