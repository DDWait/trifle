//
//  BaseTableViewController.swift
//  个人界面
//
//  Created by TOMY on 2019/4/19.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

let kScreenWidth : CGFloat = UIScreen.main.bounds.width
let kScreenHeight : CGFloat = UIScreen.main.bounds.height
let headerImgHeight : CGFloat = 200
let topBarHeight : CGFloat = 64
let switchBarHeight : CGFloat = 40

protocol TableViewScrollingProtocol : NSObjectProtocol {
    func tableViewScroll(tableView : UITableView,offsetY : CGFloat)
    func tableViewDidEndDecelerating(tableView : UITableView,offsetY : CGFloat)
    func tableViewDidEndDragging(tableView : UITableView,offsetY : CGFloat)
    func tableViewWillBeginDragging(tableView : UITableView,offsetY : CGFloat)
    func tableViewWillBeginDecelerating(tableView : UITableView,offsetY : CGFloat)
}

class BaseTableViewController: UITableViewController {
    var delegate : TableViewScrollingProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showsHorizontalScrollIndicator = false
        let headerView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: headerImgHeight + switchBarHeight))
        headerView.backgroundColor = UIColor.white
        tableView.tableHeaderView = headerView
        if tableView.contentSize.height < kScreenHeight + headerImgHeight - topBarHeight {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kScreenHeight + headerImgHeight - topBarHeight - self.tableView.contentSize.height, right: 0)
        }

    }
}
extension BaseTableViewController
{
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let offsetY : CGFloat = scrollView.contentOffset.y
        delegate!.tableViewWillBeginDragging(tableView: self.tableView, offsetY: offsetY)
    }
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let offsetY : CGFloat = scrollView.contentOffset.y
        delegate!.tableViewWillBeginDecelerating(tableView: self.tableView, offsetY: offsetY)
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY : CGFloat = scrollView.contentOffset.y
        delegate!.tableViewDidEndDragging(tableView: self.tableView, offsetY: offsetY)
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY : CGFloat = scrollView.contentOffset.y
        delegate!.tableViewDidEndDecelerating(tableView: self.tableView, offsetY: offsetY)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY : CGFloat = scrollView.contentOffset.y
        delegate?.tableViewScroll(tableView: tableView, offsetY: offsetY)
    }
}
