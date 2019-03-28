//
//  FastLoginView.swift
//  trifle
//
//  Created by TOMY on 2019/3/28.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class FastLoginView: UIView {

    class func FastLoginView()->FastLoginView{
        return Bundle.main.loadNibNamed("FastLoginView", owner: nil, options: nil)?.last as! FastLoginView
    }
}
