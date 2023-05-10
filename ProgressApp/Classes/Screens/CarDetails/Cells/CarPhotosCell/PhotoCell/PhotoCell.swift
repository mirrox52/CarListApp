//
//  PhotoCell.swift
//  ProgressApp
//
//  Created by Aliaksandr on 14.09.22.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func configure(with data: Data) {
        configureImage(with: data)
    }
    
    private func setup() {
        imageView.isHidden = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func configureImage(with data: Data) {
        AsyncManager.shared.currentOperation == .grandCentralDispatch ?
        setImageGCD(with: data) :
        setImageOperationQueue(with: data)
    }
    
    func setImageGCD(with data: Data) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if let image = UIImage(data: data) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.imageView.isHidden = false
                self.imageView.image = image
            }
        }
    }
    
    func setImageOperationQueue(with data: Data) {
        let downloadImage = BlockOperation { [weak self] in
            guard let self else { return }
            if let image = UIImage(data: data) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.imageView.isHidden = false
                self.imageView.image = image
            }
        }
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.addOperation(downloadImage)
    }
}
