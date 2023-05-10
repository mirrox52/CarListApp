//
//  CarItemCell.swift
//  ProgressApp
//
//  Created by Aliaksandr on 6.09.22.
//

import UIKit

final class CarItemCell: UITableViewCell {

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private(set) weak var carImageView: UIImageView!
    @IBOutlet private weak var carMakeLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func configure(with car: Car) {
        carMakeLabel.text = car.name
        car.getImages() { [weak self] in
            guard let self else { return }
            self.configureCarImage(with: $0?.first)
        }
    }
    
    private func setup() {
        carImageView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = .white
        
        selectionStyle = .none
    }
}

// MARK: Private
private extension CarItemCell {
    
    func configureCarImage(with data: Data?) {
        guard let data else { return }
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
                self.carImageView.isHidden = false
                self.carImageView.image = image
            }
        }
    }
    
    func setImageOperationQueue(with data: Data) {
        let downloadImage = BlockOperation { [weak self] in
            guard let self else { return }
            if let image = UIImage(data: data) {
                OperationQueue.main.addOperation {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.carImageView.isHidden = false
                    self.carImageView.image = image
                }
            }
        }
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.addOperation(downloadImage)
    }
}
