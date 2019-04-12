//
//  photoPicpickerCollectionView cell.swift
//  trifle
//
//  Created by TOMY on 2019/4/11.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class photoPicpickerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var MView: UIView!
    @IBOutlet weak var pickerBtn: UIButton!
    @IBOutlet weak var pickerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }    
    func setDafault(){
        pickerImage.isHidden = true
        MView.isHidden = true
        pickerBtn.isHidden = true
    }
}
