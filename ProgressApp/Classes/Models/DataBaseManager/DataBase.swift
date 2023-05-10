//
//  DataBase.swift
//  ProgressApp
//
//  Created by Aliaksandr on 18.10.22.
//

enum DataBase: String {
    
    case coreData
    case realm
    case firebase
    
    func fetchCars() -> [Car] {
        switch self {
        case .coreData:
            return fetchCarsCoreData()
        case .realm:
            return fetchCarsRealm()
        case .firebase:
            return fetchCarsFirebase()
        }
    }
    
    func saveCar(car: Car) {
        switch self {
        case .coreData:
            saveCarCoreData(car: car)
        case .realm:
            saveCarRealm(car: car)
        case .firebase:
            saveCarFirebase(car: car)
        }
    }
    
    func deleteCar(id: Int64) {
        switch self {
        case .coreData:
            deleteCarCoreData(id: id)
        case .realm:
            deleteCarRealm(id: id)
        case .firebase:
            deleteCarFirebase(id: id)
        }
    }
}

// MARK: CoreData
private extension DataBase {
    
    func fetchCarsCoreData() -> [Car] {
        CoreDataManager.shared.fetchCars().compactMap { Car.init(from: $0) }
    }
    
    func saveCarCoreData(car: Car) {
        let carCoreData = CarCoreData()
        carCoreData.id = car.id
        carCoreData.fuelConsuption = car.fuelConsuption
        carCoreData.maxSpeed = car.maxSpeed
        carCoreData.weight = car.weight
        carCoreData.model = car.model
        carCoreData.carDescription = car.carDescription
        carCoreData.manufacturer = car.manufacturer
        carCoreData.imagesData = car.imagesData
        carCoreData.imagesUrl = car.imagesUrl
        CoreDataManager.shared.saveContext()
    }
    
    func deleteCarCoreData(id: Int64) {
        let cars = CoreDataManager.shared.fetchCars()
        guard let deletedCar = cars.first(where: { $0.id == id }) else { return }
        CoreDataManager.shared.managedObjectContext.delete(deletedCar)
        CoreDataManager.shared.saveContext()
    }
}

// MARK: Realm
private extension DataBase {
    
    func fetchCarsRealm() -> [Car] {
        guard let cars = RealmManager.shared.objects(CarRealm.self) else { return [] }
        return Array(cars.compactMap { Car.init(from: $0) })
    }
    
    func saveCarRealm(car: Car) {
        let carRealm = CarRealm(from: car)
        RealmManager.shared.add(carRealm)
    }
    
    func deleteCarRealm(id: Int64) {
        guard
            let cars = RealmManager.shared.objects(CarRealm.self),
            let deletedCar = cars.first(where: { $0.id == id })
        else { return }
        RealmManager.shared.delete(deletedCar)
    }
}

// MARK: Firebase
private extension DataBase {
    
    func fetchCarsFirebase() -> [Car] {
        var cars = [Car]()
        FireBaseManager.shared.fetchCars {
            cars = $0
        }
        return cars
    }
    
    func saveCarFirebase(car: Car) {
        FireBaseManager.shared.addValue(car: car)
    }
    
    func deleteCarFirebase(id: Int64) {
        FireBaseManager.shared.removeValue(id: String(id))
    }
}
