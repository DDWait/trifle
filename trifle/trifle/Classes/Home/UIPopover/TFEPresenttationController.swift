//
//  TFEPresenttationController.swift
//  trifle
//
//  Created by TOMY on 2019/3/26.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class TFEPresenttationController: UIPresentationController {
    //朦板
    private lazy var coverView : UIView = UIView()
    //提供对外的设置frame的属性
    var presentedViewFrame : CGRect = CGRect.zero
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //设置弹出view的尺寸和位置
        presentedView?.frame = presentedViewFrame
        //朦板
        setUpCoverView()
    }
}

//UI界面
extension TFEPresenttationController
{
    private func setUpCoverView(){
        //添加朦板
//        containerView?.addSubview(coverView)  //会盖住xib
        containerView?.insertSubview(coverView, at: 0)
        //设置颜色
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        coverView.frame = containerView?.bounds ?? CGRect.zero
        //设置手势
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coverViewDidClicked))
        coverView.addGestureRecognizer(tap)
    }
}
//事件监听
extension TFEPresenttationController
{
    //朦板
    @objc private func coverViewDidClicked(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
