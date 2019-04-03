//
//  FirstViewController.swift
//  scrollViewAndsegmented
//
//  Created by TOMY on 2019/3/23.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HotViewController: UITableViewController {

    //保存数据
    private lazy var StatusViews : [StatusViewTool] = [StatusViewTool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        //自动计算cell的高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        setUpHeaderView()
        setUpFootView()
    }
    
    
}

extension HotViewController
{
    private func setUpHeaderView(){
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewDate))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        tableView.mj_header = header
        
        //进入刷新状态
        tableView.mj_header.beginRefreshing()
        
    }
    
    @objc private func loadNewDate(){
        loadStatus(isNewDate: true)
    }
    
    private func setUpFootView(){
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreStatuses))
    }
    @objc private func loadMoreStatuses(){
        loadStatus(isNewDate: false)
    }
}

//请求数据
extension HotViewController
{
    private func loadStatus(isNewDate : Bool){
        //获取since_id
        var since_id = 0
        var max_id = 0
        if isNewDate {
            since_id = StatusViews.first?.status?.mid ?? 0
        }else{
            max_id = StatusViews.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        NetWorkTool.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
            if error != nil{
                print("error--loadStatus")
                return
            }
            
            guard let resultArray = result else{
                return
            }
            var tempStatusViews : [StatusViewTool] = [StatusViewTool]()
            for statusDict in resultArray{
                let status = Status(dict: statusDict)
                let StatusView = StatusViewTool(status: status)
                tempStatusViews.append(StatusView)
            }
            if isNewDate{
                self.StatusViews = tempStatusViews + self.StatusViews
            }else{
                self.StatusViews += tempStatusViews
            }
            
            self.cacheImages(StatusViews: tempStatusViews)
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
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
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
