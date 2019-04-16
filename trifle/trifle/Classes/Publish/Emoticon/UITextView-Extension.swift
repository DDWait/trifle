//
//  UITextView-Extension.swift
//  emoji
//
//  Created by TOMY on 2019/2/4.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

extension UITextView
{
    ///获取textView 的属性字符串
    func  getEmoticonString() -> String {
        //获得属性字符串
        let attrMstr = NSMutableAttributedString(attributedString: attributedText)
        
        //遍历属性字符串
        let range = NSRange(location: 0, length: attrMstr.length)
        attrMstr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedString.Key.attachment] as? MyTextAttachment{
                attrMstr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        return attrMstr.string
    }
    
    
    
    ///插入表情
    func insertEmoticon(emoticon : Emoticon){
        //空白表情
        if emoticon.isEmpty {
            return
        }
        //删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        //其他表情
        //根据图片路径创建属性字符串
        let attachment = MyTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        //创建可变的属性字符串(将本来就存在的保存起来)
        let attrMstr = NSMutableAttributedString(attributedString: attributedText)
        
        //插入图片属性字符串
        //获取光标的位置
        let range = selectedRange
        attrMstr.replaceCharacters(in: range, with: attrImageStr)
        attributedText = attrMstr
        
        //调整文字大小(不写的话，第一个表情后面的文字图片大小会变小)
        self.font = font
        
        //处理 在中间插入表情后，光标自动到最后的问题
        //将range + 1    length = 0 不然会选中文字
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
