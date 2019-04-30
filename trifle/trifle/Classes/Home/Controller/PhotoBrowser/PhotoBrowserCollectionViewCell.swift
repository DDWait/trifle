//
//  PhotoBrowserCollectionViewCell.swift
//  trifle
//
//  Created by TOMY on 2019/4/15.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCollectionViewCellDelegate : NSObjectProtocol {
    func imageViewClick()
}

class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    var picURL : URL?{
        didSet{
            guard let picURL = picURL else {
                return
            }
            let image : UIImage = SDWebImageManager.shared().imageCache!.imageFromDiskCache(forKey: picURL.absoluteString)!
            let width : CGFloat = UIScreen.main.bounds.width
            let height : CGFloat = (width  * image.size.height) / image.size.width
            var y : CGFloat = 0
            if height > UIScreen.main.bounds.height{
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
            }) { (Dimage, _, _, _) in
                guard let dimage = Dimage else{
                    return
                }
                if height > UIScreen.main.bounds.height{
                    self.imageView.frame = CGRect(x: 0, y: y, width: width, height: dimage.size.height)
                    self.scrollView.contentSize = CGSize(width: 0, height: dimage.size.height)
                }
                self.progressView.isHidden = true
            }
        }
    }
    private lazy var scrollView : UIScrollView = UIScrollView()
    var imageView : FLAnimatedImageView = FLAnimatedImageView()
    private lazy var progressView : ProgressView = ProgressView()
    var delegate : PhotoBrowserCollectionViewCellDelegate?
    
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
        scrollView.frame.size.width -= 20
        
        progressView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        progressView.backgroundColor = UIColor.clear
        progressView.isHidden = true
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        tap.delegate = self
        imageView.addGestureRecognizer(tap)
        let longPress : UIGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longpressClick))
        longPress.delegate = self
        imageView.addGestureRecognizer(longPress)
        imageView.isUserInteractionEnabled = true
        
        
    }
    
    @objc private func imageViewClick(){
        delegate?.imageViewClick()
    }
    @objc private func longpressClick(){
        NotificationCenter.default.post(name: NSNotification.Name(showchooseBrowse), object: nil)
    }
    private func getLarghImage(picURL : URL) -> URL{
        let URLString = picURL.absoluteString
        let larghString = URLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: larghString)!
    }
}
//UIGestureRecognizerDelegate
extension PhotoBrowserCollectionViewCell : UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

