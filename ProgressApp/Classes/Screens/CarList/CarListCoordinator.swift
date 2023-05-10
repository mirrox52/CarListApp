//
//  CarListCoordinator.swift
//  ProgressApp
//
//  Created by Aliaksandr on 9.09.22.
//

import UIKit

protocol CarListNavigationDelegate {
    
    func navigateToCarDetails(car: Car)
    func navigateToAddCar(carListEventHandler: CarListEventHandler)
}

final class CarListCoordinator {
    
    weak private var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

// MARK: CarListNavigationDelegate
extension CarListCoordinator: CarListNavigationDelegate {
    
    func navigateToCarDetails(car: Car) {
        CarDetailsCoordinator(
            navigationController: navigationController,
            car: car
        ).start()
    }
    
    func navigateToAddCar(carListEventHandler: CarListEventHandler) {
        AddCarCoordinator(
            navigationController: navigationController,
            carListEventHandler: carListEventHandler
        ).start()
    }
}
