//
//  DataBaseManager.swift
//  ProgressApp
//
//  Created by Aliaksandr on 9.09.22.
//

import Foundation.NSUserDefaults

final class DataBaseManager {
    
    private init() { }
    static let shared = DataBaseManager()
    
    var selectedDataBase = DataBase.coreData
    var carListEventHandler: CarListEventHandler?
}

// MARK: Setup
extension DataBaseManager {
    
    func setupDataBase() {
        var selectedDatabase = DataBase.coreData
        if let rawValue = UserDefaults.standard.string(forKey: Constants.dataBaseType) {
            selectedDatabase = DataBase(rawValue: rawValue) ?? .coreData
        } else {
            UserDefaults.standard.set(selectedDatabase.rawValue, forKey: Constants.dataBaseType)
        }
        self.selectedDataBase = selectedDatabase
    }
    
    func setSelectedDataBase(selectedDataBase: DataBase) {
        self.selectedDataBase = selectedDataBase
        UserDefaults.standard.set(selectedDataBase.rawValue, forKey: Constants.dataBaseType)
        guard let carListEventHandler else { return }
        carListEventHandler.updateData()
    }
}

// MARK: Database methods
extension DataBaseManager {
    
    func saveCar(car: Car) {
        selectedDataBase.saveCar(car: car)
    }
    
    func deleteCar(id: Int64) {
        selectedDataBase.deleteCar(id: id)
    }
    
    func fetchCars() -> [Car] {
        let cars = selectedDataBase.fetchCars()
        if cars.isEmpty {
            let cars = fetchCarsFromLocalFile()
            cars.forEach {
                saveCar(car: $0)
            }
            return cars
        }
        return cars
    }
    
    private func fetchCarsFromLocalFile() -> [Car] {
        Bundle.main.decode([Car].self, from: Constants.carsFileName)
    }
}

// MARK: Constants
private extension DataBaseManager {
    
    enum Constants {
        static let dataBaseType = "DataBaseType"
        static let carsFileName = "Cars.json"
    }
}
