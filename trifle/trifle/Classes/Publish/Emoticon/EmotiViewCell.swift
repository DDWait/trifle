//
//  EmojiViewCell.swift
//  emoji
//
//  Created by TOMY on 2019/2/3.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class EmotiViewCell: UICollectionViewCell {
    // MARK:-懒加载属性
    private lazy var emoticonBtn : UIButton = UIButton()
    // MARK:-定义的属性
    var emoticon : Emoticon?{
        didSet{
            guard let emoticon = emoticon else {
                return
            }
            //设置emotioconBtn的内容
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            if emoticon.isRemove{
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK:-设置UI界面
extension EmotiViewCell
{
    private func setupUI(){
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = contentView.bounds
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}

