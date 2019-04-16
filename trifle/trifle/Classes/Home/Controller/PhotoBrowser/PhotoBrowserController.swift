//
//  PhotoBrowserController.swift
//  trifle
//
//  Created by TOMY on 2019/4/15.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SnapKit

private let photoBrowserCell = "photoBrowserCell"
class PhotoBrowserController: UIViewController {
    var indexPath : IndexPath
    var picURLS : [URL]
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewFlowLayout())
    private lazy var closeBtn : UIButton = UIButton()
    private lazy var saveBtn : UIButton = UIButton()
    init(indexPath : IndexPath,picURLS : [URL]){
        self.indexPath = indexPath
        self.picURLS = picURLS
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
//UI界面
extension PhotoBrowserController
{
    private func setUI(){
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        closeBtn.backgroundColor = UIColor.darkGray
        closeBtn.setTitle("关 闭", for: UIControl.State.normal)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        saveBtn.backgroundColor = UIColor.darkGray
        saveBtn.setTitle("保 存", for: UIControl.State.normal)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        collectionView.register(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: photoBrowserCell)
        collectionView.dataSource = self
    }
}
//事件监听
extension PhotoBrowserController {
    @objc private func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    @objc private func saveBtnClick(){
        print("saveBtnClick")
    }
}
extension PhotoBrowserController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLS.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCell, for: indexPath) as! PhotoBrowserCollectionViewCell
        cell.picURL = picURLS[indexPath.item]
        return cell
    }
}


class PhotoBrowserCollectionViewFlowLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
