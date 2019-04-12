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
    @IBOutlet weak var collectionView: PicpickerCollectionView!
    
    private var images : [UIImage] = []
    @IBOutlet weak var toolBarBottom: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewH: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.tintColor = UIColor.white
        setUpNavItem()
        setUpNotification()
        //监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if picPickerViewH.constant == 0 {
            textView.becomeFirstResponder()
        }
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
    //通知
    private func setUpNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(removeBtnclick(note:)), name: NSNotification.Name(PicPickerRemovePhotoNote), object: nil)
        //PicPickerAddPhotoNote
        NotificationCenter.default.addObserver(self, selector: #selector(picPickerBtnClick), name: NSNotification.Name(PicPickerAddPhotoNote), object: nil)
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
    @objc private func removeBtnclick(note : Notification){
        guard let image = note.object as? UIImage else {
            return
        }
        guard let index = images.firstIndex(of: image) else {
            return
        }
        images.remove(at: index)
        collectionView.images = images
        collectionView.reloadData()
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
        let photoVc : UINavigationController = UIStoryboard(name: "PhotoPickerViewController", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let rootVc : PhotoPickerViewController = photoVc.viewControllers.first as! PhotoPickerViewController
        rootVc.delegate = self
        present(photoVc, animated: true) {
            self.picPickerViewH.constant = UIScreen.main.bounds.height * 0.7
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
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
extension PublishViewController : PhotoBrowserDelegate
{
    func callBack(pubshlishImages: [UIImage]) {
        //更新cell
        self.images = pubshlishImages
        collectionView.images = pubshlishImages
        collectionView.reloadData()
        textView.resignFirstResponder()
    }
}
