//
//  EmoticonManager.swift
//  表情键盘
//
//  Created by TOMY on 2019/4/13.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class EmoticonManager : NSObject{
    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    
    override init() {
        //最近
        packages.append(EmoticonPackage(id: ""))
        //默认
        packages.append(EmoticonPackage(id: "com.sina.default"))
    }
}
