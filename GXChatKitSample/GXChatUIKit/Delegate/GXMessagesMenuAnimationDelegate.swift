//
//  GXMessagesMenuAnimationDelegate.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/5/2.
//

import UIKit

public class GXMessagesMenuAnimationDelegate: NSObject, UIGestureRecognizerDelegate {
    public weak var bubbleView: UIView?
    /// 目标视图控制器
    weak var presentingViewController: UIViewController?
    /// 是否打开手势返回
    var interacting: Bool = false
    /// 是否为present / dismiss
    var isPresentAnimationing: Bool = false
    /// 交互对象
    var interactivePopTransition: UIPercentDrivenInteractiveTransition?
    
    /// 配置转场效果
    /// - Parameters:
    ///   - presentingVC: 目标视图控制器
    ///   - bubbleView: 聊天气泡
    ///   - interacted: 是否打开手势返回
    public func configureTransition(_ presentingVC: UIViewController?, interacted: Bool) {
        self.presentingViewController = presentingVC
        guard presentingVC != nil && interacted else { return }
        
        let panEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePanGestureHandler(_:)))
        panEdgeGesture.edges = .left
        presentingVC?.view.addGestureRecognizer(panEdgeGesture)
        if let navc = presentingVC as? UINavigationController {
            panEdgeGesture.delegate = self
            navc.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    @objc func screenEdgePanGestureHandler(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let fromVC = self.presentingViewController
        let velocity = abs(gesture.velocity(in: UIApplication.shared.windows.first).x)
        let changeX = abs(gesture.translation(in: UIApplication.shared.windows.first).x)
        var progress = changeX / fromVC!.view.frame.width
        progress = min(1.0, max(0.0, progress))

        switch gesture.state {
        case .began:
            self.interacting = true
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.interactivePopTransition?.completionCurve = .easeInOut
            fromVC?.dismiss(animated: true, completion: nil)
        case .changed:
            self.interactivePopTransition?.update(progress)
        case .ended, .cancelled:
            self.interacting = false
            if velocity > 800.0 {
                self.interactivePopTransition?.finish()
            }
            else if progress > 0.4 {
                self.interactivePopTransition?.completionSpeed = progress
                self.interactivePopTransition?.finish()
            }
            else {
                self.interactivePopTransition?.completionSpeed = progress
                self.interactivePopTransition?.cancel()
            }
        default: break
        }
    }

    // MARK: - UIGestureRecognizerDelegate
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let navc = self.presentingViewController as? UINavigationController {
            if (gestureRecognizer == navc.interactivePopGestureRecognizer) {
                if navc.children.count > 1 {
                    return true
                }
            }
            else {
                if navc.children.count == 1 {
                    return true
                }
            }
        }
        return false
    }
}

extension GXMessagesMenuAnimationDelegate: UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.isPresentAnimationing ? self.presentViewAnimation(transitionContext):self.dismissViewAnimation(transitionContext)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresentAnimationing = true
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresentAnimationing = false
        return self
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (self.interacting ? self.interactivePopTransition : nil)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (self.interacting ? self.interactivePopTransition : nil)
    }
}

extension GXMessagesMenuAnimationDelegate {
    func presentViewAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) as? GXMessagesCellPreviewController else { return }
        toVC.view.alpha = 0.0
        toVC.preview.isHidden = true
        self.bubbleView?.isHidden = true
        transitionContext.containerView.addSubview(toVC.view)
        
        guard let preview = toVC.preview.snapshotView(afterScreenUpdates: false) else { return }
        preview.frame = toVC.originalRect
        preview.transform = toVC.preview.transform
        transitionContext.containerView.addSubview(preview)
        var transform: CGAffineTransform = .identity
        transform = transform.translatedBy(x: 0, y: (toVC.currentRect.minY - toVC.originalRect.minY))
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            preview.transform = transform
            toVC.view.alpha = 1.0
        } completion: { (finished) in
            preview.removeFromSuperview()
            toVC.preview.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func dismissViewAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? GXMessagesCellPreviewController else { return }
        fromVC.preview.isHidden = true
        transitionContext.containerView.addSubview(fromVC.view)

        guard let preview = fromVC.preview.snapshotView(afterScreenUpdates: false) else { return }
        preview.frame = fromVC.currentRect
        transitionContext.containerView.addSubview(preview)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            preview.frame = fromVC.originalRect
            fromVC.view.alpha = 0.0
        } completion: { (finished) in
            preview.removeFromSuperview()
            fromVC.view.removeFromSuperview()
            self.bubbleView?.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
