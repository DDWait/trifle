//
//  HomePageViewController.swift
//  个人界面
//
//  Created by TOMY on 2019/4/19.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit
import SDWebImage
class HomePageViewController: UIViewController {
    //加载界面
    lazy var visitorView : VisitorView = VisitorView.VisitorView()
    //是否登录属性
    var isLogin : Bool = UserAccountTool.shareInstance.isLogin
    //系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : setUpVisitorView()
    }
    /////////////////////////////////////////////////////
    private lazy var navView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 64))
    private lazy var segCtrl : HMSegmentedControl = HMSegmentedControl()
    private lazy var headerView : CommualHeaderView = Bundle.main.loadNibNamed("CommualHeaderView", owner: nil, options: nil)?.first as! CommualHeaderView
    private  var titleList : [String] = ["主页","微博","相册"]
    private lazy var showingVC : UIViewController = UIViewController()
    private var offsetYDict : [String : CGFloat] = [:]
    private var stausBarColorIsBlack : Bool = false
    private var iconbtn : UIButton?
    override var preferredStatusBarStyle: UIStatusBarStyle{get { return stausBarColorIsBlack ? .default : .lightContent}}
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置访客视图
        visitorView.setUpVisitorViewInfo(iconName: "visitordiscover_image_profile", title: "登录后，您的信息将会展示在这里")
        if isLogin {
            configNav()
            addController()
            addHeaderView()
            segmentedControlChangedValue(sender: segCtrl)
            NotificationCenter.default.addObserver(self, selector: #selector(iconImageClick), name: NSNotification.Name(changeIconImage), object: nil)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLogin {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isLogin {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
        }
    }
}
//访客视图的设置
extension HomePageViewController
{
    private func setUpVisitorView(){
        view = visitorView
        //设置监听
        visitorView.registerLoginBtn.addTarget(self, action: #selector(regisLoginterBtnDidClicked), for: UIControl.Event.touchUpInside)
    }
    //登录按钮
    @objc private func regisLoginterBtnDidClicked(){
        let registerLoginVc : RegisterLoginViewController = RegisterLoginViewController()
        present(registerLoginVc, animated: true, completion: nil)
    }

}
extension HomePageViewController
{
    //换头像
    @objc private func iconImageClick(note : Notification){
        iconbtn = note.object as? UIButton
        let alterVc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alterVc.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
            self.getIconImage()
        }))
        alterVc.addAction(UIAlertAction(title: "相机", style: .default, handler: nil))
        alterVc.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alterVc, animated: true, completion: nil)
    }
    private func getIconImage(){
        let PickerImageVc = UIImagePickerController()
        PickerImageVc.sourceType = .photoLibrary
        PickerImageVc.allowsEditing = true
        PickerImageVc.delegate = self
        present(PickerImageVc, animated: true, completion: nil)
    }
    private func configNav(){
        navigationController?.navigationBar.tintColor = UIColor.white
        navView.backgroundColor = UIColor.white
        let titleLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 32, width: kScreenWidth, height: 20))
        titleLabel.text = "我的详情"
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        navView.addSubview(titleLabel)
        navView.alpha = 0
        view.addSubview(navView)
    }
    private func addController(){
        let vc1 : LeftTableViewController = LeftTableViewController()
        vc1.delegate = self
        let vc2 : MiddleTableViewController = MiddleTableViewController()
        vc2.delegate = self
        let vc3 : RightTableViewController = RightTableViewController()
        vc3.delegate = self
        addChild(vc1)
        addChild(vc2)
        addChild(vc3)
        for vc in self.children{
            var text : String = ""
            text = (text as NSString).appendingFormat("%p", vc) as String
            offsetYDict[text] = 0.0
        }
    }
    private func addHeaderView(){
        headerView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: headerImgHeight+switchBarHeight)
        setMessage()
        segCtrl = headerView.segCtrl
        segCtrl.sectionTitles = titleList
        segCtrl.backgroundColor = ColorUtility.color(withHexString: "e9e9e9")
        segCtrl.selectionIndicatorHeight = CGFloat(2.0)
        segCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segCtrl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
        segCtrl.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        segCtrl.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ColorUtility.color(withHexString: "fea41a")]
        segCtrl.selectionIndicatorColor = ColorUtility.color(withHexString: "fea41a")
        segCtrl.selectedSegmentIndex = 0
        segCtrl.borderType = .bottom
        segCtrl.borderColor = UIColor.lightGray
        segCtrl.addTarget(self, action: #selector(segmentedControlChangedValue(sender:)), for: .valueChanged)
    }
    private func setMessage(){
        let profileURLString = UserAccountTool.shareInstance.account?.avatar_large
        SDWebImageManager.shared().loadImage(with: URL(string: profileURLString!), options: [], progress: nil) { (image, _, _, _, _, _) in
            guard let image = image else{
                return
            }
            self.headerView.iconImageBtn.setBackgroundImage(image, for: UIControl.State.normal)
        }
        let screen_name = UserAccountTool.shareInstance.account?.screen_name
        headerView.label.text = screen_name
    }
    @objc private func segmentedControlChangedValue(sender : HMSegmentedControl){
        showingVC.view.removeFromSuperview()
        let newVC : BaseTableViewController = self.children[sender.selectedSegmentIndex] as! BaseTableViewController
        if (newVC.view!.superview == nil) {
            view.addSubview(newVC.view)
            newVC.view.frame = view.bounds
        }
        var text : String = ""
        text = (text as NSString).appendingFormat("%p", newVC) as String
        let offsetY : CGFloat = offsetYDict[text]!
        newVC.tableView.contentOffset = CGPoint(x: 0, y: offsetY)
        view.insertSubview(newVC.view, belowSubview: navView)
        if offsetY <= headerImgHeight - topBarHeight {
            newVC.view.addSubview(headerView)
            for sView in newVC.view.subviews{
                if sView.isKind(of: UIImageView.self){
                    newVC.view.insertSubview(headerView, belowSubview: sView)
                    break
                }
            }
            var rect : CGRect = headerView.frame
            rect.origin.y = 0
            headerView.frame = rect
        }else{
            view.insertSubview(headerView, belowSubview: navView)
            var rect : CGRect = headerView.frame
            rect.origin.y = topBarHeight - headerImgHeight
            headerView.frame = rect
        }
        showingVC = newVC
    }
}
extension HomePageViewController : TableViewScrollingProtocol
{
    func tableViewScroll(tableView: UITableView, offsetY: CGFloat) {
        if offsetY > headerImgHeight - topBarHeight{
            if headerView.superview != self.view{
                view.insertSubview(headerView, belowSubview: navView)
            }
            headerView.frame.origin.y = topBarHeight - headerImgHeight
        }else{
            if headerView.superview != tableView {
                for tView in tableView.subviews{
                    if tView.isKind(of: UIImageView.self){
                        tableView.insertSubview(headerView, belowSubview: tView)
                        break
                    }
                }
            }
            headerView.frame.origin.y = 0
        }
        if offsetY > 0 {
            let alpha : CGFloat = offsetY / 136.0
            navView.alpha = alpha
            if alpha > 0.6 && !stausBarColorIsBlack{
                navigationController?.navigationBar.tintColor = UIColor.black
                stausBarColorIsBlack = true
                setNeedsStatusBarAppearanceUpdate()
            }else if alpha <= 0.6 && stausBarColorIsBlack{
                navigationController?.navigationBar.tintColor = UIColor.white
                stausBarColorIsBlack = false
                setNeedsStatusBarAppearanceUpdate()
            }
        }else{
            navView.alpha = 0
            navigationController?.navigationBar.tintColor = UIColor.white
            stausBarColorIsBlack = false
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func tableViewDidEndDecelerating(tableView: UITableView, offsetY: CGFloat) {
        headerView.isUserInteractionEnabled = true
        var text : String = ""
        text = (text as NSString).appendingFormat("%p", showingVC) as String
        if offsetY > headerImgHeight - topBarHeight{
            for key in offsetYDict.keys{
                if key == text{
                    offsetYDict[key] = offsetY
                }else if offsetYDict[key]! <= headerImgHeight - topBarHeight{
                    offsetYDict[key] = headerImgHeight - topBarHeight
                }
            }
        }else{
            if offsetY <= headerImgHeight - topBarHeight{
                for key in offsetYDict.keys{
                    offsetYDict[key] = offsetY
                }
            }
        }
    }
    
    func tableViewDidEndDragging(tableView: UITableView, offsetY: CGFloat) {
        headerView.isUserInteractionEnabled = true
        var text : String = ""
        text = (text as NSString).appendingFormat("%p", showingVC) as String
        if offsetY > headerImgHeight - topBarHeight{
            for key in offsetYDict.keys{
                if key == text{
                    offsetYDict[key] = offsetY
                }else if offsetYDict[key]! <= headerImgHeight - topBarHeight{
                    offsetYDict[key] = headerImgHeight - topBarHeight
                }
            }
        }else{
            if offsetY <= headerImgHeight - topBarHeight{
                for key in offsetYDict.keys{
                    offsetYDict[key] = offsetY
                }
            }
        }
    }
    
    func tableViewWillBeginDragging(tableView: UITableView, offsetY: CGFloat) {
        headerView.isUserInteractionEnabled = false
    }
    
    func tableViewWillBeginDecelerating(tableView: UITableView, offsetY: CGFloat) {
        headerView.isUserInteractionEnabled = false
    }
}

extension HomePageViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let iamge : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        iconbtn?.setBackgroundImage(iamge, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
}
