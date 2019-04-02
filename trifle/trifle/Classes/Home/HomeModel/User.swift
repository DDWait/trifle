//
//  User.swift
//  trifle
//
//  Created by TOMY on 2019/4/2.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class User: NSObject {
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
