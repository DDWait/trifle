//
//  RegisterLoginViewController.swift
//  trifle
//
//  Created by TOMY on 2019/3/28.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class RegisterLoginViewController: UIViewController {
    //中间view控件
    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var buttomView: UIView!
    //middle 的左边约束
    @IBOutlet weak var leadCons: NSLayoutConstraint!
    
    /*
     为了屏幕适配：xib的frame在外部在设置一次,不然会出现位置错误
     在viewDidLayoutSubviews设置xib的frame
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //登录View
        let loginView : LoginView = LoginView.LoginView()
        loginView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width * 0.5, height: self.middleView.frame.size.height)
        middleView.addSubview(loginView)
        //注册View
        let registerView : LoginView = LoginView.RegisterView()
        registerView.frame = CGRect(x: self.middleView.frame.size.width * 0.5, y: 0, width: self.middleView.frame.size.width * 0.5, height: self.middleView.frame.size.height)
        middleView.addSubview(registerView)
        middleView.tintColor = UIColor.white
        middleView.addSubview(loginView)
        
        //添加底部的view
        let fastLoginView : FastLoginView = FastLoginView.FastLoginView()
        buttomView.addSubview(fastLoginView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //登录
        let loginView : LoginView = self.middleView.subviews.first as! LoginView
        loginView.frame = CGRect(x: 0, y: 0, width: self.middleView.frame.size.width * 0.5, height: self.middleView.frame.size.height)
        
        //注册
        let registerView : LoginView = self.middleView.subviews.last as! LoginView
        registerView.frame = CGRect(x: self.middleView.frame.size.width * 0.5, y: 0, width: self.middleView.frame.size.width * 0.5, height: self.middleView.frame.size.height)
        
        //快速登录
        let fastLoginView : FastLoginView = self.buttomView.subviews.first as! FastLoginView
        fastLoginView.sinaBtn.addTarget(self, action: #selector(getUserInfoForPlatform), for: UIControl.Event.touchUpInside)
        fastLoginView.frame = self.buttomView.bounds
    }
    
    //关闭按钮点击
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    //登录按钮
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        //平移
        leadCons.constant = leadCons.constant == 0 ? -self.middleView.frame.size.width * 0.5 : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension RegisterLoginViewController
{
    @objc private func getUserInfoForPlatform() {
        UMSocialManager.default()?.getUserInfo(with: UMSocialPlatformType.sina, currentViewController: self, completion: { (result : Any?, error : Error?) in
            let resp : UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse
            print(resp.uid)
            print(resp.accessToken)
            if error != nil{
                print("************Share fail with error \(error ?? "" as! Error)*********")
                return
            }
        })
    }
}
