//
//  CarDetailsViewController.swift
//  ProgressApp
//
//  Created by Aliaksandr on 9.09.22.
//

import UIKit

final class CarDetailsViewController: UIViewController {

    @IBOutlet private(set) weak var topBarView: TopBarView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var eventHandler: CarDetailsNavigationDelegate?
    private var dataProvider: CarDetailsDataProvider?
    private var sections: [CarDetailsDataProvider.CollectionViewSection] {
        dataProvider?.getSections() ?? []
    }
    
    private(set) var carPhotosCollectionViewCell: CarPhotosCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func configure(car: Car, eventHandler: CarDetailsNavigationDelegate) {
        dataProvider = CarDetailsDataProvider(car: car)
        self.eventHandler = eventHandler
    }
    
    private func setup() {
        view.backgroundColor = .systemGray2
        navigationController?.title = dataProvider?.getCarName()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(R.nib.carInfoCollectionViewCell)
        collectionView.register(R.nib.carPhotosCollectionViewCell)
        
        topBarView.configure(
            title: dataProvider?.getCarName() ?? "",
            isBackButtonHidden: false,
            eventHandler: self
        )
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension CarDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].type.itemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .photos:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.carPhotosCollectionViewCell, for: indexPath),
                let car = section.photosSectionData?.car
            else { return UICollectionViewCell() }
            carPhotosCollectionViewCell = cell
            cell.configure(with: car)
            return cell
        case .characteristics:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.carInfoCollectionViewCell, for: indexPath),
                let data = section.characteristicsSectionsData?[indexPath.row]
            else { return UICollectionViewCell() }
            cell.configure(data: data)
            return cell
        }
    }
}

// MARK: UICollectionViewLayout
private extension CarDetailsViewController {
    
    var collectionViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            let section = self.sections[sectionIndex]
            switch section.type {
            case .photos:
                return self.photosSection
            case .characteristics:
                return self.characteristicsSection
            }
        }
        return layout
    }
    
    var photosSection: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    var characteristicsSection: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: TopBarViewEventHandler
extension CarDetailsViewController: TopBarViewEventHandler {
    
    func back() {
        eventHandler?.back()
    }
}
