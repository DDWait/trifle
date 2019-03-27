//
//  UIButton+Extension.swift
//  trifle
//
//  Created by TOMY on 2019/3/25.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit


extension UIButton
{
    convenience init(imageName : String, bgImageName : String){
        self.init()
        setBackgroundImage(UIImage(named: bgImageName), for: UIControl.State.normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: UIControl.State.highlighted)
        setImage(UIImage(named: imageName), for: UIControl.State.normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: UIControl.State.highlighted)
        sizeToFit()
    }
}
