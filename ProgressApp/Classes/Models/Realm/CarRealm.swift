//
//  CarRealm.swift
//  ProgressApp
//
//  Created by Aliaksandr on 22.10.22.
//

import RealmSwift

final class CarRealm: Object {
    
    @objc dynamic var carDescription: String = ""
    @objc dynamic var fuelConsuption: String = ""
    @objc dynamic var manufacturer: String = ""
    @objc dynamic var maxSpeed: Float = 0
    @objc dynamic var model: String = ""
    @objc dynamic var weight: Float = 0
    @objc dynamic var id: Int64 = 0
    
    var imagesData = List<Data>()
    var imagesUrl = List<String>()
    
    convenience init(
        carDescription: String,
        fuelConsuption: String,
        imagesData: [Data]?,
        imagesUrl: [URL]?,
        manufacturer: String,
        maxSpeed: Float,
        model: String,
        weight: Float,
        id: Int64
    ) {
        self.init()
        self.carDescription = carDescription
        self.fuelConsuption = fuelConsuption
        self.manufacturer = manufacturer
        self.maxSpeed = maxSpeed
        self.model = model
        self.weight = weight
        self.id = id
        imagesData?.forEach { self.imagesData.append($0) }
        imagesUrl?.forEach { self.imagesUrl.append($0.absoluteString) }
    }
    
    convenience init(from car: Car) {
        self.init()
        self.carDescription = car.carDescription
        self.fuelConsuption = car.fuelConsuption
        self.manufacturer = car.manufacturer
        self.maxSpeed = car.maxSpeed
        self.model = car.model
        self.weight = car.weight
        self.id = car.id
        car.imagesData?.forEach { self.imagesData.append($0) }
        car.imagesUrl?.forEach { self.imagesUrl.append($0.absoluteString) }
    }
    
    override class func primaryKey() -> String? {
        #keyPath(CarRealm.id)
    }
}
