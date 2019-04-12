//
//  PhotoPickerViewController.swift
//  trifle
//
//  Created by TOMY on 2019/4/9.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import Photos
private let picPickerCell = "picPickerCell"
private let collectionCell = "collectionCell"
private let itemMargin : CGFloat = 2

//代理方法
@objc protocol PhotoBrowserDelegate : NSObjectProtocol {
    func callBack(pubshlishImages : [UIImage])
}

class PhotoPickerViewController: UIViewController {
    private lazy var titltBtn : TitleViewBtn = TitleViewBtn()
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) -> () in
        self?.titltBtn.isSelected = presented
    }
    //代理对象
    weak var delegate : PhotoBrowserDelegate?
    //保存相册对象
    private lazy var collectionNames : [PHAssetCollection] = []
    //图片对象
    private lazy var images : [UIImage] = []
    //被选择的图片的对象
    private lazy var selectesImages : [UIImage] = []
    //保存相册信息
    private  var photoMessages : [photoMessage] {
        var photoMessages : [photoMessage] = []
        photoMessages = checkPhotos()
        return photoMessages
    }
    //上传给publish的数据
    private lazy var publishImage : [UIImage] = []
    //照片对象phasset
    private lazy var phassets : [PHAsset] = []
    //被选中的照片对象
    private lazy var selectedPhassets : [PHAsset] = []
    //照片对象image
    private lazy var originImages : [UIImage] = []
    // 1.创建弹出的控制器
    private let popoverVc : PopoverViewController = PopoverViewController()
    //底部View
    @IBOutlet weak var OriginImage: UIImageView!
    @IBOutlet weak var preViewBtn: UIButton!
    @IBOutlet weak var picCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCollectionView()
        setPopoViewController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let index : IndexPath = IndexPath(row: 0, section: 0)
        popoverVc.tablePickerView.delegate?.tableView!(popoverVc.tablePickerView, didSelectRowAt: index)
    }
}
///设置UI界面
extension PhotoPickerViewController
{
    //navigation
    private func setUI(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: UIBarButtonItem.Style.plain, target: self, action: #selector(sureBtnclick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        titltBtn.setTitle("所有图片", for: UIControl.State.normal)
        titltBtn.addTarget(self, action: #selector(titleBtnClick(titleBtn:)), for: UIControl.Event.touchUpInside)
        navigationItem.titleView = titltBtn
    }
    //设置collectionView
    private func setCollectionView(){
        picCollectionView.dataSource = self
        picCollectionView.delegate = self
        picCollectionView.register(UINib(nibName: "photoPicpickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionCell)
        let layout : UICollectionViewFlowLayout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH : CGFloat = (UIScreen.main.bounds.width - itemMargin * 3) / 4.0
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = itemMargin
        layout.minimumInteritemSpacing = itemMargin
        picCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
///监听事件
extension PhotoPickerViewController
{
    //退出键
    @objc private func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    //确定键
    @objc private func sureBtnclick(){
        publishImage = selectesImages
        delegate!.callBack(pubshlishImages: publishImage)
        dismiss(animated: true, completion: nil)
    }
    //下拉菜单
    @objc private func titleBtnClick(titleBtn : TitleViewBtn) {
        present(popoverVc, animated: true, completion: nil)
    }
    //预览
    @IBAction func preView(_ sender: UIButton) {
        let photoBrowser : PhotoBrowserViewController = PhotoBrowserViewController(images: selectesImages)
        present(photoBrowser, animated: true, completion: nil)
    }
    //原图
    @IBAction func OringinBtn(_ sender: UIButton) {
        OriginImage.isHidden = !OriginImage.isHidden
        if OriginImage.isHidden == false {
            publishImage = self.originImages
        }else{
            publishImage = self.selectesImages
        }
    }
    ///弹出控制器
    private func setPopoViewController(){
        //背景图的设置
        popoverVc.view.backgroundColor = UIColor.white
        popoverVc.backImage.isHidden = true
        popoverVc.tableViewTopCons.constant = 0
        //tableView 的设置
        popoverVc.tablePickerView.dataSource = self as UITableViewDataSource
        popoverVc.tablePickerView.delegate = self as UITableViewDelegate
        popoverVc.tablePickerView.register(UINib(nibName: "TitleViewCell", bundle: nil), forCellReuseIdentifier: picPickerCell)
        // 2.设置控制器的modal样式
        popoverVc.modalPresentationStyle = .custom
        // 3.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        let height : CGFloat = CGFloat(photoMessages.count * 80)
        popoverAnimator.presentedViewFrame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: height)
    }
}
///tableView代理
extension PhotoPickerViewController : UITableViewDataSource,UITableViewDelegate
{
    ///UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: picPickerCell, for: indexPath) as! TitleViewCell
        cell.message = photoMessages[indexPath.row]
        return cell
    }
    ///UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        images.removeAll()
        let collection : PHAssetCollection = collectionNames[indexPath.row]
        try? PHPhotoLibrary.shared().performChangesAndWait {
            let assetArray : PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: nil)
            assetArray.enumerateObjects({ (asset, index, _) in
                let image = self.PhAssetToImage(asset: asset)
                self.images.append(image)
                self.phassets.append(asset)
            })
        }
        self.picCollectionView.reloadData()
    }
}
///相册信息
extension PhotoPickerViewController
{
    private func checkPhotos()->[photoMessage]{
        var collectionMessage : [photoMessage] = []
        //系统相册
        let smartAlbumCollections : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        smartAlbumCollections.enumerateObjects { (collection, index, _) in
            self.collectionNames.append(collection)
            let message : photoMessage = photoMessage(collection: collection)
            collectionMessage.append(message)
        }
        
        //自定义相册
        let albumAollections : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        if albumAollections.count == 0 {
            return collectionMessage
        }
        albumAollections.enumerateObjects { (collection, index, _) in
            self.collectionNames.append(collection)
            let message : photoMessage = photoMessage(collection: collection)
            collectionMessage.append(message)
        }
        return collectionMessage
    }
    ///将PHAseet转为image
    private func PhAssetToImage(asset : PHAsset)->UIImage{
        var image = UIImage()
        let imageManager = PHImageManager.default()
        let imageRequesOption = PHImageRequestOptions()
        imageRequesOption.isSynchronous = true
        imageRequesOption.resizeMode = .fast
        imageRequesOption.deliveryMode = .fastFormat
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 90, height: 90), contentMode: .aspectFill, options: imageRequesOption) { (result, _) in
            image = result ?? UIImage(named: "empty_picture")!
        }
        return image
    }
}
//collectionView数据源
extension PhotoPickerViewController : UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let image = UIImage(named: "IMG_0008")
        images.insert(image!, at: 0)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! photoPicpickerCollectionViewCell
        cell.iconImage.image = images[indexPath.row]
        cell.setDafault()
        let data : Data = cell.iconImage.image!.pngData()!
        for image in selectesImages {
            let OData : Data = image.pngData()!
            if data == OData {
                cell.pickerImage.isHidden = !cell.pickerImage.isHidden
                cell.MView.isHidden = !cell.MView.isHidden
                cell.pickerBtn.isHidden = !cell.pickerBtn.isHidden
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        }
        let cell  = collectionView.cellForItem(at: indexPath) as! photoPicpickerCollectionViewCell
        if cell.pickerImage.isHidden {
            //隐藏
            if selectesImages.count == 9{
                let alert : UIAlertController = UIAlertController(title: "最多选择九张", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "我知道了", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction) in
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            selectesImages.append(cell.iconImage.image!)
            //原图信息
            for asset in phassets{
                let image = PhAssetToImage(asset: asset)
                let imageData : Data = image.pngData()!
                let cellImageData : Data = cell.iconImage.image!.pngData()!
                if imageData == cellImageData{
                    self.selectedPhassets.append(asset)
                    break
                }
            }
        }else{
            let data : Data = cell.iconImage.image!.pngData()!
            //缩略图
            for image in selectesImages {
                let OData : Data = image.pngData()!
                if data == OData {
                    let index = selectesImages.firstIndex(of: image)
                    selectesImages.remove(at: index!)
                    break
                }
            }
            //原图
            for asset in selectedPhassets{
                let image = PhAssetToImage(asset: asset)
                let imageData : Data = image.pngData()!
                if imageData == data{
                    let index = selectedPhassets.firstIndex(of: asset)
                    selectedPhassets.remove(at: index!)
                    break
                }
            }
        }
        cell.pickerImage.isHidden = !cell.pickerImage.isHidden
        cell.MView.isHidden = !cell.MView.isHidden
        cell.pickerBtn.isHidden = !cell.pickerBtn.isHidden
        if selectesImages.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
            preViewBtn.isEnabled = false
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = true
            preViewBtn.isEnabled = true
        }
        originImages.removeAll()
        for asset in selectedPhassets{
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .default, options: nil) { (image, _) in
                self.originImages.append(image!)
            }
        }
    }
}
