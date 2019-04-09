//
//  ComposeTextView.swift
//  trifle
//
//  Created by TOMY on 2019/4/8.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTextView: UITextView {

    lazy var placeHolderLabel : UILabel = UILabel()
    
    //一般用于添加子控件
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    //对子控件进行调整
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
extension ComposeTextView
{
    private func setUI(){
        addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(10)
        }
        
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        placeHolderLabel.text = "分享新鲜事..."
        
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7)
    }
}
