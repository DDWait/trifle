//
//  FirstViewController.swift
//  scrollViewAndsegmented
//
//  Created by TOMY on 2019/3/23.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage

class HotViewController: UITableViewController {

    //保存数据
    private lazy var StatusViews : [StatusViewTool] = [StatusViewTool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        loadStatus()
        
        //自动计算cell的高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    
}

//请求数据
extension HotViewController
{
    private func loadStatus(){
        NetWorkTool.shareInstance.loadStatuses2 { (result, error) in
            if error != nil{
                print("error--loadStatus")
                return
            }
            
            guard let resultArray = result else{
                return
            }
            
            for statusDict in resultArray{
                let status = Status(dict: statusDict)
                let StatusView = StatusViewTool(status: status)
                self.StatusViews.append(StatusView)
            }
            self.cacheImages(StatusViews: self.StatusViews)
        }
    }
    
    //缓存图片
    private func cacheImages(StatusViews : [StatusViewTool]){
        let group = DispatchGroup()
        for StatusView in StatusViews{
            //单张配图下载
            if StatusView.picURLs.count == 1{
                let picURL = StatusView.picURLs.first
                group.enter()
                SDWebImageManager.shared().loadImage(with: picURL, options: [], progress: nil) { (_, _, _, _, _, _) in
                    print("下载了一张图片")
                    group.leave()
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            print("刷新")
        }
        
    }
}

//tableView的数据源方法
extension HotViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StatusViews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotCell") as! HotViewCell
        cell.viewModel = StatusViews[indexPath.row]
        return cell
    }
}
