//
//  Comment.swift
//  评论
//
//  Created by TOMY on 2019/4/23.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class Comment: NSObject {
    @objc var created_at : String?      //评论时间
    @objc var text : String?            //评论正文
    @objc var user : CommentUser?       //评论的用户信息
    @objc var mid : Int = 0             //评论ID
    
    //自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        //处理用户字典
        if let userDict = dict["user"] as? [String: AnyObject]{
            user = CommentUser(dict: userDict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
