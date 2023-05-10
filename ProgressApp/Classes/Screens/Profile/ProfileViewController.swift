//
//  ProfileViewController.swift
//  ProgressApp
//
//  Created by Aliaksandr on 5.09.22.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var topBarView: TopBarView!
    
    @IBOutlet private weak var backgroundView: UIView!
    
    @IBOutlet private weak var dataBaseButton: UIButton!
    @IBOutlet private weak var dataBaseMenu: UIMenu!
    @IBOutlet private weak var selectedDatabaseLabel: UILabel!
    
    @IBOutlet private weak var asyncOperationsButton: UIButton!
    @IBOutlet private weak var asyncOperationsMenu: UIMenu!
    @IBOutlet private weak var selectedAsyncOperationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

// MARK: Setup
private extension ProfileViewController {
    
    func setup() {
        view.backgroundColor = .systemGray2
        topBarView.configure(title: R.string.localizable.profileBadgeValue())
        setupDataBaseMenu()
        setupAsyncOperationsMenu()
        setupBackgroundView()
        setupButton(button: dataBaseButton, title: Constants.dataBaseTitle)
        setupButton(button: asyncOperationsButton, title: Constants.asyncOperationsTitle)
        setupSelectedLabels()
    }
    
    func setupDataBaseMenu() {
        let coreDataItem = UIAction.init(
            title: DataBase.coreData.name,
            handler: { [weak self] _ in
                DataBaseManager.shared.setSelectedDataBase(selectedDataBase: .coreData)
                self?.selectedDatabaseLabel.text = DataBase.coreData.name
            }
        )
        let realmItem = UIAction.init(
            title: DataBase.realm.name,
            handler: { [weak self] _ in
                DataBaseManager.shared.setSelectedDataBase(selectedDataBase: .realm)
                self?.selectedDatabaseLabel.text = DataBase.realm.name
            }
        )
        let fireBaseItem = UIAction.init(
            title: DataBase.realm.name,
            handler: { [weak self] _ in
                DataBaseManager.shared.setSelectedDataBase(selectedDataBase: .firebase)
                self?.selectedDatabaseLabel.text = DataBase.realm.name
            }
        )
        let items = [coreDataItem, realmItem, fireBaseItem]
        let menu = UIMenu(title: Constants.dataBaseMenu, children: items)
        dataBaseButton.menu = menu
        dataBaseButton.showsMenuAsPrimaryAction = true
    }
    
    func setupAsyncOperationsMenu() {
        let gcdItem = UIAction.init(
            title: AsyncManager.Operation.grandCentralDispatch.name,
            handler: { [weak self] _ in
                AsyncManager.shared.setSelectedOperation(operation: .grandCentralDispatch)
                self?.selectedAsyncOperationLabel.text = AsyncManager.Operation.grandCentralDispatch.name
            }
        )
        let operationQueueItem = UIAction.init(
            title: AsyncManager.Operation.operationQueue.name,
            handler: { [weak self] _ in
                AsyncManager.shared.setSelectedOperation(operation: .operationQueue)
                self?.selectedAsyncOperationLabel.text = AsyncManager.Operation.operationQueue.name
            }
        )
        let items = [gcdItem, operationQueueItem]
        let menu = UIMenu(title: Constants.asyncOperationsMenu, children: items)
        asyncOperationsButton.menu = menu
        asyncOperationsButton.showsMenuAsPrimaryAction = true
    }
    
    func setupBackgroundView() {
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 10
    }
    
    func setupButton(button: UIButton, title: String) {
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                          NSAttributedString.Key.foregroundColor: UIColor.white]
        let title = NSMutableAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(title, for: .normal)
    }
    
    func setupSelectedLabels() {
        selectedDatabaseLabel.text = DataBaseManager.shared.selectedDataBase.name
        selectedAsyncOperationLabel.text = AsyncManager.shared.currentOperation.name
    }
}

// MARK: Constants
private extension ProfileViewController {
    
    enum Constants {
        static let dataBaseTitle = "DataBase"
        static let dataBaseMenu = "Select Data Base..."
        static let asyncOperationsTitle = "AsyncOperations"
        static let asyncOperationsMenu = "Select Async Operations..."
    }
}

fileprivate extension AsyncManager.Operation {
    
    var name: String {
        switch self {
        case .grandCentralDispatch:
            return "GCD"
        case .operationQueue:
            return "OperationQueue"
        }
    }
}

fileprivate extension DataBase {
    
    var name: String {
        switch self {
        case .coreData:
            return "Core Data"
        case .realm:
            return "Realm"
        case .firebase:
            return "Fire Base"
        }
    }
}
