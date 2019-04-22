//
//  ADViewController.swift
//  trifle
//
//  Created by TOMY on 2019/4/22.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
class ADViewController: UIViewController {
    var timer : Timer?
    var interval : Int = 5
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleToFill
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(imageViewTouchAction))
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    lazy var skipBtn : UIButton = {
        let skipBtn = UIButton()
        skipBtn.backgroundColor = UIColor(white: 0, alpha: 0.1)
        skipBtn.setTitle("跳过广告\(interval)s", for: .normal)
        skipBtn.setTitleColor(UIColor.white, for: .normal)
        skipBtn.titleLabel?.font = .systemFont(ofSize: 12)
        skipBtn.layer.cornerRadius = 15
        skipBtn.layer.masksToBounds = true
        skipBtn.addTarget(self, action: #selector(dismissedForWindow), for: .touchUpInside)
        return skipBtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}
extension ADViewController
{
    //点击图片
    @objc private func imageViewTouchAction(){
        let url : URL = URL(string: "http://jump.luna.58.com/r?cate=dianqi&spm=.24560098&utm_source=sem-baidu-qiushi")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        dismissedForWindow()
    }
    //点击跳过
    @objc private func dismissedForWindow(){
        if timer != nil {
            //如果定时器是开启状态
            if timer!.isValid {
                //关闭定时器
                timer!.invalidate()
            }
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.view.alpha = 0
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "GestureViewController", bundle: nil).instantiateInitialViewController()
        }
    }
    
    //ori_curl : http://jump.luna.58.com/r?cate=dianqi&spm=.24560098&utm_source=sem-baidu-qiushi
    //w_picurl : http://ubmcmm.baidustatic.com/media/v1/0f000jlojiFHrwuMPvRHl6.jpg
    private func setUI(){
        view.addSubview(imageView)
        view.backgroundColor = UIColor.white
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        imageView.setImageWith(URL(string: "http://ubmcmm.baidustatic.com/media/v1/0f000jlojiFHrwuMPvRHl6.jpg")!)
        
        guard let window = UIApplication.shared.delegate?.window else {
            dismissedForWindow()
            return
        }
        window?.isHidden = false
        window?.addSubview(view)
        view.addSubview(skipBtn)
        skipBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-25)
            make.size.equalTo(CGSize(width: 80, height: 30))
        }
        //开启定时器
        startTimer()
    }
    private func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerInterval), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc private func timerInterval(){
        interval -= 1
        if interval <= 0 {
            interval = 0
            dismissedForWindow()
            return
        }
        skipBtn.setTitle("跳过广告\(interval)s", for: .normal)
    }
}
