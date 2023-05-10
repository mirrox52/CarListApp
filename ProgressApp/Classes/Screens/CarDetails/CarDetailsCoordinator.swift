//
//  CarDetailsCoordinator.swift
//  ProgressApp
//
//  Created by Aliaksandr on 14.09.22.
//

import UIKit

protocol CarDetailsNavigationDelegate {
    
    func back()
}

final class CarDetailsCoordinator {
    
    weak private var navigationController: UINavigationController?
    private let car: Car
    
    init(
        navigationController: UINavigationController?,
        car: Car
    ) {
        self.navigationController = navigationController
        self.car = car
    }
    
    func start() {
        guard let viewController = makeViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Private
private extension CarDetailsCoordinator {
    
    func makeViewController() -> UIViewController? {
        let controller = R.storyboard.carDetails.carDetailsViewController()
        controller?.configure(car: car, eventHandler: self)
        return controller
    }
}

// MARK: CarDetailsNavigationDelegate
extension CarDetailsCoordinator: CarDetailsNavigationDelegate {
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
