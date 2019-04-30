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
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedLabelTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picView: PictrueCollectionView!
    @IBOutlet weak var retweetContentLabel: UILabel!
    @IBOutlet weak var retweetBg: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var commentNum: UIButton!
    
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
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自" + sourceText
            }else{
                sourceLabel.text = nil
            }
            
            //设置正文
            contentLabel.attributedText = FineEmoticon.shareInstance.fineAttrituString(statusText: viewModel.status?.text, font: contentLabel.font)
            
            //计算picView的宽高
            let picViewSize : CGSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewHcons.constant = picViewSize.height
            picViewWcons.constant = picViewSize.width
            
            //设置picview数据
            picView.picURLs = viewModel.picURLs
            
            //设置转发文字
            if viewModel.status?.retweeted_status != nil{
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,let retweetText = viewModel.status?.retweeted_status?.text{
                    let text  = "@" + "\(screenName): " + retweetText
                    retweetContentLabel.attributedText = FineEmoticon.shareInstance.fineAttrituString(statusText: text, font: retweetContentLabel.font)
                    retweetedLabelTopCons.constant = 15
                }
                retweetBg.isHidden = false
            }else{
                retweetContentLabel.text = nil
                retweetBg.isHidden = true
                retweetedLabelTopCons.constant = 0
            }
            //设置转发数量
            retweetBtn.setTitle("转发(\(viewModel.reposts))", for: .normal)
            //设置评论数量
            commentNum.setTitle("评论(\(viewModel.comments))", for: .normal)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - (2 * edgeMargin)
        retweetBtn.addTarget(self, action: #selector(retweetStatus), for: .touchUpInside)
        commentNum.addTarget(self, action: #selector(commentNumClick), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func retweetStatus(){
        NotificationCenter.default.post(name: NSNotification.Name(youMengShare), object: viewModel)
    }
    @objc private func commentNumClick(){
        NotificationCenter.default.post(name: NSNotification.Name(commentBtnClick), object: viewModel)
    }
}

extension HotViewCell
{
    private func calculatePicViewSize(count : Int) -> CGSize {
        //没有配图
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        
        picViewBottomCons.constant = 10
        //设置PicView
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout

        //单张图片展示
        if count == 1 {
            let URLString = viewModel!.picURLs.first!.absoluteString
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: URLString)
            layout.itemSize = CGSize(width: image!.size.width * 2, height: image!.size.height * 2)
            return CGSize(width: image!.size.width * 2, height: image!.size.height * 2)
        }
        
        //计算image的宽高
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
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
