//
//  CommentCell.swift
//  评论
//
//  Created by TOMY on 2019/4/23.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage
//边距宽度
private let edgeMargin : CGFloat = 15
class CommentTableCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabelConW: NSLayoutConstraint!
    
    
    var viewModel : Comment?{
        didSet{
            guard let viewModel = viewModel else {
                return
            }
            //设置头像
            let profileURL = URL(string: (viewModel.user?.profile_image_url)!)
            iconImage.sd_setImage(with: profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            //设置昵称
            screenName.text = viewModel.user?.screen_name
            //设置正文
            contentLabel.attributedText = FineEmoticon.shareInstance.fineAttrituString(statusText: viewModel.text, font: contentLabel.font)
            contentLabel.numberOfLines = 0
            if let created_at = viewModel.created_at {
                timeLabel.text = NSDate.createDateString(createAtStr: created_at)
            }
        }
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabelConW.constant = UIScreen.main.bounds.width - edgeMargin - 65
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
