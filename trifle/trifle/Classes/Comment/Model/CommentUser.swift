//
//  CommentUser.swift
//  评论
//
//  Created by TOMY on 2019/4/23.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class CommentUser: NSObject {
    @objc var screen_name : String?               //用户昵称
    @objc var profile_image_url : String?         //用户头像
    
    //自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
