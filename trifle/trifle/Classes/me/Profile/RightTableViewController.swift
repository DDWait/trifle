//
//  RightTableViewController.swift
//  个人界面
//
//  Created by TOMY on 2019/4/19.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
private let rightPageCell = "rightPageCell"
class RightTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: rightPageCell)
    }
}

extension RightTableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rightPageCell, for: indexPath)
        cell.textLabel?.text = "主页\(indexPath.row)"
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func resetContentInset(){
        tableView.layoutIfNeeded()
        if tableView.contentSize.height < kScreenHeight + 136 {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kScreenHeight+88-self.tableView.contentSize.height, right: 0)
        }else{
            tableView.contentInset = UIEdgeInsets.zero
        }
    }
    ///请求数据
    func request_data(){
    }
}
