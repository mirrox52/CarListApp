//
//  CustomNavigationController.swift
//  ProgressApp
//
//  Created by Aliaksandr on 10.05.23.
//

import UIKit

final class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard
            let tabBarController = fromVC as? TabBarController,
            let _ = tabBarController.viewControllers?.first as? CarListViewController,
            let _ = toVC as? CarDetailsViewController
        else { return nil }
        switch operation {
        case .push:
            return TransitionManager(duration: 0.5, operation: .push)
        default:
            return nil
        }
    }
}
