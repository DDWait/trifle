//
//  PicpickerCollectionViewCell.swift
//  trifle
//
//  Created by TOMY on 2019/4/9.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class PicpickerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var iconView: UIImageView!
    var image : UIImage? {
        didSet{
            if image != nil {
                iconView.image = image
                addPhotoBtn.isUserInteractionEnabled = false
                removeBtn.isHidden = false
            }else{
                iconView.image = nil
                addPhotoBtn.isUserInteractionEnabled = true
                removeBtn.isHidden = true
            }
        }
    }

    @IBAction func addPhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(PicPickerAddPhotoNote), object: nil)
    }
    @IBAction func removePhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(PicPickerRemovePhotoNote), object: iconView.image)
    }
    

}
