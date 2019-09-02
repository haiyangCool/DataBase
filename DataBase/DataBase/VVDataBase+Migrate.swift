//
//  VVDataBase+Upgrade.swift
//  NetWork
//
//  Created by 王海洋 on 2017/8/15.
//  Copyright © 2019 王海洋. All rights reserved.
//
/** 数据库升级
 数据库的升级配置：
 使用 VVDataBaseUpgradeInfo 文件名 配置plist 文件
 必须使用 一下格式
 <dict>
        <key>VVDataBaseMigrator</key>
        <array>
                // 在这里配置每个版本数据库升级的信息
                <dict>
                        <key>DataBaseName</key>
                        <string>/vv.sqlite</string>
                        <key>DataBaseMigratorClass</key>
                        <string>DataBaseMigrator</string>
                </dict>
                ...
        </array>
 </dict>
 */
import Foundation

extension VVDataBase {
    
    /// 迁移数据库
    func migrate() {
        if let projectName:String =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String {
            if let  upgradePlist = Bundle.main.path(forResource: "VVDataBaseUpgradeInfo", ofType: ".plist", inDirectory: nil) {
                
                if let dataBaseMigratorInfo:NSDictionary = NSDictionary.init(contentsOfFile: upgradePlist),let upgardeListInfo:[NSDictionary] = dataBaseMigratorInfo.value(forKey: "VVDataBaseMigrator") as? [NSDictionary] {
                    
                    for upgardeInfo in upgardeListInfo {
                        
                        if let dbName:String = upgardeInfo.value(forKey: "DataBaseName") as? String,let migratorConfigureClass:String = upgardeInfo.value(forKey: "DataBaseMigratorClass") as? String {
                            if let migratorType:VVDataBaseMigrator.Type = NSClassFromString("\(projectName).\(migratorConfigureClass)") as? VVDataBaseMigrator.Type {
            
                                let migratorClass = migratorType.init()
                                let migratorInfo = migratorClass.dataBaseMigrator()
            
                                if migratorInfo.isEmpty {
                                    // 升级信息为空，第一次安装数据库
                                    let dataBaseRecord = VVDataBaseVersionRecord()
                                    dataBaseRecord.dataBaseName = dbName
                                    dataBaseRecord.dataBaseVersion = VVDataBaseDefaultVersion
                                    let fg = versionTable.insertDataWithTableRecord(dataBaseRecord)
                                    print("首次安装数据库\(fg)")
                                    
                                }else {
                                    var versionUpgradeFlag = true
                                    for info in migratorInfo {
                                        var commitFlag = false
                                        // 某一节点升级失败后，后续数据库版本将不再升级
                                        if !versionUpgradeFlag {
                                            print("升级失败，后续版本不再升级")
                                            return
                                        }
                                        let currentDBInfo = versionTable.queryData()
                                        if currentDBInfo == nil || currentDBInfo!.isEmpty{ return }
                                        let currentVersion = intFromString(currentDBInfo![0]["dataBaseVersion"] as! String)
                                        let dbVersion = intFromString(info.dataBaseVersion)
                                        if dbVersion < currentVersion {
                                            print("当前数据库为最新版本 \(currentVersion)")
                                            return
                                        }
                                        let tables = info.tables.reversed()
                                        var commands:[String] = []
                                        for (tableName,tableType) in tables {
                                            if tableType == .create {
                                                // 新建表延迟到使用时创建
                                                return
                                            }
                                            if tableType == .upgrade {
                                                // 升级 表中添加字段
                                                if  let columns = info.tableColumn[tableName] {
                                                    for column in columns {
                                                        let command = VVSQLCommand.shared.addColumnCommand(tableName, columns: column)
                                                        commands.append(command)
                                                    }
                                                }
                                            }
                                            if tableType == .drop {
                                                // 不再使用，清空数据、销毁表
                                                let dropTableCommand = VVSQLCommand.shared.dropTableCommand(tableName)
                                                commands.append(dropTableCommand)
                                        
                                            }
                                        }
                                        
                                        commitFlag = runSqlInTranction(sqlCommand:commands)
                                        versionUpgradeFlag = commitFlag
                                        if commitFlag == true {
                                            let dataBaseRecord = VVDataBaseVersionRecord()
                                            dataBaseRecord.dataBaseName = info.dataBaseName
                                            dataBaseRecord.dataBaseVersion = info.dataBaseVersion
                                            let fg = versionTable.updateDataWithRecord(dataBaseRecord, matchPattern: ["dataBaseName" : "\(VV_EQUAL)'\(info.dataBaseName)'"])
                                            print("\(info.dataBaseVersion) 版本 更新\(fg)")
                                        }else {
                                            print("\(info.dataBaseVersion) 版本升级失败")
                                        }

                                    }
                                    
                                }
                            }
                        }
                    }
                   
                }
    
            }else {
                print("配置文件读取失败,未找到VVDataBaseUpgradeInfo.plist")
            }
        }
    }
}

extension VVDataBase {
    
    
    func intFromString(_ str:String) -> Int {
        let arr = str.split(separator: ".")
        let newStr = arr.joined(separator: "")
        return Int(newStr) ?? 1
    }
}
