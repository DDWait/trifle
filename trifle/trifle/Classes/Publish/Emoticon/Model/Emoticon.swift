//
//  Emoticon.swift
//  表情键盘
//
//  Created by TOMY on 2019/4/13.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    // MARK:-定义属性
    @objc var png : String?{
        didSet{
            guard let png = png else {
                return
            }
            
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    @objc var chs : String?
    @objc var pngPath : String?
    @objc var isRemove : Bool = false
    @objc var isEmpty : Bool = false
    
    // MARK:-自定义构造函数
    init(dict : [String : String]) {
        super.init()
        setValuesForKeys(dict)
    }
    init(isRemove : Bool) {
        self.isRemove = isRemove
    }
    init (isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["pngPath","chs"]).description
    }
}
