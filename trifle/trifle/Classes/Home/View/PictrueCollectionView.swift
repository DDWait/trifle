//
//  PictrueCollectionView.swift
//  trifle
//
//  Created by TOMY on 2019/4/2.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage

class PictrueCollectionView: UICollectionView {
    //定义模型数组
    var picURLs : [URL] = [URL](){
        didSet{
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
    }
}

extension PictrueCollectionView : UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PictrueViewCell
        
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo = ["indexPath" : indexPath,"picURLs" : picURLs] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(showPhotoBrowserNote), object: nil, userInfo: userInfo)
    }
    
    
}

class PictrueViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    var picURL : URL? {
        didSet{
            guard let picURL = picURL else {
                return
            }
            labelView.isHidden = true
            let URLString = picURL.absoluteString
            imageView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
            if (URLString as NSString).lowercased.hasSuffix("gif"){
                labelView.text = "动图"
                labelView.isHidden = false
            }
        }
    }
}

//extension PictrueViewCell
//{
//    ///长图处理
//    private func fitImage(image : UIImage){
//        let imageW : CGFloat = UIScreen.main.bounds.width * 0.5
//        let imageH : CGFloat = imageW * image.size.height / image.size.width
//        UIGraphicsBeginImageContext(CGSize(width: imageW, height: imageH))
//        imageView.image!.draw(in: CGRect(x: 0, y: 0, width: imageW, height: imageH))
//        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//    }
//}


