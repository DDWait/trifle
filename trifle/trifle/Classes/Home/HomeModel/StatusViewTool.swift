//
//  StatusViewToll.swift
//  trifle
//
//  Created by TOMY on 2019/4/2.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class StatusViewTool: NSObject {
    var status : Status?
    
    var sourceText : String?                  // 处理后的微博来源
    var createdatText : String?               // 处理后的微博时间
    var profileURL : URL?                     // 头像地址
    var picURLs : [URL] = [URL]()             // 配图地址
    
    init(status : Status) {
        super.init()
        self.status = status
        //处理来源
        if let source = status.source, source != ""{
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        //处理时间
        if let created_at = status.created_at {
            createdatText = NSDate.createDateString(createAtStr: created_at)
        }
        
        //处理头像
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = URL(string: profileURLString)
        
        //处理配图
        let picURLDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picURLDicts = picURLDicts {
            for picURLDict in picURLDicts{
                guard let picURLString = picURLDict["thumbnail_pic"] else{
                    continue
                }
                picURLs.append(URL(string: picURLString)!)
            }
        }
    }
}
