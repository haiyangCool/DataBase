//
//  VVSQLCommand.swift
//  NetWork
//
//  Created by 王海洋 on 2017/8/13.
//  Copyright © 2019 王海洋. All rights reserved.
//

import UIKit

/** SQL 语句标准化
     Insert delete update query
 */
open class VVSQLCommand: NSObject {

    static let shared = VVSQLCommand()
    private override init() {
        super.init()
    }
}


extension VVSQLCommand {
    
    /// 插入数据
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - values: 数据
    /// - Returns: （insert SQL, values）
    open func insertCommand(_ tableName:String,insertItems items:[String:Any]) -> (String,[Any]) {
        var insertSql = ""
        var insertValues:[Any] = []
        if items.count > 0 {
            var columString = "("
            var valueString = "("
            let keys = items.keys.reversed()
            
            for index in 0..<keys.count{
                insertValues.append(items[keys[index]]!)
                if index == keys.count - 1 {
                    columString.append("\(keys[index]))")
                    valueString.append("?)")
                }else {
                    columString.append("\(keys[index]),")
                    valueString.append("?,")
                }
            }
            insertSql = "INSERT INTO \(tableName) " + columString + " VALUES " + valueString
        }
        print("insert sql = \(insertSql)")

        return (insertSql,insertValues)
    }
    
    ///  删除数据
    ///  过滤条件为空时，删除表中所有数据
    /// - Parameters:
    ///   - tableName: 表名
    ///   - matchPattern: 匹配条件
    /// - Returns: 删除命令
    open func deleteCommand(_ tableName:String,matchPattern pattern:[String:String]? = nil) -> String {
        
        var deleteCommand = "DELETE FROM \(tableName)"
        if pattern != nil && !pattern!.isEmpty{
            let whereCmd = whereCommand(pattern!)
            deleteCommand += whereCmd
        }
        print("delete sql = \(deleteCommand)")
        return deleteCommand
    }
    
    
    ///  更新数据
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - items: 更新字段信息
    ///   - matchPattern: 匹配字典
    /// - Returns: （update Sql, update Values）
    open func updateCommand(_ tableName:String,updateItems items:[String:Any], matchPattern pattern:[String:String]? = nil) -> (String,[Any]) {
        var updateCommand = "UPDATE \(tableName) SET "
        var updateValues:[Any] = []
        
        let updateItemKeys = items.keys.reversed()
        for index in 0..<updateItemKeys.count {
            let key = updateItemKeys[index]
            let value = items[key]
            updateValues.append(value as Any)
            if index == updateItemKeys.count - 1 {
                updateCommand.append("\(key) = ?")
            }else {
                updateCommand.append("\(key) = ?, ")
            }
        }
        if pattern != nil && !pattern!.isEmpty{
            let whereCmd = whereCommand(pattern!)
            updateCommand += whereCmd
        }
        print("update sql = \(updateCommand)")
        return (updateCommand,updateValues)
    }
    
    
    /// 查询
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - items: 查询的colum
    ///   - matchPattern: 匹配字典
    /// - Returns: 查询sql
    open func selectCommand(_ tableName:String,selectItems items:[String]? = nil, matchPattern pattern:[String:String]? = nil) -> String {
        var selectItemString = "*"
        if items != nil && !items!.isEmpty {
            selectItemString = ""
            let columCount = items!.count
            for index in 0..<columCount {
                if index == columCount - 1 {
                    selectItemString.append("\(items![index])")
                }else {
                    selectItemString.append("\(items![index]),")
                }
            }
        }
        var selectCommand = "SELECT \(selectItemString) FROM \(tableName)"
        if pattern != nil && !pattern!.isEmpty{
            let whereCmd = whereCommand(pattern!)
            selectCommand += whereCmd
        }
        print("select sql = \(selectCommand)")
        return selectCommand
    }
    
    
    ///  创建表
    ///
    /// - Parameters:
    ///   - tableName: 表名
    ///   - columnInfo: 字段信息
    ///   - primaryKey: 主键
    /// - Returns: sql
    open func createTableCommand(_ tableName:String,columnInfo :[String:String], primaryKey:String? = nil) -> String {
        var createSql = ""
        var columnString = "("
        let columnKey = columnInfo.keys.reversed()
        for index in 0..<columnKey.count {
            let column = columnKey[index]
            var columnType:String = columnInfo[column]!
            if column == primaryKey {
                columnType.append(" PRIMARY KEY")
            }
            if index == columnKey.count - 1 {
                columnString.append("\(column) \(columnType))")
            }else {
                columnString.append("\(column) \(columnType),")
            }
        }
        createSql = "CREATE TABLE IF NOT EXISTS \(tableName) \(columnString)"
        print("create sql = \(createSql)")

        return createSql
    }
    
    
    ///  新增字段
    ///
    /// - Parameters:
    ///   - tableName:
    ///   - columns:
    /// - Returns: 
    open func addColumnCommand(_ tableName:String,columns: [String:String]) -> String {
        var columnString = ""

        let columnKeys = columns.keys.reversed()
        
        for index in 0..<columnKeys.count {
            let column = columnKeys[index]
            let columnType = columns[column]!
            
            if index == columnKeys.count - 1 {
                columnString.append("\(column) \(columnType)")
            }else {
                columnString.append("\(column) \(columnType),")
            }
        }
        print("ALTER sql = ALTER TABLE \(tableName) ADD \(columnString)")

        return "ALTER TABLE \(tableName) ADD \(columnString)"
    }
    
    
    /// 销毁表
    ///
    /// - Parameter tableName:
    /// - Returns:
    open func dropTableCommand(_ tableName:String) -> String {
        
        return "DROP TABLE \(tableName)"
    }
    
}

// Where
extension VVSQLCommand {

    /// Where 过滤条件
    ///
    /// - Parameter filterItem: 过滤条件 example name = "  'why'  " and age = 16
    /// - Returns: where command
    private func whereCommand(_ pattern:[String:String]) -> String {
        var command = " WHERE "
        let keys = pattern.keys.reversed()
        
        for index in 0..<keys.count {
            
            let key = keys[index]
            let value = pattern[key] ?? "nil"
        
            if index == keys.count-1 {
                command.append("\(key)\(value)")
            }else {
                command.append("\(key)\(value) and ")
            }
        }
        return command
    }
}
