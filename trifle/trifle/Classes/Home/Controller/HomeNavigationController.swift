//
//  HomeNavigationController.swift
//  trifle
//
//  Created by TOMY on 2019/4/24.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let btn : UIButton = UIButton(type: .custom)
            btn.setTitle("返回", for: .normal)
            btn.setImage(UIImage(named: "navigationButtonReturn"), for: .normal)
            btn.setImage(UIImage(named: "navigationButtonReturnClick"), for: .highlighted)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(UIColor.red, for: .highlighted)
            btn.sizeToFit()
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
            btn.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
            let leftBtn : UIBarButtonItem = UIBarButtonItem(customView: btn)
            viewController.navigationItem.leftBarButtonItem = leftBtn
        }
        super.pushViewController(viewController, animated: animated)
    }
    @objc private func back(){
        popViewController(animated: true)
    }
}
