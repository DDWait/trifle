//
//  TitleViewCell.swift
//  trifle
//
//  Created by TOMY on 2019/4/10.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class TitleViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var photoName: UILabel!
    @IBOutlet weak var photoNumber: UILabel!
    
    ///模型属性
    var message : photoMessage? {
        didSet{
            guard let message = message else {
                return
            }
            iconImage.image = message.iconImage
            photoName.text = message.photoName
            photoNumber.text = String(message.photoNumber)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.iconImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
