//
//  Car.swift
//  ProgressApp
//
//  Created by Aliaksandr on 6.09.22.
//

import Foundation

struct Car: Codable, Hashable {
    
    let id: Int64
    let manufacturer: String
    let model: String
    let carDescription: String
    let weight: Float
    let maxSpeed: Float
    let fuelConsuption: String
    let imagesUrl: [URL]?
    let imagesData: [Data]?
    
    func getImages(_ completion: @escaping (([Data]?) -> Void)) {
        if let imagesData {
            completion(imagesData)
        }
        if let imagesUrl {
            AsyncManager.shared.currentOperation == .grandCentralDispatch ?
            loadImagesGCD(imagesUrl: imagesUrl, completion) :
            loadImagesOperationQueue(imagesUrl: imagesUrl, completion)
        }
    }
    
    var name: String {
        manufacturer + " " + model
    }
}

// MARK: DataBase
extension Car {
    
    init?(from coreDataModel: CarCoreData?) {
        guard
            let coreDataModel = coreDataModel,
            let manufacturer = coreDataModel.manufacturer,
            let model = coreDataModel.model,
            let carDescription = coreDataModel.carDescription,
            let fuelConsuption = coreDataModel.fuelConsuption
        else { return nil }
        
        self.id = coreDataModel.id
        self.manufacturer = manufacturer
        self.model = model
        self.carDescription = carDescription
        self.weight = coreDataModel.weight
        self.maxSpeed = coreDataModel.maxSpeed
        self.fuelConsuption = fuelConsuption
        self.imagesUrl = coreDataModel.imagesUrl
        self.imagesData = coreDataModel.imagesData
    }
    
    init(from carRealm: CarRealm) {
        self.id = carRealm.id
        self.manufacturer = carRealm.manufacturer
        self.model = carRealm.model
        self.carDescription = carRealm.carDescription
        self.weight = carRealm.weight
        self.maxSpeed = carRealm.maxSpeed
        self.fuelConsuption = carRealm.fuelConsuption
        
        var data = [Data]()
        carRealm.imagesData.forEach { data.append($0) }
        self.imagesData = data
        
        var urls = [URL]()
        carRealm.imagesUrl.forEach {
            if let url = URL(string: $0) {
                urls.append(url)
            }
        }
        self.imagesUrl = urls
    }
}

// MARK: Private
private extension Car {
    
    func loadImagesGCD(imagesUrl: [URL], _ completion: @escaping (([Data]?) -> Void)) {
        let group = DispatchGroup()
        var dataOfImages = [Data]()
        imagesUrl.forEach { url in
            group.enter()
            DispatchQueue.global(qos: .userInteractive).async {
                if let data = try? Data(contentsOf: url) {
                    dataOfImages.append(data)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(dataOfImages)
        }
    }
    
    func loadImagesOperationQueue(imagesUrl: [URL], _ completion: @escaping (([Data]?) -> Void)) {
        var dataOfImages = [Data]()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        let operations = imagesUrl.map { url -> BlockOperation in
            let operation = BlockOperation()
            operation.addExecutionBlock {
                if let data = try? Data(contentsOf: url) {
                    dataOfImages.append(data)
                }
            }
            return operation
        }
        queue.addOperations(operations, waitUntilFinished: true)
        completion(dataOfImages)
    }
}
