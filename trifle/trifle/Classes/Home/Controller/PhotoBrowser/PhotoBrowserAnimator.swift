//
//  PhotoBrowserAnimator.swift
//  trifle
//
//  Created by TOMY on 2019/4/16.
//  Copyright © 2019年 tone. All rights reserved.
//

import UIKit

protocol AnimatorPhotoBrowserPresentedDelegate : NSObjectProtocol {
    func startRect(indexPath : IndexPath) -> CGRect
    func endRect(indexPath : IndexPath) -> CGRect
    func imageView(indexPath : IndexPath) -> UIImageView
}
protocol AnimatorPhotoBrowserDismissDelegate : NSObjectProtocol{
    func GetIndexPath() -> IndexPath
    func GetImageView() -> UIImageView
}
class PhotoBrowserAnimator: NSObject {
    var isPresented : Bool = false
    var photoBrowserPresentedDelegate : AnimatorPhotoBrowserPresentedDelegate?
    var PhotoBrowserDismissDelegate : AnimatorPhotoBrowserDismissDelegate?
    var indexPath : IndexPath?
    
}
extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissView(transitionContext: transitionContext)
    }
    //弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        guard let photoBrowserPresentedDelegate = photoBrowserPresentedDelegate,let indexPath = indexPath else {
            return
        }
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        transitionContext.containerView.addSubview(presentedView)
        
        let startRect = photoBrowserPresentedDelegate.startRect(indexPath: indexPath)
        let imageView = photoBrowserPresentedDelegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = photoBrowserPresentedDelegate.endRect(indexPath: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            transitionContext.containerView.backgroundColor = UIColor.clear
            presentedView.alpha = 1.0
            transitionContext.completeTransition(true)
        }
    }
    //消失动画
    private func animationForDismissView(transitionContext: UIViewControllerContextTransitioning){
        guard let photoBrowserPresentedDelegate = photoBrowserPresentedDelegate,let PhotoBrowserDismissDelegate = PhotoBrowserDismissDelegate else {
            return
        }
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        dismissView.removeFromSuperview()
        
        let imageView = PhotoBrowserDismissDelegate.GetImageView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = PhotoBrowserDismissDelegate.GetIndexPath()
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = photoBrowserPresentedDelegate.startRect(indexPath: indexPath)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
