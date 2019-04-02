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
    }
}

extension PictrueCollectionView : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PictrueCollectionCell
        
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
    
}


class PictrueCollectionCell : UICollectionViewCell
{
    @IBOutlet weak var iconImage: UIImageView!
    
    var picURL : URL? {
        didSet{
            guard let picURL = picURL else {
                return
            }
            iconImage.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
}
