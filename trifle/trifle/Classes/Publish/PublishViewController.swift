//
//  PublishViewController.swift
//  trifle
//
//  Created by TOMY on 2019/4/8.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController {

    @IBOutlet weak var textView: ComposeTextView!
    private lazy var composeTitleView : ComposeTitleView = ComposeTitleView()
    
    
    @IBOutlet weak var toolBarBottom: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewH: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.tintColor = UIColor.white
        setUpNavItem()
        //监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension PublishViewController
{
    private func setUpNavItem(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItem.Style.plain, target: self, action: #selector(senfItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        composeTitleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = composeTitleView
    }
}

///事件监听
extension PublishViewController
{
    //取消
    @objc private func closeItemClick(){
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    //发送
    @objc private func senfItemClick(){
        print("senfItemClick")
    }
    //键盘
    @objc private func keyboardWillChangeFrame(note : Notification){
        //时间
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        //位置
        let endFrmae = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let margin = UIScreen.main.bounds.height - endFrmae.origin.y
        toolBarBottom.constant = -margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    //相册按钮
    @IBAction func picPickerBtnClick() {
        textView.resignFirstResponder()
        let photoVc = UIStoryboard(name: "PhotoPickerViewController", bundle: nil).instantiateInitialViewController()
        
        present(photoVc!, animated: true, completion: nil)
        
//        picPickerViewH.constant = UIScreen.main.bounds.height * 0.8
//        UIView.animate(withDuration: 0.5) {
//            self.view.layoutIfNeeded()
//        }
    }
}

extension PublishViewController : UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
