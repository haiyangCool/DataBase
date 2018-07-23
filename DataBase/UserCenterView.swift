//
//  UserCenterView.swift
//  FMDBDemo
//
//  Created by hyw on 2018/4/27.
//  Copyright © 2018年 haiyang_wang. All rights reserved.
//

import UIKit

class UserCenterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UserCenterView:PersistanceSaveProtocol {
    
    /// 收集用户中心需要持久化的数据

    
    func rePresistanceWithColumninfo(columInfo info: [String : Any], tableName name: String) -> [String : Any] {
        let userTableDefaultColumnInfo = NSMutableDictionary.init(dictionary: info)
        
        userTableDefaultColumnInfo.setValue(1, forKey: "userid")
        userTableDefaultColumnInfo.setValue("王海洋+zheng", forKey: "name")
        userTableDefaultColumnInfo.setValue("男+", forKey: "sex")
        userTableDefaultColumnInfo.setValue(27, forKey: "age")
        userTableDefaultColumnInfo.setValue("2018-4-27", forKey: "updateTime")
        return userTableDefaultColumnInfo as! [String : Any]
    }
}
