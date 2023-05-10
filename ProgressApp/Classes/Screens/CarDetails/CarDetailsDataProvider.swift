//
//  CarDetailsDataProvider.swift
//  ProgressApp
//
//  Created by Aliaksandr on 12.09.22.
//

import Foundation

final class CarDetailsDataProvider {
    
    private let car: Car
    
    init(car: Car) {
        self.car = car
    }
    
    func getSections() -> [CollectionViewSection] {
        let photosSection = CollectionViewSection(
            type: .photos,
            photosSectionData: .init(from: car),
            characteristicsSectionsData: nil
        )
        
        let characteristicsSection = CollectionViewSection(
            type: .characteristics,
            photosSectionData: nil,
            characteristicsSectionsData: CollectionViewCharacteristicsSectionsData.init(from: car).sections
        )
        
        return [photosSection, characteristicsSection]
    }
    
    func getCarName() -> String {
        car.name
    }
}

// MARK: CollectionViewSection
extension CarDetailsDataProvider {
    
    struct CollectionViewSection {
        let type: CollectionViewSectionsType
        let photosSectionData: CollectionViewPhotosSectionsData?
        let characteristicsSectionsData: [CharacteristicsSectionsData]?
    }
}

// MARK: CharacteristicsSection
extension CarDetailsDataProvider {
    
    struct CharacteristicsSectionsData {
        let label: String
        let value: String
        let isFirstItem: Bool
        let isLastItem: Bool
        
        init(
            label: String,
            value: String,
            isFirstItem: Bool = false,
            isLastItem: Bool = false
        ) {
            self.label = label
            self.value = value
            self.isFirstItem = isFirstItem
            self.isLastItem = isLastItem
        }
    }
}

// MARK: CollectionViewSectionsData
extension CarDetailsDataProvider {
    
    struct CollectionViewPhotosSectionsData {
        let car: Car
        
        init(from car: Car) {
            self.car = car
        }
    }
    
    struct CollectionViewCharacteristicsSectionsData {
        let manufacturer: String
        let model: String
        let carDescription: String
        let weight: Float
        let maxSpeed: Float
        let fuelConsuption: String
        
        init(from car: Car) {
            manufacturer = car.manufacturer
            model = car.model
            carDescription = car.carDescription
            weight = car.weight
            maxSpeed = car.maxSpeed
            fuelConsuption = car.fuelConsuption
        }
        
        var sections: [CharacteristicsSectionsData] {
            [.init(label: R.string.localizable.carDetailsCharacteristicsManufacturer(), value: manufacturer, isFirstItem: true),
             .init(label: R.string.localizable.carDetailsCharacteristicsModel(), value: model),
             .init(label: R.string.localizable.carDetailsCharacteristicsCarDescription(), value: carDescription),
             .init(label: R.string.localizable.carDetailsCharacteristicsWeight(), value: String(weight)),
             .init(label: R.string.localizable.carDetailsCharacteristicsMaxSpeed(), value: String(maxSpeed)),
             .init(label: R.string.localizable.carDetailsCharacteristicsFuelConsuption(), value: fuelConsuption, isLastItem: true)]
        }
    }
}

// MARK: CollectionViewSectionsType
extension CarDetailsDataProvider {
    
    enum CollectionViewSectionsType {
        case photos
        case characteristics
        
        var title: String {
            switch self {
            case .photos:
                return ""
            case .characteristics:
                return R.string.localizable.carDetailsSectionHeaderCharacteristics()
            }
        }
        
        var itemsInSection: Int {
            switch self {
            case .photos:
                return 1
            case .characteristics:
                return 6
            }
        }
    }
}
