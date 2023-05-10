//
//  CarListViewController.swift
//  ProgressApp
//
//  Created by Aliaksandr on 5.09.22.
//

import UIKit

protocol CarListEventHandler {
    
    func updateData()
}

final class CarListViewController: UIViewController {

    @IBOutlet private weak var topBarView: TopBarView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIButton!
    
    @IBAction private func addCarTapped(_ sender: Any) {
        guard let carListNavigationDelegate else { return }
        carListNavigationDelegate.navigateToAddCar(carListEventHandler: self)
    }
    
    private var carListNavigationDelegate: CarListNavigationDelegate?
    private var cars: [Car]?
    
    private(set) var selectedCarCell: CarItemCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func configure(with cars: [Car], carListNavigationDelegate: CarListNavigationDelegate) {
        self.cars = cars
        self.carListNavigationDelegate = carListNavigationDelegate
    }
}

// MARK: Setup
private extension CarListViewController {
    
    func setup() {
        setupTableView()
        DataBaseManager.shared.carListEventHandler = self
        view.backgroundColor = .systemGray2
        topBarView.configure(title: R.string.localizable.carListBadgeValue())
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(R.nib.carItemCell)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension CarListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cars else { return 0 }
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cars,
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.carItemCell, for: indexPath)
        else { return UITableViewCell() }
        cell.configure(with: cars[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let indexPath = tableView.indexPathForSelectedRow,
            let currentCell = tableView.cellForRow(at: indexPath) as? CarItemCell
        else { return }
        selectedCarCell = currentCell
        
        guard
            let carListNavigationDelegate,
            let cars
        else { return }
        carListNavigationDelegate.navigateToCarDetails(car: cars[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataBaseManager.shared.deleteCar(id: cars?[indexPath.row].id ?? 0)
            cars?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: CarListEventHandler
extension CarListViewController: CarListEventHandler {
    
    func updateData() {
        cars = DataBaseManager.shared.fetchCars()
        tableView.reloadData()
    }
}
