//
//  TitleViewBtn.swift
//  trifle
//
//  Created by TOMY on 2019/4/9.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class TitleViewBtn: UIButton {
    // MARK:- 重写init函数
    override init(frame: CGRect) {
        super.init(frame : frame)
        setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControl.State.normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    
    // swift中规定:重写控件的init(frame方法)或者init()方法,必须重写init?(coder aDecoder: NSCoder)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }
}
