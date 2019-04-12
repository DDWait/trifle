//
//  PicpickerCollectionView.swift
//  trifle
//
//  Created by TOMY on 2019/4/9.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let margin : CGFloat = 15



class PicpickerCollectionView: UICollectionView {
    
    var images : [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout  = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * margin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        contentInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
        
        register(UINib(nibName: "PicpickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
    }
}

extension PicpickerCollectionView : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count == 9 {
            return images.count
        }else{
            return images.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicpickerCollectionViewCell
        if images.count == 9 {
            cell.image = images[indexPath.item]
        }else{
            cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        }
        
        return cell
    }
}



