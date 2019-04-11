//
//  PopoverAnimator.swift
//  trifle
//
//  Created by TOMY on 2019/3/26.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    //控制弹出或者消失动画的属性
    private var isPresented : Bool = false
    //提供对外的设置frame的属性
    var presentedViewFrame : CGRect = CGRect.zero
    
    
    var callBack : ((_ present : Bool)->())?
    
    
    init(callBack : @escaping (_ present : Bool)->()) {
        self.callBack = callBack
    }
    
    override init() {
        super.init()
    }
    
}
extension PopoverAnimator : UIViewControllerTransitioningDelegate
{
    ///改变view的尺寸和添加朦板
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?{
        let presenttationVC : TFEPresenttationController = TFEPresenttationController(presentedViewController: presented, presenting: presenting)
        presenttationVC.presentedViewFrame = presentedViewFrame
        return presenttationVC
    }
    
    ///自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        //UIViewControllerAnimatedTransitioning是一个协议，需要返回一个d遵循这个协议的对象
        isPresented = true
        if callBack != nil {
            self.callBack!(isPresented)
        }
        return self
    }
    ///自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        if callBack != nil {
            self.callBack!(isPresented)
        }
        return self
    }
}

///弹出和消失动画
extension PopoverAnimator : UIViewControllerAnimatedTransitioning
{
    ///动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    ///转场上下文(包含弹出的View - to和消失的View - from)
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationforPresented(transitionContext: transitionContext) : animationforDismissed(transitionContext: transitionContext)
    }
    
    ///弹出动画
    private func animationforPresented(transitionContext: UIViewControllerContextTransitioning){
        //获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //将弹出view加入到containView(这里需要手动)
        transitionContext.containerView.addSubview(presentedView)
        //执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration:transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform.identity
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    ///消失动画
    private func animationforDismissed(transitionContext: UIViewControllerContextTransitioning){
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView.transform = CGAffineTransform(scaleX: 1.0, y: 0.000001)
        }) { (_) in
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
