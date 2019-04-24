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
        NotificationCenter.default.post(name: NSNotification.Name(showPhotoBrowserNote), object: self, userInfo: userInfo)
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
            imageView.contentMode = .scaleAspectFill
            labelView.isHidden = true
            let URLString = picURL.absoluteString
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: URLString)
            imageView.image = image
            if (URLString as NSString).lowercased.hasSuffix("gif"){
                labelView.text = "动图"
                labelView.isHidden = false
            }
        }
    }
}



extension PictrueCollectionView : AnimatorPhotoBrowserPresentedDelegate
{
    func startRect(indexPath: IndexPath) -> CGRect {
        let cell = self.cellForItem(at: indexPath)!
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        let picURl = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURl.absoluteString)
        let width : CGFloat = UIScreen.main.bounds.width
        let height : CGFloat = (width  * image!.size.height) / image!.size.width
        print(height)
        var y : CGFloat = 0
        if height > UIScreen.main.bounds.height{
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: width, height: height)
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        let picURl = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURl.absoluteString)
        let imageView : UIImageView = UIImageView()
        imageView.image = image!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
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


