//
//  EmoticonController.swift
//  表情键盘
//
//  Created by TOMY on 2019/4/13.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

private let collectioncell = "collectioncell"

class EmoticonController: UIViewController {
    // MARK:-定义的属性
    var emotiConCallBack : (_ emoticon : Emoticon)->()
    // MARK:-懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmotiControllerViewFlowLayout())
    private lazy var toolBar : UIToolbar = UIToolbar()
    private lazy var manager : EmoticonManager = EmoticonManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    init(emotiConCallBack : @escaping (_ emoticon : Emoticon)->()) {
        self.emotiConCallBack = emotiConCallBack
        //重写控制器的init方法必须写下面这一句
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//设置界面
extension EmoticonController
{
    private func setUI(){
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.white
        toolBar.backgroundColor = UIColor.darkGray
        //设置frame
        //如果通过代码设置约束，这个属性一定要设置
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["collectionView" : collectionView,"toolBar":toolBar]
        //利用VFL设置约束
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        //设置collectionView 的约束
        prepareForcollectionView()
        //设置toolBar
        prepareFortoolBar()
    }
    
    private func prepareForcollectionView() {
        //注册
        collectionView.register(EmotiViewCell.self, forCellWithReuseIdentifier: collectioncell)
        //设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func prepareFortoolBar() {
        let titles = ["最近","默认"]
        //遍历数组创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles{
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(itemClick(item:)))
            item.tag = index
            index += 1
            tempItems.append(item)
        }
        //设置toolBar 的items数组
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
}
// MARK:-toolBar的监听
extension EmoticonController
{
    @objc private func itemClick(item : UIBarButtonItem){
        let tag = item.tag
        let indexPath = IndexPath(item: 0, section: tag)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}
extension EmoticonController : UICollectionViewDataSource,UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let packers = manager.packages[section]
        return packers.emotis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectioncell, for: indexPath) as! EmotiViewCell
        let packer = manager.packages[indexPath.section]
        let emoticon = packer.emotis[indexPath.row]
        cell.emoticon = emoticon
        return cell
    }
    
    
    //获得点击的表情
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let packer = manager.packages[indexPath.section]
        let emoticon = packer.emotis[indexPath.item]
        insertRecentlyEmoticon(emoticon: emoticon)
        emotiConCallBack(emoticon)
    }
    private func insertRecentlyEmoticon(emoticon : Emoticon){
        //如果是空白或删除表情则不管
        if emoticon.isRemove || emoticon.isEmpty{
            return
        }
        
        //删除一个表情
        if (manager.packages.first?.emotis.contains(emoticon))! {   //已经存在
            let index = (manager.packages.first?.emotis.firstIndex(of: emoticon))!
            manager.packages.first?.emotis.remove(at: index)
        }else{  //不存在
            manager.packages.first?.emotis.remove(at: 19)
        }
        manager.packages.first?.emotis.insert(emoticon, at: 0)
    }
}
// MARK:-布局UICollectionViewFlowLayout
class EmotiControllerViewFlowLayout : UICollectionViewFlowLayout
{
    //重写该方法进行布局
    override  func prepare(){
        super.prepare()
        //1.计算itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        //2.设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        //3.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        //将中间的间距设置到上下两边
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
        //设置初始的位置
        collectionView?.contentOffset.x = 414
    }
    //设置初始位置
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}
