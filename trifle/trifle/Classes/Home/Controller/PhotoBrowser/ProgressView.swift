//
//  progressView.swift
//  trifle
//
//  Created by TOMY on 2019/4/16.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    var progress : CGFloat = 0{
        didSet{
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = -CGFloat.pi/2
        let endAngle = 2 * CGFloat.pi * progress + startAngle
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: center)
        path.close()
        UIColor(white: 1.0, alpha: 0.4).setFill()
        path.fill()
    }
}
