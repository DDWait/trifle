//
//  FastButton.swift
//  trifle
//
//  Created by TOMY on 2019/3/29.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class FastButton: UIButton {

    //修改button内部空间的位置
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置图片位置
        imageView?.frame.origin.y = 0
        imageView?.center.x = frame.size.width * 0.5
        
        //设置标题的位置
        titleLabel?.frame.origin.y = frame.size.height - titleLabel!.frame.size.height
        titleLabel?.sizeToFit()
        titleLabel?.center.x = frame.size.width * 0.5
    }
}
