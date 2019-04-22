//
//  BaseViewController.swift
//  trifle
//
//  Created by TOMY on 2019/3/26.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    //加载界面
    lazy var visitorView : VisitorView = VisitorView.VisitorView()
    
    //是否登录属性
    var isLogin : Bool = UserAccountTool.shareInstance.isLogin
    
    //系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : setUpVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


extension BaseViewController
{
    private func setUpVisitorView(){
        view = visitorView
        //设置监听
        visitorView.registerLoginBtn.addTarget(self, action: #selector(regisLoginterBtnDidClicked), for: UIControl.Event.touchUpInside)
    }
    
    //按钮的监听
    //登录按钮
    @objc private func regisLoginterBtnDidClicked(){
        let registerLoginVc : RegisterLoginViewController = RegisterLoginViewController()
        present(registerLoginVc, animated: true, completion: nil)
    }

}
