//
//  NewFeatureViewController.swift
//  trifle
//
//  Created by TOMY on 2019/4/21.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class NewFeatureViewController: UIViewController {
    private lazy var scrollView : UIScrollView = UIScrollView(frame: self.view.bounds)
    private lazy var pageControl : UIPageControl = UIPageControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}
extension NewFeatureViewController
{
    private func setUI(){
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        //添加图片
        let scrollW : CGFloat = scrollView.bounds.width
        let scrollH : CGFloat = scrollView.bounds.height
        for i in 0...3{
            let imageView : UIImageView = UIImageView(frame: CGRect(x: CGFloat(i) * scrollW, y: 0, width: scrollW, height: scrollH))
            imageView.contentMode = .scaleAspectFill
            let imageName : String = "Feature\(i+1)Background"
            imageView.image = UIImage(named: imageName)
            scrollView.addSubview(imageView)
            
            if i == 3 {
                setupLastImageView(imageView: imageView)
            }
        }
        //scollView属性
        scrollView.contentSize = CGSize(width: 4.0 * scrollW, height: 0)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        //pageControl
        pageControl.numberOfPages = 4
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.center.x = scrollW * 0.5
        pageControl.center.y = scrollH - 50
    }
    private func setupLastImageView(imageView : UIImageView){
        imageView.isUserInteractionEnabled = true
        let btn : UIButton = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "guideStart"), for: .normal)
        btn.frame.size = btn.currentBackgroundImage!.size
        btn.center.x = imageView.frame.size.width * 0.5
        btn.center.y = imageView.frame.size.height * 0.85
        btn.addTarget(self, action: #selector(startClick), for: .touchUpInside)
        imageView.addSubview(btn)
    }
    @objc private func startClick(){
        let window : UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = UIStoryboard(name: "GestureViewController", bundle: nil).instantiateInitialViewController()
    }
}

extension NewFeatureViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page : CGFloat = scrollView.contentOffset.x / scrollView.bounds.width
        pageControl.currentPage = Int(page + 0.5)
    }
}
