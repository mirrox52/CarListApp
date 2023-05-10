//
//  CarCoreData+CoreDataClass.swift
//  ProgressApp
//
//  Created by Aliaksandr on 19.10.22.
//
//

import Foundation
import CoreData

@objc(CarCoreData)
public class CarCoreData: NSManagedObject {

    convenience init() {
        let entity = NSEntityDescription.entity(forEntityName: "CarCoreData", in: CoreDataManager.shared.managedObjectContext)
        self.init(entity: entity!, insertInto: CoreDataManager.shared.managedObjectContext)
    }
}
