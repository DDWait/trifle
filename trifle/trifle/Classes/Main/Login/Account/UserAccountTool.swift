//
//  UserAccountTool.swift
//  trifle
//
//  Created by TOMY on 2019/3/30.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class UserAccountTool {
    ///单例
    static let shareInstance : UserAccountTool = UserAccountTool()
    
    ///保存的用户
    var account : UserAccount?
    
    ///沙盒路径
    var accountPath : String{
        //获取沙盒路径
        let Path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        
        return (Path as NSString).strings(byAppendingPaths: ["accout.plist"]).first!
    }
    ///是否加载访客视图
    var isLogin : Bool{
        if account == nil {
            return false
        }
        
        
        guard let expiresDate = account?.expires_in else {
            return false
        }
        
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    init() {
        //从沙盒获取归档信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}
