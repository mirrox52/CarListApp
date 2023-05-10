//
//  AsyncManager.swift
//  ProgressApp
//
//  Created by Aliaksandr on 7.05.23.
//

import Foundation.NSUserDefaults

final class AsyncManager {
    
    enum Operation: String {
        case grandCentralDispatch
        case operationQueue
    }
    
    private init() {}
    static let shared = AsyncManager()
    
    var currentOperation = Operation.grandCentralDispatch
}

// MARK: Setup
extension AsyncManager {
    
    func setupSelectedAsyncOperation() {
        var currentOperation = Operation.grandCentralDispatch
        if let rawValue = UserDefaults.standard.string(forKey: Constants.asyncType) {
            currentOperation = Operation(rawValue: rawValue) ?? .grandCentralDispatch
        } else {
            UserDefaults.standard.set(currentOperation.rawValue, forKey: Constants.asyncType)
        }
        self.currentOperation = currentOperation
    }
    
    func setSelectedOperation(operation: Operation) {
        self.currentOperation = operation
        UserDefaults.standard.set(currentOperation.rawValue, forKey: Constants.asyncType)
    }
}

// MARK: Constants
private extension AsyncManager {
    
    enum Constants {
        static let asyncType = "AsyncType"
    }
}
