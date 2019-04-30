//
//  NewCommentControllViewController.swift
//  trifle
//
//  Created by TOMY on 2019/4/25.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import MJRefresh
private let CommentCell = "CommentCell"
class NewCommentControllViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private lazy var CommentViews : [Comment] = [Comment]()
    var isLogin : Bool = UserAccountTool.shareInstance.isLogin
    // MARK:-懒加载
    private lazy var emotiVc = EmoticonController { [weak self](emoticon) in
        self?.textView.insertEmoticon(emoticon: emoticon)
    }
    @IBAction func emoticon() {
        textView.resignFirstResponder()
        
        textView.inputView = textView.inputView != nil ? nil : emotiVc.view
        
        textView.becomeFirstResponder()
    }
    @IBAction func keyBtnclick(_ sender: UIButton) {
        let text = textView.getEmoticonString()
        NetWorkTool.shareInstance.sendComment(commentText: text, id: (viewModel?.status?.mid)!) { (flag) in
            if flag{
                print("sendComment成功")
            }else{
                print("sendComment失败")
            }
            self.textView.resignFirstResponder()
            self.BViewBottomCon.constant = -44
            self.tableView.mj_header.beginRefreshing()
        }
    }
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var BViewBottomCon: NSLayoutConstraint!
    var viewModel : StatusViewTool?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initNotifagation()
    }
}

extension NewCommentControllViewController
{
    private func setUI(){
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        BViewBottomCon.constant = -44
        tableView.register(UINib(nibName: "NewCommentCell", bundle: nil), forCellReuseIdentifier: CommentCell)
        setUpHeaderView()
        setUpFootView()
    }
}

extension NewCommentControllViewController : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return CommentViews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HotCell") as! HotViewCell
            cell.viewModel = viewModel
            cell.bottomBar.isHidden = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell, for: indexPath) as! NewCommentCell
            cell.viewModel = CommentViews[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            if CommentViews.count == 0{
                let headerView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
                let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
                headerLabel.text = "暂无评论"
                headerLabel.textColor = UIColor.black
                headerLabel.font = UIFont.systemFont(ofSize: 17)
                headerLabel.textAlignment = .center
                let headerBtn : UIButton = UIButton(type: .custom)
                headerBtn.setTitleColor(UIColor.black, for: .normal)
                headerBtn.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 30)
                headerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                headerBtn.setTitle("点击添加评论", for: .normal)
                headerBtn.addTarget(self, action: #selector(headerBtnClick), for: .touchUpInside)
                headerView.addSubview(headerBtn)
                headerView.addSubview(headerLabel)
                return headerView
            }else{
                let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width, height: 30))
                headerLabel.text = "全部评论"
                headerLabel.textColor = UIColor.lightGray
                headerLabel.font = UIFont.systemFont(ofSize: 17)
                headerLabel.textAlignment = .left
                return headerLabel
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        }
        return 30
    }
    @objc private func headerBtnClick(){
        textView.becomeFirstResponder()
    }
    private func setUpHeaderView(){
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewDate))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }
    private func setUpFootView(){
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreStatuses))
    }
    @objc private func loadNewDate(){
        loadStatus(isNewDate: true)
    }
    @objc private func loadMoreStatuses(){
        loadStatus(isNewDate: false)
    }
    private func loadStatus(isNewDate : Bool){
        //获取since_id
        var since_id = 0
        var max_id = 0
        if isNewDate {
            since_id = CommentViews.first?.mid ?? 0
        }else{
            max_id = CommentViews.last?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        NetWorkTool.shareInstance.loadCommentLists(since_id: since_id, max_id: max_id, commentID: (viewModel?.status?.mid)!) { (result, error) in
            if error != nil{
                print("loadNumber")
                return
            }
            guard let resultArray = result else{
                return
            }
            var tempComments : [Comment] = []
            for commentDict in resultArray{
                let comment = Comment(dict: commentDict)
                tempComments.append(comment)
            }
            if isNewDate{
                self.CommentViews = tempComments + self.CommentViews
            }else{
                self.CommentViews += tempComments
            }
            
            let group = DispatchGroup()
            group.notify(queue: DispatchQueue.main, execute: {
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            })
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if BViewBottomCon.constant != -44 {
            textView.resignFirstResponder()
            BViewBottomCon.constant = -44
        }
    }
}
extension NewCommentControllViewController
{
    private func initNotifagation(){
        //监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //回复按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(reply), name: NSNotification.Name(replyComment), object: nil)
    }
    //键盘
    @objc private func keyboardWillChangeFrame(note : Notification){
        //时间
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        //位置
        let endFrmae = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let margin = UIScreen.main.bounds.height - endFrmae.origin.y
        BViewBottomCon.constant = margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func reply(){
       textView.becomeFirstResponder()
    }
}
