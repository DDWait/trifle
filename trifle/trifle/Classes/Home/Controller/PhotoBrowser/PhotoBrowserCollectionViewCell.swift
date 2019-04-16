//
//  PhotoBrowserCollectionViewCell.swift
//  trifle
//
//  Created by TOMY on 2019/4/15.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage
class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    var picURL : URL?{
        didSet{
            guard let picURL = picURL else {
                return
            }
            let image : UIImage = SDWebImageManager.shared().imageCache!.imageFromDiskCache(forKey: picURL.absoluteString)!
            let width : CGFloat = UIScreen.main.bounds.width
            let height : CGFloat = (width  * image.size.height) / image.size.width
            print(height)
            var y : CGFloat = 0
            if height > UIScreen.main.bounds.height{
                print("长图")
                print(image)
                y = 0
            }else{
                y = (UIScreen.main.bounds.height - height) * 0.5
            }
            imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
            scrollView.contentSize = CGSize(width: 0, height: height)
            //大图
            progressView.isHidden = false
            imageView.sd_setImage(with: getLarghImage(picURL: picURL), placeholderImage: image, options: [], progress: { (current, total, _) in
                self.progressView.progress = CGFloat(current) / CGFloat(total)
            }) { (_, _, _, _) in
                self.progressView.isHidden = true
            }
        }
    }
    private lazy var scrollView : UIScrollView = UIScrollView()
    private lazy var imageView : UIImageView = UIImageView()
    private lazy var progressView : ProgressView = ProgressView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PhotoBrowserCollectionViewCell
{
    private func setUI(){
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        scrollView.frame = contentView.bounds
//        scrollView.frame.size.width -= 20
        
        progressView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        progressView.backgroundColor = UIColor.clear
        progressView.isHidden = true
    }
    
    
    private func getLarghImage(picURL : URL) -> URL{
        let URLString = picURL.absoluteString
        let larghString = URLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: larghString)!
    }
}
