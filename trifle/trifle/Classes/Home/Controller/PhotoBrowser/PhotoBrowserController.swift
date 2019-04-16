//
//  PhotoBrowserController.swift
//  trifle
//
//  Created by TOMY on 2019/4/15.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SnapKit
import Photos
private let photoBrowserCell = "photoBrowserCell"
//获得APP 的名字
private let appTitle : String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
class PhotoBrowserController: UIViewController {
    var indexPath : IndexPath
    var picURLS : [URL]
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewFlowLayout())
    private lazy var closeBtn : UIButton = UIButton()
    private lazy var saveBtn : UIButton = UIButton()
    private var image : UIImage?
    init(indexPath : IndexPath,picURLS : [URL]){
        self.indexPath = indexPath
        self.picURLS = picURLS
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        view.bounds.size.width += 20
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
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
        let cell : PhotoBrowserCollectionViewCell = collectionView.visibleCells.first as! PhotoBrowserCollectionViewCell
        guard let image = cell.imageView.image else {
            return
        }
        self.image = image
        let oldStatus : PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        PHPhotoLibrary.requestAuthorization { (status : PHAuthorizationStatus) in
            //回到主线程
            DispatchQueue.main.async {
                if status == PHAuthorizationStatus.denied{
                    if oldStatus != PHAuthorizationStatus.notDetermined{
                        print("提醒用户打开开关")
                    }
                }else if status == PHAuthorizationStatus.authorized{
                    self.savePhoto()
                }else if status == PHAuthorizationStatus.restricted{
                    print("因为系统原因无法打开相册")
                }
            }
        }
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
        cell.delegate = self
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
extension PhotoBrowserController : PhotoBrowserCollectionViewCellDelegate
{
    func imageViewClick() {
        dismiss(animated: true, completion: nil)
    }
}


extension PhotoBrowserController
{
    private func createAsset()->PHFetchResult<PHAsset>{
        var assetID : String? = nil
        try? PHPhotoLibrary.shared().performChangesAndWait {
            assetID = PHAssetChangeRequest.creationRequestForAsset(from: self.image!).placeholderForCreatedAsset?.localIdentifier
        }
        return PHAsset.fetchAssets(withLocalIdentifiers: [assetID!], options: nil)
    }
    ///保存一张照片
    private func savePhoto(){
        //同步
        //保存到系统相册
        //获得照片
        let createAssets : PHFetchResult<PHAsset> = self.createAsset()
        //将保存的照片保存到自定义相册
        let collection : PHAssetCollection = self.createPhotoCollection()
        try? PHPhotoLibrary.shared().performChangesAndWait {
            let requset = PHAssetCollectionChangeRequest(for: collection)
            requset?.insertAssets(createAssets, at: IndexSet(integer: 0))
        }
    }
    ///获得一个自定义的相册，没有就创建
    private func createPhotoCollection() -> PHAssetCollection{
        let collections : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        var array : [PHAssetCollection] = []
        collections.enumerateObjects { (collection, index, _) in
            array.append(collection)
        }
        for collection in array{
            if collection.localizedTitle! == appTitle{
                return collection
            }
        }
        //创建过程
        var createCollectionID : String? = nil
        try? PHPhotoLibrary.shared().performChangesAndWait {
            createCollectionID = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: appTitle).placeholderForCreatedAssetCollection.localIdentifier
        }
        return PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [createCollectionID!], options: nil).firstObject!
        
    }
}
