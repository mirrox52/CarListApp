//
//  FirebaseManager.swift
//  ProgressApp
//
//  Created by Aliaksandr on 22.10.22.
//

import Firebase

final class FireBaseManager {
    
    private init() { }
    
    static let shared = FireBaseManager()
    
    private let ref = Database.database().reference()
    
    func fetchCars(_ completion: @escaping ([Car]) -> Void) {
        ref.observe(.value) { [weak self] snapshot in
            guard let self else { return }
            AsyncManager.shared.currentOperation == .grandCentralDispatch ?
            self.loadDataGCD(snapshot: snapshot, completion) :
            self.loadDataOperationQueue(snapshot: snapshot, completion)
        }
    }
    
    func addValue(car: Car) {
        ref.child(String(car.id)).setValue(car.dictionary)
    }
    
    func removeValue(id: String) {
        ref.child(id).removeValue()
    }
}

// MARK: Private
private extension FireBaseManager {
    
    func loadDataGCD(snapshot: DataSnapshot, _ completion: @escaping ([Car]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let cars = try? JSONDecoder().decode([Car].self, from: snapshot.listToJSON) else { return }
            completion(cars)
        }
    }
    
    func loadDataOperationQueue(snapshot: DataSnapshot, _ completion: @escaping ([Car]) -> Void) {
        let downloadData = BlockOperation {
            guard let cars = try? JSONDecoder().decode([Car].self, from: snapshot.listToJSON) else { return }
            completion(cars)
        }
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        queue.addOperation(downloadData)
    }
}

fileprivate extension Dictionary {
    
    var JSON: Data {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        } catch {
            return Data()
        }
    }
}

fileprivate extension DataSnapshot {
    
    var valueToJSON: Data {
        guard let dictionary = value as? [String: Any] else { return Data() }
        
        return dictionary.JSON
    }
    
    var listToJSON: Data {
        guard let object = children.allObjects as? [DataSnapshot] else { return Data() }
        
        let dictionary = object.compactMap { $0.value as? NSDictionary }
        
        do {
            return try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            return Data()
        }
    }
}

fileprivate extension Encodable {
    
    var dictionary: [String: Any] {
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self)) as? [String: Any] else { return [:] }
            return dictionary
        } catch {
            return [:]
        }
    }
}
