//
//  fineEmoticon.swift
//  表情的匹配
//
//  Created by TOMY on 2019/2/6.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class FineEmoticon: NSObject {
    static let shareInstance : FineEmoticon = FineEmoticon()
    private lazy var manager : EmoticonManager = EmoticonManager()
    
    func fineAttrituString(statusText : String?, font : UIFont) -> NSMutableAttributedString? {
        guard let statusText = statusText else {
            return nil
        }
        
        //1.创建匹配规则
        let pattern = "\\[.*?\\]"   //匹配表情
        
        //2.创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else{
            return nil
        }
        
        //3.开始匹配
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.count))
        //4.获取结果
        let attrMstr = NSMutableAttributedString(string: statusText)
        for i in (0..<results.count).reversed(){
            let result = results[i]
            //4.1获取chs
            let chs = (statusText as NSString).substring(with: result.range)
            //4.2根据chs过去图片的路径
            guard let pngPath = findPngPath(chs: chs) else{
                return nil
            }
            //4.3创建属性字符串
            let attachmnet = NSTextAttachment()
            attachmnet.image = UIImage(contentsOfFile: pngPath)
            attachmnet.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachmnet)
            attrMstr.replaceCharacters(in: result.range, with: attrImageStr)
        }
        
        return attrMstr
    }
    
    private func findPngPath(chs : String)->String?
    {
        for picker in manager.packages {
            for emoticon in picker.emotis{
                if emoticon.chs == chs{
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
