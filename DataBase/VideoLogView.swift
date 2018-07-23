//
//  VideoLogView.swift
//  FMDBDemo
//
//  Created by hyw on 2018/7/23.
//  Copyright © 2018年 haiyang_wang. All rights reserved.
//

import UIKit

class VideoLogView: UIView {

    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension VideoLogView:PersistanceSaveProtocol {
    func rePresistanceWithColumninfo(columInfo info: Dictionary<String, Any>, tableName name: String) -> [String : Any] {
        
        var newColumn = info
        newColumn["videoName"] = "阿甘正传"
        newColumn["videoId"] = 11
        newColumn["videoWatchTime"] = 34
        newColumn["videoDuration"] = 210

        return newColumn
        
    }
    
    
}
