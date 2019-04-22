//
//  GestureView.swift
//  手势解锁
//
//  Created by TOMY on 2019/4/22.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
private let KeyPwd : String = "KeyPwd2"
class GestureView: UIView {
    var selectedBtns : [UIButton] = []
    var currentPoint : CGPoint = CGPoint.zero
    var lastPassW : String = "abc"
    var originPassw : String = "abc"
    override func awakeFromNib() {
        setUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setBtnSize()
    }
    override func draw(_ rect: CGRect) {
        if selectedBtns.count > 0{
            let path = UIBezierPath()
            for i in 0..<selectedBtns.count{
                let btn = selectedBtns[i]
                if i == 0{
                    path.move(to: btn.center)
                }else{
                    path.addLine(to: btn.center)
                }
            }
            path.addLine(to: currentPoint)
            path.lineWidth = 10
            path.lineJoinStyle = .round
            UIColor.red.set()
            path.stroke()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let curp = touch.location(in:self)
        for i in 0..<9{
            let btn : UIButton = subviews[i] as! UIButton
            if btn.frame.contains(curp) && btn.isSelected == false{
                btn.isSelected = true
                selectedBtns.append(btn)
                break
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let curp = touch.location(in:self)
        currentPoint = curp
        for i in 0..<9{
            let btn : UIButton = subviews[i] as! UIButton
            if btn.frame.contains(curp) && btn.isSelected == false {
                btn.isSelected = true
                selectedBtns.append(btn)
                break
            }
        }
        setNeedsDisplay()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var passW : String = ""
        for btn in selectedBtns{
            passW = (passW as NSString).appendingFormat("%ld", btn.tag) as String
            btn.isSelected = false
        }
        if selectedBtns.count < 4 {
            NotificationCenter.default.post(name: NSNotification.Name(showErrorOfGesture), object: nil)
            selectedBtns.removeAll()
            setNeedsDisplay()
            return
        }
        selectedBtns.removeAll()
        setNeedsDisplay()
        
        let keyPwd : String? = UserDefaults.standard.object(forKey: KeyPwd) as? String
        if keyPwd == nil {
            //确定密码
            //修改tiplabel
            NotificationCenter.default.post(name: NSNotification.Name(changeLabel), object: nil)
            if originPassw == passW{
                UserDefaults.standard.set(originPassw, forKey: KeyPwd)
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(setPassword), object: nil)
            }else if originPassw != passW && originPassw != "abc"{
                NotificationCenter.default.post(name: NSNotification.Name(setPassWordAgain), object: nil)
            }
            if originPassw == "abc"{
                originPassw = passW
            }
        }else{
            if keyPwd! == passW{
                NotificationCenter.default.post(name: NSNotification.Name(showSuccessOfGesture), object: nil)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(showPwErrorOfGesture), object: nil)
            }
        }
    }
}

extension GestureView
{
    //设置UI界面
    private func setUI(){
        for i in 0..<9{
            let btn = UIButton(type: .custom)
            btn.isUserInteractionEnabled = false
            btn.tag = i
            btn.setImage(UIImage(named: "gesture_node_normal"), for: .normal)
            btn.setImage(UIImage(named: "gesture_node_selected"), for: .selected)
            addSubview(btn)
        }
    }
    //设置尺寸
    private func setBtnSize(){
        var x : CGFloat = 0
        var y : CGFloat = 0
        let btnWh : CGFloat = 74
        
        let column : Int = 3
        let margin : CGFloat = (bounds.width - (btnWh * CGFloat(column))) / (CGFloat(column) + 1)
        var curC : Int = 0
        var curR : Int = 0
        
        
        for i in 0..<9{
            curC = i % column
            curR = i / column
            x = margin + (btnWh + margin) * CGFloat(curC)
            y = margin + (btnWh + margin) * CGFloat(curR)
            let btn : UIButton = subviews[i] as! UIButton
            btn.frame = CGRect(x: x, y: y, width: btnWh, height: btnWh)
        }
    }
}
