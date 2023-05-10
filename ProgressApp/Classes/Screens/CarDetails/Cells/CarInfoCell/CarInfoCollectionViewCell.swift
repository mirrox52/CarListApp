//
//  CarInfoCollectionViewCell.swift
//  ProgressApp
//
//  Created by Aliaksandr on 14.09.22.
//

import UIKit

final class CarInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var characteristicLabel: UILabel!
    @IBOutlet private weak var characteristicValueLabel: UILabel!
    @IBOutlet private weak var bottomLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 0
        mainView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        bottomLineView.isHidden = false
        bottomLineView.backgroundColor = .systemGray2
    }
    
    func configure(data: CarDetailsDataProvider.CharacteristicsSectionsData) {
        characteristicLabel.text = data.label + ":"
        characteristicValueLabel.text = data.value
        
        if data.isFirstItem {
            mainView.layer.cornerRadius = 10
            mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        
        if data.isLastItem {
            mainView.layer.cornerRadius = 10
            mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            bottomLineView.isHidden = true
        }
    }
}
