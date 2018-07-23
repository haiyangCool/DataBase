//
//  VideoWatchLogTable.swift
//  FMDBDemo
//
//  Created by hyw on 2018/7/23.
//  Copyright © 2018年 haiyang_wang. All rights reserved.
//

import UIKit

class VideoWatchLogTable: PersistanceTable {
    override init() {
        super.init()
    }
}

extension VideoWatchLogTable:PersistanceTableProtocol {
    func dataBaseName() -> String {
        return "userInfo.sqlite"
    }
    
    func tableName() -> String {
        return "videoWatch"
    }
    
    func tableColumnInfo() -> [String : Any] {
        return [
            "identifier":"INTEGER PRIMARY KEY AUTOINCREMENT",
            "videoId":"INTEGER",
            "videoName":"TEXT",
            "videoWatchTime":"FLOAT",
            "videoDuration":"FLOAT"
        ]
    }
    
    func primaryKeyName() -> String {
        return "identifier"
    }
}
