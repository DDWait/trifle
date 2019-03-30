//
//  WelComeViewController.swift
//  WeiBo
//
//  Created by TOMY on 2019/1/31.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage

class WelComeViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewButtom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.设置头像
        let profileURLString = UserAccountTool.shareInstance.account?.avatar_large
        //?? "" 如果可选类型有值，则解包并赋值
        //如果为nil，则直接使用??后面的值
        iconView.sd_setImage(with: URL(string: profileURLString ?? ""), placeholderImage: UIImage(named: "avatar_default_big"))
        
        iconViewButtom.constant = UIScreen.main.bounds.size.height - 200
        //2.执行动画
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }


}
