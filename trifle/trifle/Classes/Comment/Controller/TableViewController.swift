//
//  TableViewController.swift
//  评论
//
//  Created by TOMY on 2019/4/23.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
private let CommentCell = "CommentCell"
class TableViewController: UITableViewController {

    private lazy var CommentViews : [Comment] = [Comment]()
    var commentID : Int = 0{
        didSet{
            NetWorkTool.shareInstance.loadCommentLists(commentID: commentID) { (result, error) in
                if error != nil{
                    print("error--loadCommentLists")
                    return
                }
                guard let resultArray = result else{
                    return
                }
                for commentDict in resultArray{
                    let comment = Comment(dict: commentDict)
                    self.CommentViews.append(comment)
                }
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentViews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell, for: indexPath) as! CommentTableCell
        cell.viewModel = CommentViews[indexPath.row]
        return cell
    }
}
