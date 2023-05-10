//
//  CarPhotosCollectionViewCell.swift
//  ProgressApp
//
//  Created by Aliaksandr on 14.09.22.
//

import UIKit

final class CarPhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private var images = [Data()]
    
    func configure(with car: Car) {
        car.getImages() { [weak self] in
            guard let self else { return }
            self.images = $0 ?? []
            self.pageControl.numberOfPages = $0?.count ?? 0
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(R.nib.photoCell)
        pageControl.currentPage = 0
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension CarPhotosCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.photoCell, for: indexPath)
        else { return UICollectionViewCell() }
        cell.configure(with: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CarPhotosCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
