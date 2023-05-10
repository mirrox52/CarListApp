//
//  AddCarCoordinator.swift
//  ProgressApp
//
//  Created by Aliaksandr on 22.09.22.
//

import UIKit

protocol AddCarNavigationDelegate {
    
    func back()
}

final class AddCarCoordinator {
    
    weak private var navigationController: UINavigationController?
    private var carListEventHandler: CarListEventHandler
    
    init(
        navigationController: UINavigationController?,
        carListEventHandler: CarListEventHandler
    ) {
        self.navigationController = navigationController
        self.carListEventHandler = carListEventHandler
    }
    
    func start() {
        guard let viewController = makeViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func makeViewController() -> UIViewController? {
        let controller = R.storyboard.addCar.addCarViewController()
        controller?.configure(addCarEventHandler: self, carListEventHandler: carListEventHandler)
        return controller
    }
}

// MARK: AddCarEventHandler
extension AddCarCoordinator: AddCarNavigationDelegate {
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
