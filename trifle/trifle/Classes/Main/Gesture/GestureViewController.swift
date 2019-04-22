//
//  GestureViewController.swift
//  手势解锁
//
//  Created by TOMY on 2019/4/22.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
private let KeyPwd : String = "KeyPwd2"
class GestureViewController: UIViewController {
    @IBOutlet weak var tipLabel: UILabel!
    
    //初始界面的选择
    var defaultVc : UIViewController? {
        let isLogin = UserAccountTool.shareInstance.isLogin
        return isLogin ? WelComeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(erroeOfGesture), name: NSNotification.Name(showErrorOfGesture), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(successOfGestur), name: NSNotification.Name(showSuccessOfGesture), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pwErrorOfGesture), name: NSNotification.Name(showPwErrorOfGesture), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(labelChange), name: NSNotification.Name(changeLabel), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(labelChangeAgain), name: NSNotification.Name(setPassWordAgain), object: nil)
        //setPassword
        NotificationCenter.default.addObserver(self, selector: #selector(setPWsuccess), name: NSNotification.Name(setPassword), object: nil)
        let keyPwd : String? = UserDefaults.standard.object(forKey: KeyPwd) as? String
        if keyPwd == nil{
            tipLabel.text = "请设置密码"
        }else{
            tipLabel.text = "请输入密码"
        }
        
    }
    @objc private func labelChange(){
        tipLabel.text = "请确定密码"
    }
    @objc private func labelChangeAgain(){
        tipLabel.text = "请接着输入"
    }
    @objc private func setPWsuccess(){
        let alert : UIAlertController = UIAlertController(title: "设置密码成功", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction) in
            UIApplication.shared.keyWindow?.rootViewController = self.defaultVc
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func erroeOfGesture(){
        let alert : UIAlertController = UIAlertController(title: "至少四个点", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func successOfGestur(){
        UIApplication.shared.keyWindow?.rootViewController = defaultVc
    }
    @objc private func pwErrorOfGesture(){
        let alert : UIAlertController = UIAlertController(title: "密码错误", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
