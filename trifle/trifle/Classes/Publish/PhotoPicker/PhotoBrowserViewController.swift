//
//  PhotoBrowserController.swift
//  trifle
//
//  Created by TOMY on 2019/4/11.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SnapKit

private let photoBrowserCell = "photoBrowserCell"
class PhotoBrowserViewController: UIViewController {
    var images : [UIImage]
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserPushlishViewLayout())
    private lazy var tipLabel : UILabel = UILabel()
    private lazy var colseBtn : UIButton = UIButton()
    private lazy var num : String = String(self.images.count)
    override func loadView() {
        super.loadView()
        view.bounds.size.width += 20
    }
    
    init(images : [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension PhotoBrowserViewController
{
    private func setUI(){
        view.addSubview(collectionView)
        view.addSubview(tipLabel)
        view.addSubview(colseBtn)
        collectionView.frame = view.bounds
        collectionView.register(PhotoBrowserPushlishViewCell.self, forCellWithReuseIdentifier: photoBrowserCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(UIScreen.main.bounds.width * 0.5)
        }
        colseBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(collectionView.snp.bottom).offset(-20)
            make.centerX.equalTo(UIScreen.main.bounds.width * 0.5)
        }
        tipLabel.textColor = UIColor.white
        tipLabel.sizeToFit()
        colseBtn.setTitle("确定", for: UIControl.State.normal)
        colseBtn.addTarget(self, action: #selector(closeBtnClick), for: UIControl.Event.touchUpInside)
        colseBtn.sizeToFit()
        tipLabel.text = "1 / \(num)"
        tipLabel.textAlignment = .center
    }
    @objc private func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoBrowserViewController : UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCell, for: indexPath) as! PhotoBrowserPushlishViewCell
        cell.image = images[indexPath.row]
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x : CGFloat = scrollView.contentOffset.x
        let width : CGFloat = UIScreen.main.bounds.width + 20
        let index = Int(x / width)
        let Newnum = String(index + 1)
        tipLabel.text = "\(Newnum) / \(num)"
    }
}


class PhotoBrowserPushlishViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
