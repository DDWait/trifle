//
//  MainViewController.swift
//  trifle
//
//  Created by TOMY on 2019/3/25.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    //发布按钮
    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///设置发布按钮
        setUpComposeBtn()
    }
}


extension MainViewController
{
    private func setUpComposeBtn(){
        tabBar.addSubview(composeBtn)
        //设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        //设置按钮的监听事件
        composeBtn.addTarget(self, action: #selector(composeBtnDidClicked), for: UIControl.Event.touchUpInside)
    }
}

//事件监听
extension MainViewController
{
    ///发布按钮的监听
    @objc private func composeBtnDidClicked(){
        //弹出发布控制器
        let pubVc = PublishViewController()
        
        let nav : UINavigationController = UINavigationController(rootViewController: pubVc)
        
        present(nav, animated: true, completion: nil)
    }
}
