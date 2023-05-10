//
//  AddCarPhotoCollectionViewCell.swift
//  ProgressApp
//
//  Created by Aliaksandr on 11.10.22.
//

import UIKit

final class AddCarPhotoCollectionViewCell: UICollectionViewCell {

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func configure(image: UIImage) {
        photoImageView.image = image
    }
}

// MARK: Private
private extension AddCarPhotoCollectionViewCell {
    
    func setup() {
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
