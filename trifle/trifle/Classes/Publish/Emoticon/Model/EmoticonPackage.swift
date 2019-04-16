//
//  EmoticonPackage.swift
//  表情键盘
//
//  Created by TOMY on 2019/4/13.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    var emotis : [Emoticon] = [Emoticon]()
    
    init(id : String){
        super.init()
        //最近
        if id == ""{
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        //其他表情
        //根据ID拼接info.plist路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        var index = 0
        for var dict in array {
            if let png = dict["png"]{
                dict["png"] = id + "/" + png
            }
            emotis.append(Emoticon(dict: dict))
            index += 1
            if index == 20{
                emotis.append(Emoticon(isRemove: true))
                index = 0
            }
        }
        addEmptyEmoticon(isRecently: false)
    }
    private func addEmptyEmoticon(isRecently : Bool){
        let count = emotis.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count..<20 {
            emotis.append(Emoticon(isEmpty: true))
        }
        emotis.append(Emoticon(isRemove: true))
    }
}
