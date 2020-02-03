//
//  MakeSignalViewController.swift
//  genesisvision-ios
//
//  Created by George on 03.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class MakeSignalViewController: BaseModalViewController, BaseTableViewProtocol {
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

        setup()
    }
    
    func setup() {
        viewModel = MakeSignalViewModel(self)
        
        stackView.nameView.textField.delegate = self
        stackView.nameView.textField.designableTextFieldDelegate = self
        stackView.nameView.textField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
        stackView.nameView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        
        stackView.descriptionView.textView.textContainerInset = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: -6)
        stackView.descriptionView.textView.delegate = self
        stackView.descriptionView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        
        stackView.volumeFeeView.textField.designableTextFieldDelegate = self
        stackView.volumeFeeView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        stackView.signalSuccessFeeView.textField.designableTextFieldDelegate = self
        stackView.signalSuccessFeeView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        
        stackView.volumeFeeView.textField.text = "0"
        stackView.signalSuccessFeeView.textField.text = "0"
    }
    
    func setupUI() {
        stackView.configure()
    }
    
    @objc private func nameDidChange() {
        if let text = stackView.nameView.textField.text {
            let max = 20
            let count = text.count
            stackView.nameView.subtitleValueLabel.text = "\(count) / \(max)"
            stackView.nameView.subtitleValueLabel.textColor = count < 4 || count > 20 ? UIColor.Common.red : UIColor.Cell.subtitle
        }
        checkActionButton()
    }
    
    @objc func checkActionButton() {
        guard let name = stackView.nameView.textField.text,
            let description = stackView.descriptionView.textView.text,
            let volumeFee = stackView.volumeFeeView.textField.text,
            let signalSuccessFee = stackView.signalSuccessFeeView.textField.text else { return }
        
        let value = name.count >= 4 && name.count <= 20 && description.count >= 20 && description.count <= 500 && !volumeFee.isEmpty && !signalSuccessFee.isEmpty
        
        stackView.actionButton.setEnabled(value)
    }
    
    // MARK: - Actions
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        showImagePicker()
    }
    @IBAction func makeSignalButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let title = stackView.nameView.textField.text {
            viewModel.request.title = title
        }
        if let description = stackView.descriptionView.textView.text {
            viewModel.request.description = description
        }
        if let volumeFee = stackView.volumeFeeView.textField.text?.doubleValue {
            viewModel.request.volumeFee = volumeFee
        }
        if let successFee = stackView.signalSuccessFeeView.textField.text?.doubleValue {
            viewModel.request.successFee = successFee
        }
        
        showProgressHUD()
        viewModel.makeSignal { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
}
extension MakeSignalViewController: UITextFieldDelegate, DesignableUITextFieldDelegate {
    func textFieldDidClear(_ textField: UITextField) {
        stackView.nameView.subtitleValueLabel.text = "0 / 20"
        stackView.nameView.subtitleValueLabel.textColor = UIColor.Cell.subtitle
        checkActionButton()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkActionButton()
    }
}

extension MakeSignalViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = stackView.descriptionView.textView.text {
            let max = 500
            let count = text.count
            stackView.descriptionView.subtitleValueLabel.text = "\(count) / \(max)"
            stackView.descriptionView.subtitleValueLabel.textColor = count < 20 || count > 500 ? UIColor.Common.red : UIColor.Cell.subtitle
        }
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
    var uploadedUuidString: String? {
        didSet {
            request.logo = uploadedUuidString
        }
    }
    
    var request = MakeTradingAccountSignalProvider(id: nil, volumeFee: nil, successFee: nil, title: nil, description: nil, logo: nil)
    weak var delegate: BaseTableViewProtocol?
    init(_ delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    func saveImage(_ pickedImageURL: URL, completion: @escaping (CompletionBlock)) {
        BaseDataProvider.uploadImage(imageURL: pickedImageURL, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult.id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedUuidString = uuidString
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func makeSignal(completion: @escaping CompletionBlock) {
        guard let pickedImageURL = pickedImageURL else {
            AssetsDataProvider.makeAccountSignalProvider(request, completion: completion)
            return
        }
        saveImage(pickedImageURL) { [weak self] (result) in
            switch result {
            case .success:
                AssetsDataProvider.makeAccountSignalProvider(self?.request, completion: completion)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
}
