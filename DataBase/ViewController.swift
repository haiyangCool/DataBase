//
//  ViewController.swift
//  FMDBDemo
//
//  Created by hyw on 2018/2/26.
//  Copyright © 2018年 haiyang_wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var demoDataCenter = DemoDataCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        
        let actionList = ["Insert Data","Delete Data","Update Data","Query","Migrate"]
        
        for index in 0..<actionList.count {
            let btn = UIButton(frame: CGRect(x: 120, y: 60*(index+1), width: 120, height: 40))
            btn.tag = 10010+index
            btn.setTitle(actionList[index], for: .normal)
            btn.addTarget(self, action: #selector(action(btn:)), for: .touchUpInside)
            self.view.addSubview(btn)
            
        }
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func action(btn:UIButton) {
        let action = btn.tag-10010
        switch action {
        case 0:
            // insert
            demoDataCenter.insertData()
            break
        case 1:
            demoDataCenter.deleteData(pattern: ["name":"\(VV_EQUAL)'Mac'"])
            break
        case 2:
            demoDataCenter.updateData(pattern: ["name":"\(VV_EQUAL)'iPhone'"])
            break
        case 3:
            let dataList =  demoDataCenter.queryData(queryItems: nil, pattern: nil)
            print("data  = \(dataList)")
            break
        case 4:
            VVDataBase.shared.migrate()
            break
        default:
            break
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


/// 数据库
extension ViewController: VVTablePersistenceDelegate {
    func persistenceColumnInfo(_ info: [String : Any], tableName name: String) -> [String : Any?] {
        return ["name":"iPad","age":12]
    }
    
    
    
}

