//
//  VVTableDataRecord.swift
//  NetWork
//
//  Created by 王海洋 on 2017/8/15.
//  Copyright © 2019 王海洋. All rights reserved.
//

import UIKit

///  持久化对象
/** 继承自VVTableDataRecord 的Record 必须重写 avaliableAllKeys(), 告知持久层可以转化的字段*/
open class VVTableDataRecord: NSObject, VVTableDataRecordProtocol{
   
    override init() {
        super.init()
    }
    
    public func merge<T>(_ record: T, shouldOverRide overRide: Bool) -> VVTableDataRecordProtocol where T : NSObject, T : VVTableDataRecordProtocol {
        let allAvaliableKeys = self.avaliableAllKeys()
        for key in allAvaliableKeys {
            if record.responds(to: Selector(key)) {
                let recordValue = record.value(forKey: key)
                if overRide {
                    self.setValue(recordValue, forKey: key)
                }else {
                    let selfValue = self.value(forKey: key)
                    if selfValue == nil {
                        self.setValue(recordValue, forKey: key)
                    }
                }
            }
        }
        return self
    }
    
    public func modelClass(_ tableDic:[String:Any]) -> VVTableDataRecordProtocol {
        
        let allAvaliableKeys = self.avaliableAllKeys()
        for key in allAvaliableKeys {
            if self.responds(to: Selector(key)) {
                self.setValue(tableDic[key], forKey: key)
            }
        }
        return self
    }
    
    public func dictionaryObject<T>(_ record: T) -> [String : Any] where T : NSObject, T : VVTableDataRecordProtocol {
        
        var info:[String:Any] = [:]
        let allAvaliableKeys = self.avaliableAllKeys()
        for key in allAvaliableKeys {
            if self.responds(to: Selector(key)) {
                let value = self.value(forKey: key)
                info[key] = value
            }
        }
        return info
    }
    
    public func avaliableAllKeys() -> [String] {
        return []
    }
}
