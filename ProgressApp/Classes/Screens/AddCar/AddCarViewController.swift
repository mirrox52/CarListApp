//
//  AddCarViewController.swift
//  ProgressApp
//
//  Created by Aliaksandr on 22.09.22.
//

import UIKit
import PhotosUI

final class AddCarViewController: UIViewController {
    
    @IBOutlet private weak var topBarView: TopBarView!
    
    @IBOutlet private weak var manufacturerLabel: UILabel!
    @IBOutlet private weak var manufactorerTextField: UITextField!
    
    @IBOutlet private weak var modelLabel: UILabel!
    @IBOutlet private weak var modelTextField: UITextField!
    
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var weightTextField: UITextField!
    
    @IBOutlet private weak var maxSpeedLabel: UILabel!
    @IBOutlet private weak var maxSpeedTextField: UITextField!
    
    @IBOutlet private weak var fuelConsuptionLabel: UILabel!
    @IBOutlet private weak var fuelConsuptionTextField: UITextField!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    @IBOutlet private weak var imagesLabel: UILabel!
    @IBOutlet private weak var addImagesButton: UIButton!
    @IBOutlet private weak var imagesCollectionView: UICollectionView!
    
    @IBOutlet private weak var addCarButton: UIButton!
    
    private var images = [UIImage]()
    private var addCarEventHandler: AddCarNavigationDelegate?
    private var carListEventHandler: CarListEventHandler?
    
    @IBAction private func addButtonTapped(_ sender: Any) {
        saveCar()
    }
    
    @IBAction private func addImagesTapped(_ sender: Any) {
        addImages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func configure(addCarEventHandler: AddCarNavigationDelegate,
                   carListEventHandler: CarListEventHandler) {
        self.addCarEventHandler = addCarEventHandler
        self.carListEventHandler = carListEventHandler
    }
}

// MARK: Setup
private extension AddCarViewController {
    
    func setup() {
        setupLabels()
        setupCollectionView()
        setupTopBarView()
    }
    
    func setupLabels() {
        manufacturerLabel.text = R.string.localizable.carDetailsCharacteristicsManufacturer()
        modelLabel.text = R.string.localizable.carDetailsCharacteristicsModel()
        weightLabel.text = R.string.localizable.carDetailsCharacteristicsWeight()
        maxSpeedLabel.text = R.string.localizable.carDetailsCharacteristicsMaxSpeed()
        fuelConsuptionLabel.text = R.string.localizable.carDetailsCharacteristicsFuelConsuption()
        descriptionLabel.text = R.string.localizable.carDetailsCharacteristicsCarDescription()
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        descriptionTextView.layer.borderColor = color
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5
        addCarButton.setTitle(R.string.localizable.addCarAddCarButtonText(), for: .normal)
    }
    
    func setupCollectionView() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(AddCarPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "AddCarPhotoCollectionViewCell")
    }
    
    func setupTopBarView() {
        topBarView.configure(
            title: R.string.localizable.addCarAddCarButtonText(),
            isBackButtonHidden: false,
            eventHandler: self
        )
    }
}

// MARK: Private
private extension AddCarViewController {
    
    func saveCar() {
        if let manufactorer = manufactorerTextField.text, !manufactorer.isEmpty,
           let model = modelTextField.text, !model.isEmpty,
           let weight = Float(weightTextField.text ?? ""),
           let maxSpeed = Float(maxSpeedTextField.text ?? ""),
           let fuelConsuption = fuelConsuptionTextField.text, !fuelConsuption.isEmpty,
           let description = descriptionTextView.text, !description.isEmpty {
            let car = Car(
                id: Int64.random(in: 0...Int64.max),
                manufacturer: manufactorer,
                model: model,
                carDescription: description,
                weight: weight,
                maxSpeed: maxSpeed,
                fuelConsuption: fuelConsuption,
                imagesUrl: nil,
                imagesData: images.compactMap { $0.pngData() }
            )
            DataBaseManager.shared.saveCar(car: car)
        }
        addCarEventHandler?.back()
        carListEventHandler?.updateData()
    }
    
    func addImages() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension AddCarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "AddCarPhotoCollectionViewCell",
                                                                for: indexPath) as? AddCarPhotoCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(image: images[indexPath.row])
        return cell
    }
}

// MARK: PHPickerViewControllerDelegate
extension AddCarViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let imageItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
        
        let dispatchGroup = DispatchGroup()
        var images = [UIImage]()
        
        for imageItem in imageItems {
            dispatchGroup.enter()
            
            imageItem.loadObject(ofClass: UIImage.self) { image, _ in
                if let image = image as? UIImage {
                    images.append(image)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.images = images
            self.imagesCollectionView.reloadData()
        }
    }
}

// MARK: TopBarViewEventHandler
extension AddCarViewController: TopBarViewEventHandler {
    
    func back() {
        addCarEventHandler?.back()
    }
}
