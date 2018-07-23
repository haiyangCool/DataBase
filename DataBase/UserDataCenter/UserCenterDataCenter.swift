//
//  UserCenterDataCenter.swift
//  FMDBDemo
//
//  Created by hyw on 2018/4/26.
//  Copyright © 2018年 haiyang_wang. All rights reserved.
//
/**
    DataCenter 与 view层的高耦合是无法避免的，如果 强弱业务没有作区分，代码重用或迁移基本不能实现
    而且需要迁移重用的往往都是弱业务逻辑
    DataCenter
    调度各个数据表，组装数据，供view直接使用

 */
import UIKit

class UserCenterDataCenter: NSObject {

    fileprivate var userInfoTable:UserInfoTable?
    fileprivate var videoTable:VideoWatchLogTable?
    var persistanceProtocol:PersistanceSaveProtocol?
    
    override init() {
        super.init()
        userInfoTable = UserInfoTable.init()
        userInfoTable?.delegate = userInfoTable
        
        videoTable = VideoWatchLogTable.init()
        videoTable?.delegate = videoTable
    }
}

/// 表调度
extension UserCenterDataCenter {
    
    /// 用户信息插入
    func insertUserInfo(record:PersistanceSaveProtocol) -> Bool {
        self.persistanceProtocol = record
        let userInfo = persistanceProtocol?.rePresistanceWithColumninfo(columInfo: (userInfoTable?.tableColumnInfo())!, tableName: (userInfoTable?.tableName())!)
       
        return (userInfoTable?.insertDataWith(columnInfo: userInfo!))!
        
    }
     /// 测试 插入视频数据
    func insertVideoDataInfo(record:PersistanceSaveProtocol) -> Bool {
        self.persistanceProtocol = record
        let videoInfo = persistanceProtocol?.rePresistanceWithColumninfo(columInfo: (videoTable?.tableColumnInfo())!, tableName: (videoTable?.tableName())!)
        return (videoTable?.insertDataWith(columnInfo: videoInfo!))!
    }
    
    /// 用户信息更新
    func updateUserInfo(record:PersistanceSaveProtocol,updateFilter filter:[String:Any]? = nil , shouldOverRide:Bool) -> Bool {
        self.persistanceProtocol = record
        let userInfo = persistanceProtocol?.rePresistanceWithColumninfo(columInfo: (userInfoTable?.tableColumnInfo())!, tableName: (userInfoTable?.tableName())!)
        return (userInfoTable?.updateDataWith(updateItem: userInfo!, updateFilter: filter, shouldOverride: true))!
    }
    
    /// 用户信息+视频获取 （测试） 组合用户信息

    func fetchUserinfo(queryItem:[String]? = nil, queryFilter:[String:Any]? = nil) -> UserCenterDataInfo? {
        ///query user info
        let userInfo = userInfoTable?.queryDataWith(querySpecialItem: queryItem, queryFilter: queryFilter)
        let videoInfo = videoTable?.queryDataWith(querySpecialItem: nil, queryFilter: nil)
        let userVideo = UserCenterDataInfo.init()

        if let userInfo = userInfo,let videoInfo = videoInfo, videoInfo.count > 0  {
            userVideo.userName = userInfo[0]["name"] as? String
            userVideo.videoName = videoInfo[0]["videoName"] as? String

        }
        
        return userVideo
//        return userInfoTable?.queryDataWith(querySpecialItem: queryItem, queryFilter: queryFilter)
    }
    
    /// 用户信息删除
    func deleteUserInfo(deleteFilter:[String:Any]? = nil) -> Bool {
        return (userInfoTable?.deleteDataWith(deleteFilter: deleteFilter))!
    }
}
