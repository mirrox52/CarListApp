//
//  TabBarCoordinator.swift
//  ProgressApp
//
//  Created by Aliaksandr on 5.09.22.
//

import UIKit

final class TabBarCoordinator {
    
    weak private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let navigationController = CustomNavigationController()
        navigationController.isNavigationBarHidden = true
        guard let viewController = makeViewController() else { return }
        navigationController.pushViewController(viewController, animated: true)
        window?.rootViewController = navigationController
    }
}

// MARK: Private
private extension TabBarCoordinator {
    
    func makeViewController() -> UIViewController? {
        let viewController = R.storyboard.tabBar.tabBarController()
        return viewController
    }
}
