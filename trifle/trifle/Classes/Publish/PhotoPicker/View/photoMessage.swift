//
//  photoMessage.swift
//  trifle
//
//  Created by TOMY on 2019/4/10.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import Photos
class photoMessage: NSObject {
    var photoName : String
    var iconImage : UIImage?
    var photoNumber : Int = 0
    
    init(collection : PHAssetCollection)
    {
        photoName = collection.localizedTitle!
        super.init()
        self.firstPhotoOfCollection(collection: collection)
    }
}


extension photoMessage
{
    ///取得相册的第一张图片和数量
    private func firstPhotoOfCollection(collection : PHAssetCollection){
        try? PHPhotoLibrary.shared().performChangesAndWait {
            let assetArray : PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: nil)
            self.photoNumber = assetArray.count
            guard let imageAsset = assetArray.firstObject else{
                self.iconImage = UIImage(named: "empty_picture")
                return
            }
            self.iconImage = self.PhAssetToImage(asset: imageAsset)
        }
    }
    ///将PHAseet转为image
    private func PhAssetToImage(asset : PHAsset)->UIImage{
        var image = UIImage()
        let imageManager = PHImageManager.default()
        let imageRequesOption = PHImageRequestOptions()
        imageRequesOption.isSynchronous = true
        imageRequesOption.resizeMode = .fast
        imageRequesOption.deliveryMode = .fastFormat
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 60, height: 60), contentMode: .aspectFill, options: imageRequesOption) { (result, _) in
            image = result ?? UIImage(named: "empty_picture")!
        }
        return image
    }
}
