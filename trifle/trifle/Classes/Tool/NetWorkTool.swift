//
//  NetWorkTool.swift
//  AFN
//
//  Created by TOMY on 2019/1/29.
//  Copyright © 2019年 tone. All rights reserved.
//

import AFNetworking

enum RequsetType : Int {
    case Get
    case POST
}

class NetWorkTool: AFHTTPSessionManager {
    //let是线程安全的
    static let shareInstance : NetWorkTool = {
        let tools = NetWorkTool()
        
        //插入"text/html"
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        return tools
    }()
}

// MARK:-封装请求方法
extension NetWorkTool
{
    func request(methodType : RequsetType, urlString : String, parameters : [String : AnyObject] , finished : @escaping (_ result : AnyObject? , _ error : Error?) ->()) {
        //1.定义成功的闭包
        let successCallBack = { (task : URLSessionDataTask, result :Any?) in
            finished(result as AnyObject,nil)
        }
        //2.定义失败的闭包
        let failureCallBack = { (task : URLSessionDataTask?, error :Error) in
            finished(nil,error)
        }
        if methodType == .Get {
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }else{
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

// MARK:-获取用户的信息
extension NetWorkTool
{
    func loadUserInfo(access_token : String, uid : String, finished : @escaping (_ relust : [String : AnyObject]?,_ error : Error?)->()){
        //1.获取请求的URLstring
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        //2.获取请求的参数
        let paramenters = ["access_token" : access_token,"uid":uid]
        
        //3.发送请求
        request(methodType: .Get, urlString: urlString, parameters: paramenters as [String : AnyObject]) { (relust, error) in
            finished(relust as? [String : AnyObject],error)
        }
    }
}

//MARK:-请求主页数据
extension NetWorkTool
{
    func loadStatuses(since_id : Int ,max_id : Int,finished : @escaping (_ result : [[String : AnyObject]]?,_ error : Error?)->()) {
        //1.请求数据的URL
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"

        //2.请求参数
        let access_token = UserAccountTool.shareInstance.account?.access_token
        
        let parameters = ["access_token":access_token,"since_id":"\(since_id)","max_id":"\(max_id)"]

        //发送请求
        request(methodType: .Get, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            //1.获取字典数据
            guard let resultDict = result as? [String : AnyObject] else{
                finished(nil,error)
                return
            }
            //2.将数组回调给外部
            finished(resultDict["statuses"] as? [[String : AnyObject]],nil)
        }
    }
}

//// MARK:-发送微博无图片
//extension NetWorkTool
//{
//    func sendStatus(statusText : String, isSuccess : @escaping (_ isSuccess : Bool)->()) {
//        //获取请求的URLstring
//        let urlString = "https://api.weibo.com/2/statuses/share.json"
//        //拼接安全域名
//        let statusNew = statusText + "sns.whalecloud.com"
//        //拼接请求参数
//        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.account?.access_token)!, "status" : statusNew]
//        //发送请求
//        request(methodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
//            if result != nil{
//                isSuccess(true)
//            }else{
//                isSuccess(false)
//            }
//        }
//    }
//}

//// MARK:-发送微博陪图片
//extension NetWorkTool
//{
//    func sendStatus(statusText : String, image : UIImage,isSuccess : @escaping (_ isSuccess : Bool)->()) {
//        //获取请求的URLstring
//        let urlString = "https://api.weibo.com/2/statuses/share.json"
//        //拼接安全域名
//        let statusNew = statusText + "http://www.mob.com"
//        //拼接请求参数
//        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.account?.access_token)!, "status" : statusNew]
//        requestSerializer.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
//        //使用能上传图片的POST请求
//        post(urlString, parameters: parameters, constructingBodyWith: { (formDate) in
//            if let imageData = image.pngData() {
//                formDate.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "multipart/form-data")
//            }
//        }, progress: nil, success: { (_, _) in
//            isSuccess(true)
//        }) { (_, error) in
//            print(error)
//            isSuccess(false)
//        }
//    }
//
//}

