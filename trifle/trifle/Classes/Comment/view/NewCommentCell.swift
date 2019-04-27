//
//  NewCommentCell.swift
//  trifle
//
//  Created by TOMY on 2019/4/25.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage
//边距宽度
private let edgeMargin : CGFloat = 15
class NewCommentCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var Screen_Name: UILabel!
    @IBOutlet weak var ContentL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var contentLConW: NSLayoutConstraint!
    @IBAction func DbtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func replyBtnClick() {
        NotificationCenter.default.post(name: NSNotification.Name(replyComment), object: nil)
    }
    
    var viewModel : Comment?{
        didSet{
            guard let viewModel = viewModel else {
                return
            }
            //设置头像
            let profileURL = URL(string: (viewModel.user?.profile_image_url)!)
            iconImageView.sd_setImage(with: profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            //设置昵称
            Screen_Name.text = viewModel.user?.screen_name
            //设置正文
            ContentL.attributedText = FineEmoticon.shareInstance.fineAttrituString(statusText: viewModel.text, font: ContentL.font)
            if let created_at = viewModel.created_at {
                timeL.text = NSDate.createDateString(createAtStr: created_at)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLConW.constant = UIScreen.main.bounds.width - edgeMargin - 65
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
