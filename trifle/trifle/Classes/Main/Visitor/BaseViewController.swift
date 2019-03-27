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
    var isLogin : Bool = false
    
    //系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : setUpVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}


extension BaseViewController
{
    private func setUpVisitorView(){
        view = visitorView
        //设置监听
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnDidClicked), for: UIControl.Event.touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(LoginBtnDidClicked), for: UIControl.Event.touchUpInside)
    }
    
    //按钮的监听
    //注册按钮
    @objc private func registerBtnDidClicked(){
        print("registerBtnDidClicked")
    }
    //登录按钮
    @objc private func LoginBtnDidClicked(){
        print("LoginBtnDidClicked")
    }
}
