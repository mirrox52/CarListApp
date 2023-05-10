//
//  CarCoreData+CoreDataProperties.swift
//  ProgressApp
//
//  Created by Aliaksandr on 19.10.22.
//
//

import Foundation
import CoreData


extension CarCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarCoreData> {
        NSFetchRequest<CarCoreData>(entityName: "CarCoreData")
    }

    @NSManaged public var carDescription: String?
    @NSManaged public var fuelConsuption: String?
    @NSManaged public var imagesData: [Data]?
    @NSManaged public var imagesUrl: [URL]?
    @NSManaged public var manufacturer: String?
    @NSManaged public var maxSpeed: Float
    @NSManaged public var model: String?
    @NSManaged public var weight: Float
    @NSManaged public var id: Int64

}

extension CarCoreData : Identifiable {

}
