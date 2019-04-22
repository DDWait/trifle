//
//  titleScrollView.swift
//  scrollViewAndsegmented
//
//  Created by TOMY on 2019/3/24.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class titleScrollView: UIView {
    private var underLineView : UIView = UIView()
    private var lastSelectedBtn : TitleBtn = TitleBtn()
    private var titles : [String]?
    var scrollView : UIScrollView?
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTitles(titles : [String]){
        self.titles = titles
        setViewsTitles()
    }
}
//titleView
extension titleScrollView
{
    private func setViewsTitles(){
        backgroundColor = UIColor.clear
        //布置view上的按钮
        setTitlesBtn()
        //下划线
        setBtnUnderLines()
    }
    //布置view上的按钮
    private func setTitlesBtn(){
        let array : [String] = self.titles!
        var x  : CGFloat = 0
        let W : CGFloat = frame.size.width / CGFloat(array.count)
        let H : CGFloat = frame.size.height
        for i in 0..<array.count{
            let btn : TitleBtn = TitleBtn()
            btn.tag = i + 10
            x = CGFloat(i) * W
            btn.frame = CGRect(x: x, y: 0, width: W, height: H - 2)
            //设置文字
            btn.setTitle(array[i], for: UIControl.State.normal)
            //设置监听
            btn.addTarget(self, action: #selector(btnDidClick(btn:)), for: UIControl.Event.touchUpInside)
            
            addSubview(btn)
        }
    }
    
    //布置下划线
    private func setBtnUnderLines() {
        //获取第一个按钮
        let firstBtn : TitleBtn = subviews.first as! TitleBtn
        underLineView.frame.size.height = 2
        underLineView.frame.size.width = 10
        underLineView.frame.origin.y = frame.size.height - underLineView.frame.size.height
        underLineView.backgroundColor = firstBtn.titleColor(for: UIControl.State.selected)
        addSubview(underLineView)
        //程序一开始
        firstBtn.isSelected = true
        lastSelectedBtn = firstBtn
        firstBtn.titleLabel?.sizeToFit()
        
        underLineView.frame.size.width = (firstBtn.titleLabel?.frame.size.width)! + 10
        underLineView.center.x = firstBtn.center.x
    }
    
    @objc func btnDidClick(btn : TitleBtn){
        lastSelectedBtn.isSelected = false
        btn.isSelected = true
        lastSelectedBtn = btn
        
        //移动下划线
        UIView.animate(withDuration: 0.3) {
            self.underLineView.frame.size.width = btn.titleLabel!.frame.size.width + 10
            self.underLineView.center.x = btn.center.x
            
            //滑动scrollView
            let offsetX : CGFloat = self.scrollView!.frame.size.width * CGFloat(btn.tag - 10)
            self.scrollView?.contentOffset = CGPoint(x: offsetX, y: self.scrollView!.contentOffset.y)
        }
    }
    
}
