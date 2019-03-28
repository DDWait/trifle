//
//  VisitorView.swift
//  trifle
//
//  Created by TOMY on 2019/3/26.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    class func VisitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }
    
    //xib控件
    @IBOutlet weak var ratationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerLoginBtn: UIButton!
    
    
    func setUpVisitorViewInfo(iconName : String, title : String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        ratationView.isHidden = true
    }
    
    // MARK:-图片旋转函数
    func addRotationAnim() {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.isRemovedOnCompletion = false
        ratationView.layer.add(rotationAnim, forKey: nil)
    }
}
