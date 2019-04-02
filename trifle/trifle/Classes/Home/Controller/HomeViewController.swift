//
//  HomeViewController.swift
//  trifle
//
//  Created by TOMY on 2019/3/25.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    //属性
    var scrollView : UIScrollView = UIScrollView()
    var firstVc : HotViewController = UIStoryboard(name: "HotViewController", bundle: nil).instantiateInitialViewController() as! HotViewController
    var secondVc : CloseViewController = CloseViewController()
    private var titleView : titleScrollView = titleScrollView(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //适应ScrollView
        self.automaticallyAdjustsScrollViewInsets = false
        //scrollView 的布置
        view.addSubview(scrollView)
        //大小
        let width : CGFloat = UIScreen.main.bounds.width
        let height : CGFloat = UIScreen.main.bounds.height - 64
        self.scrollView.frame = CGRect(x: 0, y: 64, width: width, height: height)
        //属性
        scrollView.contentSize = CGSize(width: width * 2, height: height)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        //添加控制器
        self.addChild(firstVc)
        self.addChild(secondVc)
        firstVc.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.height)
        secondVc.view.frame = CGRect(x: width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.height)
        scrollView.addSubview(firstVc.view)
        scrollView.addSubview(secondVc.view)
        scrollView.delegate = self as UIScrollViewDelegate
        //设置titleView
        navigationItem.titleView = titleView
        titleView.scrollView = self.scrollView
        
        setUpNav()
        
    }
}

extension HomeViewController : UIScrollViewDelegate
{
    //UIScrollView代理方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let n : Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width);
        let btn : TitleBtn = self.titleView.viewWithTag(n + 10) as! TitleBtn
        self.titleView.btnDidClick(btn: btn)
    }
    
    
    //导航条设置
    private func setUpNav(){
        //设置titleView
        navigationItem.titleView = titleView
        titleView.scrollView = self.scrollView
        
        //设置按钮
        //相机
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cameraDidClicked))
        //下拉菜单
        let rightBtn = UIButton()
        rightBtn.setImage(UIImage(named: "MainTagSubIcon"), for: UIControl.State.normal)
        rightBtn.setImage(UIImage(named: "MainTagSubIconClick"), for: UIControl.State.highlighted)
        rightBtn.sizeToFit()
        rightBtn.addTarget(self, action: #selector(rightBtnDidClicked), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
    }
    
    ///导航条监听
    ///相机
    @objc private func cameraDidClicked(){
        print("cameraDidClicked")
    }
    ///下拉菜单
    @objc private func rightBtnDidClicked(){
        //创建popover控制器
        let popover = PopoverViewController()
        //设置modal的样式(如果不设置，在该控制器modal之后，其他的控制器都会释放)
        popover.modalPresentationStyle = .custom
        //设置转场动画和控制器的大小
        popover.transitioningDelegate = popoverAnimator
        let width : CGFloat = 150
        let height : CGFloat = 280
        let x : CGFloat = UIScreen.main.bounds.size.width - width - 10
        popoverAnimator.presentedViewFrame = CGRect(x: x, y: 50, width: width, height: height)
        //弹出控制器
        present(popover, animated: true, completion: nil)
    }
}
