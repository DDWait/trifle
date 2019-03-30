//
//  UserAccount.swift
//  trifle
//
//  Created by TOMY on 2019/3/30.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
class UserAccount: NSObject,NSCoding {
    //用户属性
    var access_token : String?
    var expires_in : Date?                    //过期时间
    var uid : String?                         //用户ID
    var screen_name : String?                 //用户名字
    var avatar_large : String?                //用户头像
    
    
    override init() {
        super.init()
    }
    
    //归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(uid, forKey: "uid")
        
    }
    
    //解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? Date
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
    }
    
    
    
    
    
    override var description : String {
        return "access_token = \((access_token)!)   uid = \((uid)!)    expires_in = \((expires_in)!)    screen_name = \((screen_name)!)     avatar_large = \((avatar_large)!)"
    }
    
    
    
}
