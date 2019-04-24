//
//  Status.swift
//  trifle
//
//  Created by TOMY on 2019/4/2.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class Status: NSObject {
    // MARK:- 属性
    @objc var created_at : String?               // 微博创建时间
    @objc var source : String?                   // 微博来源
    @objc var text : String?                     // 微博的正文
    @objc var mid : Int = 0                      // 微博的ID
    @objc var user : User?                       // 微博对应的用户
    @objc var pic_urls : [[String : String]]?     // 微博的配图
    @objc var retweeted_status : Status?          // 微博对应的转发的微博
    
    //自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        //处理用户字典
        if let userDict = dict["user"] as? [String: AnyObject]{
            user = User(dict: userDict)
        }
        //处理转发数据
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : AnyObject]{
            retweeted_status = Status(dict: retweetedStatusDict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
