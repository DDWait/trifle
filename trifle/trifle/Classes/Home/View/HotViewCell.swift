//
//  HotViewCell.swift
//  trifle
//
//  Created by TOMY on 2019/4/2.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage
//边距宽度
private let edgeMargin : CGFloat = 15
//配图间距
private let itemMargin : CGFloat = 10

class HotViewCell: UITableViewCell {
    //正文宽度约束
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHcons: NSLayoutConstraint!
    @IBOutlet weak var picViewWcons: NSLayoutConstraint!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picView: PictrueCollectionView!
    
    //模型属性
    var viewModel : StatusViewTool? {
        didSet{
            guard let viewModel = viewModel else {
                return
            }
            
            //设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            //设置昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            //设置时间
            timeLabel.text = viewModel.createdatText
            //设置来源
            sourceLabel.text = viewModel.sourceText
            //设置正文
            contentLabel.text = viewModel.status?.text
            
            //计算picView的宽高
            let picViewSize : CGSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewHcons.constant = picViewSize.height
            picViewWcons.constant = picViewSize.width
            
            //设置picview数据
            picView.picURLs = viewModel.picURLs
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - (2 * edgeMargin)
        //设置PicView
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        //计算image的宽高
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension HotViewCell
{
    private func calculatePicViewSize(count : Int) -> CGSize {
        //没有配图
        if count == 0 {
            return CGSize.zero
        }
        
        //单张图片展示
        
        
        //计算image的宽高
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        //四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + 2 * itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        //其他张配图
        //计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        //计算image的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        //计算宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        return CGSize(width: picViewW, height: picViewH)
    }
}