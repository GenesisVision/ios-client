//
//  MakeSignalViewController.swift
//  genesisvision-ios
//
//  Created by George on 03.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class MakeSignalViewController: BaseModalViewController, BaseCellProtocol {
    typealias ViewModel = MakeSignalViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: MakeSignalStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg

        stackView.configure()
        
        viewModel = MakeSignalViewModel(self)
    }
    
    // MARK: - Actions
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        showImagePicker()
    }
    @IBAction func makeSignalButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
}

extension MakeSignalViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        return stackView.uploadLogoView.uploadLogoButton
    }
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        guard let pickedImage = pickedImage, let pickedImageURL = pickedImageURL else { return }
        
        viewModel.pickedImage = pickedImage
        viewModel.pickedImageURL = pickedImageURL
        
        stackView.uploadLogoView.uploadLogoButton.isHidden = true
        stackView.uploadLogoView.logoStackView.isHidden = false
        stackView.uploadLogoView.imageView.image = pickedImage
    }
}

class MakeSignalViewModel {
    // MARK: - Variables
    var pickedImage: UIImage?
    var pickedImageURL: URL?
    var uploadedUuidString: String?
    
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    func saveProfilePhoto(completion: @escaping CompletionBlock) {
        guard let pickedImageURL = pickedImageURL else {
            return completion(.failure(errorType: .apiError(message: nil)))
        }
        BaseDataProvider.uploadImage(imageURL: pickedImageURL, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult.id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedUuidString = uuidString
            completion(.success)
        }, errorCompletion: completion)
    }
}
