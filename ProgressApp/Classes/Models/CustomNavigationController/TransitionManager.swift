//
//  TransitionManager.swift
//  ProgressApp
//
//  Created by Aliaksandr on 10.05.23.
//

import UIKit

final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    private let operation: UINavigationController.Operation
    
    init(duration: TimeInterval, operation: UINavigationController.Operation) {
        self.duration = duration
        self.operation = operation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        animateTransition(from: fromViewController, to: toViewController, with: transitionContext)
    }
}

// MARK: Animations
private extension TransitionManager {
    
    func animateTransition(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        with context: UIViewControllerContextTransitioning
    ) {
        switch operation {
        case .push:
            guard
                let tabBarController = fromViewController as? TabBarController,
                let carListViewController = tabBarController.viewControllers?.first as? CarListViewController,
                let carDetailsViewController = toViewController as? CarDetailsViewController
            else { return }
            presentViewController(carDetailsViewController, from: carListViewController, with: context)
        case .pop:
            guard
                let tabBarController = fromViewController as? TabBarController,
                let carListViewController = tabBarController.viewControllers?.first as? CarListViewController,
                let carDetailsViewController = toViewController as? CarDetailsViewController
            else { return }
            dismissViewController(carDetailsViewController, to: carListViewController, with: context)
        default:
            break
        }
    }
    
    func presentViewController(
        _ toViewController: CarDetailsViewController,
        from fromViewController: CarListViewController,
        with context: UIViewControllerContextTransitioning
    ) {
        toViewController.view.layoutIfNeeded()
        
        guard
            let selectedCarCell = fromViewController.selectedCarCell,
            let carImageView = fromViewController.selectedCarCell?.carImageView,
            let carPhotosCollectionViewCell = toViewController.carPhotosCollectionViewCell
        else { return }
        
        let containerView = context.containerView
        
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = .white
        snapshotContentView.frame = containerView.convert(selectedCarCell.contentView.frame, from: selectedCarCell)
        snapshotContentView.layer.cornerRadius = selectedCarCell.contentView.layer.cornerRadius
        
        let snapshotCarImageView = UIImageView()
        snapshotCarImageView.clipsToBounds = true
        snapshotCarImageView.contentMode = carImageView.contentMode
        snapshotCarImageView.image = carImageView.image
        snapshotCarImageView.layer.cornerRadius = carImageView.layer.cornerRadius
        snapshotCarImageView.frame = containerView.convert(carImageView.frame, from: carImageView)
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(snapshotCarImageView)
        
        toViewController.view.isHidden = true
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            snapshotContentView.frame = containerView.convert(toViewController.view.frame, from: toViewController.view)
            snapshotCarImageView.frame = containerView.convert(carPhotosCollectionViewCell.contentView.frame, from: carPhotosCollectionViewCell)
            snapshotCarImageView.layer.cornerRadius = 0
        }
        
        animator.addCompletion { position in
            toViewController.view.isHidden = false
            snapshotCarImageView.removeFromSuperview()
            snapshotContentView.removeFromSuperview()
            context.completeTransition(position == .end)
        }
        
        animator.startAnimation()
    }
    
    func dismissViewController(
        _ fromViewController: CarDetailsViewController,
        to toViewController: CarListViewController,
        with context: UIViewControllerContextTransitioning
    ) { }
}
