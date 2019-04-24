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
    //是否登录属性
    var isLogin : Bool = UserAccountTool.shareInstance.isLogin
    //保存数据
    private lazy var StatusViews : [StatusViewTool] = [StatusViewTool]()
    //提示label
    private lazy var tipLabel : UILabel = UILabel()
    private lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //自动计算cell的高度
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        setUpHeaderView()
        setUpFootView()
        setUpTipLabel()
        setUpNatifications()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        if isLogin {
//            tableView.mj_header.beginRefreshing()
        }
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
    //tiplabel
    private func setUpTipLabel(){
        navigationController?.navigationBar.insertSubview((tipLabel), at: 0)
        tipLabel.frame = CGRect(x: UIScreen.main.bounds.width * 0.375, y: 10, width: UIScreen.main.bounds.width * 0.25, height: 32)
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
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
            
            self.cacheImages(StatusViews: tempStatusViews,isNewDate: isNewDate)
        }
    }
    //缓存图片
    private func cacheImages(StatusViews : [StatusViewTool],isNewDate : Bool){
        let group = DispatchGroup()
        for StatusView in StatusViews{
            for picURL in StatusView.picURLs{
                group.enter()
                SDWebImageManager.shared().loadImage(with: picURL, options: [], progress: nil) { (image, _, _, _, _, _) in
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
            //显示提示label
            if isNewDate{
                self.showTiplabel(count: StatusViews.count)
            }
        }
    }
    //tiplabel
    private func showTiplabel(count : Int){
        tipLabel.isHidden = false
        //执行动画
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.frame.origin.y = 44
            self.tableView.frame.origin.y = 32
            for i in (0...2).reversed() {
                self.tipLabel.frame.origin.x = UIScreen.main.bounds.width * 0.125 * CGFloat(i)
                self.tipLabel.frame.size.width = (UIScreen.main.bounds.width * 0.5 - self.tipLabel.frame.origin.x) * 2
            }
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
                self.tipLabel.text = count == 0 ? "没有最新数据" : "更新了\(count)数据"
                self.tipLabel.frame.origin.y = 10
                self.tableView.frame.origin.y = 0
            }, completion: { (_) in
                self.tipLabel.isHidden = true
                self.tipLabel.text = nil
                self.tipLabel.frame = CGRect(x: UIScreen.main.bounds.width * 0.375, y: 10, width: UIScreen.main.bounds.width * 0.25, height: 32)
            })
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comment : UINavigationController = UIStoryboard(name: "TableViewController", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let vc : TableViewController = comment.children.first as! TableViewController
        let viewModel : StatusViewTool = StatusViews[indexPath.row]
        vc.commentID = (viewModel.status?.mid)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//注册通知
extension HotViewController
{
    private func setUpNatifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser(note:)), name: NSNotification.Name(showPhotoBrowserNote), object: nil)
    }
    @objc private func showPhotoBrowser(note : Notification){
        let indexPath : IndexPath = note.userInfo!["indexPath"] as! IndexPath
        let picURLs : [URL] = note.userInfo!["picURLs"] as! [URL]
        let object = note.object as! PictrueCollectionView
        let photoBrowser : PhotoBrowserController = PhotoBrowserController(indexPath: indexPath, picURLS: picURLs)
        photoBrowser.modalPresentationStyle = .custom
        photoBrowser.transitioningDelegate = photoBrowserAnimator
        photoBrowserAnimator.photoBrowserPresentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.PhotoBrowserDismissDelegate = photoBrowser
        present(photoBrowser, animated: true, completion: nil)
    }
}
