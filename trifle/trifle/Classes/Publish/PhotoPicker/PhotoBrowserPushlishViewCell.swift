//
//  PhotoBrowserPushlishViewCell.swift
//  trifle
//
//  Created by TOMY on 2019/4/11.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class PhotoBrowserPushlishViewCell: UICollectionViewCell {
    var image : UIImage?{
        didSet{
            guard let image = image else {
                return
            }
            let width : CGFloat = UIScreen.main.bounds.width
            let height : CGFloat = width / image.size.width * image.size.height
            var y : CGFloat = 0
            if height > UIScreen.main.bounds.height{
                y = 0
            }else{
                y = (UIScreen.main.bounds.height - height) * 0.5
            }
            imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
            imageView.image = image
            scrollView.contentSize = CGSize(width: 0, height: height)
        }
    }
    
    private lazy var scrollView : UIScrollView = UIScrollView()
    private lazy var imageView : UIImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBrowserPushlishViewCell
{
    private func setUI(){
        contentView.addSubview(scrollView)
        contentView.addSubview(imageView)
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
    }
}
