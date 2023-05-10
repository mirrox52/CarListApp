//
//  TabBarController.swift
//  ProgressApp
//
//  Created by Aliaksandr on 5.09.22.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        let cars = DataBaseManager.shared.fetchCars()
        let carListCoordinator = CarListCoordinator(navigationController: navigationController)
        let carListViewController = viewControllers?.first(where: { $0 is CarListViewController }) as? CarListViewController
        carListViewController?.configure(with: cars, carListNavigationDelegate: carListCoordinator)
    }
}
