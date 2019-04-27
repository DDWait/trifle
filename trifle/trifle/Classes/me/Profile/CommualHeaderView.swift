//
//  CommualHeaderView.swift
//  个人界面
//
//  Created by TOMY on 2019/4/19.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class CommualHeaderView: UIView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var segCtrl: HMSegmentedControl!
    var canNotResponseTapTouchEvent : Bool = false
    @IBOutlet weak var iconImageBtn: UIButton!
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if canNotResponseTapTouchEvent {
            return false
        }
        return super.point(inside: point, with: event)
    }
    @IBAction func iconImageClick() {
        NotificationCenter.default.post(name: NSNotification.Name(changeIconImage), object: iconImageBtn)
    }
    
    

}
