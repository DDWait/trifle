//
//  LoginView.swift
//  trifle
//
//  Created by TOMY on 2019/3/28.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class LoginView: UIView {
    @IBOutlet weak var filetext1: UITextField!
    @IBOutlet weak var filetext2: UITextField!
    @IBAction func login() {
//        NetWorkTool.shareInstance.zhuce(name: filetext1.text!, pass: filetext2.text!)
    }
    //登录
    class func LoginView()->LoginView{
        return Bundle.main.loadNibNamed("LoginView", owner: nil, options: nil)?.last as! LoginView
    }
    //注册
    class func RegisterView()->LoginView{
        return Bundle.main.loadNibNamed("LoginView", owner: nil, options: nil)?.first as! LoginView
    }
}
