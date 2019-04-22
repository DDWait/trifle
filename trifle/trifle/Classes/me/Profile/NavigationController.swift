//
//  NavigationController.swift
//  个人界面
//
//  Created by TOMY on 2019/4/19.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle{get { return.default}}
    override var childForStatusBarStyle: UIViewController?{
        return self.topViewController
    }
}
