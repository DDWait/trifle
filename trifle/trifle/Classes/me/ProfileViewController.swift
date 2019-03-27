//
//  ProfileViewController.swift
//  trifle
//
//  Created by TOMY on 2019/3/25.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        //设置访客视图
        visitorView.setUpVisitorViewInfo(iconName: "visitordiscover_image_profile", title: "登录后，您的信息将会展示在这里")
    }

}
