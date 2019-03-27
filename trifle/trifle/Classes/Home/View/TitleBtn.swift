//
//  TitleBtn.swift
//  scrollViewAndsegmented
//
//  Created by TOMY on 2019/3/24.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class TitleBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.red, for: UIControl.State.selected)
        setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //取消按钮的高亮
    override var isHighlighted: Bool{
        set{
            
        }
        get{
            return false
        }
    }
    
}
