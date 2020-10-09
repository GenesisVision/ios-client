//
//  FundEditPublicInfoViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 25.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class FundEditPublicInfoViewController: BaseViewController {
    
    var viewModel: FundEditPublicInfoViewModel!
    
    @IBOutlet weak var titleTextField: DesignableUITextField! {
        didSet {
            titleTextField.addTarget(self, action: #selector(titleFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var titleCountLabel: TitleLabel! {
        didSet {
            titleCountLabel.text = "0 / \(maxTitleLenght)"
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.delegate = self
        }
    }
    
    @IBOutlet weak var descriptionCountLabel: TitleLabel! {
        didSet {
            descriptionCountLabel.text = "0 / \(maxDescriptionLenght)"
        }
    }
    
    @IBOutlet weak var logoTitle: TitleLabel! {
        didSet {
            logoTitle.font = UIFont.getFont(.bold, size: 16)
        }
    }
    
    @IBOutlet weak var logoDescription: SubtitleLabel! {
        didSet {
            logoDescription.text = "At least 300x300px PNG or JPG file\nThe maximum file size is 2MB"
        }
    }
    
    @IBOutlet weak var uploadLogoButton: ActionButton! {
        didSet {
            uploadLogoButton.configure(with: .darkClear)
        }
    }
    
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.roundCorners(with: 10)
        }
    }
    
    @IBOutlet weak var removeImageButton: UIButton!
    
    private let maxTitleLenght = 20
    private let maxDescriptionLenght =  500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Public Info"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    private func setup() {
        viewModel.fetch { (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.updateUI()
                }
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func updateUI() {
        guard let titleText = viewModel.fundPublicInfo?.title,
            let descriptionText = viewModel.fundPublicInfo?._description, let urlString = viewModel.fundPublicInfo?.logoUrl, let logoURL = getFileURL(fileName: urlString) else { return }
        
        titleTextField.text = titleText
        descriptionTextView.text = descriptionText
        titleCountLabel.text = "\(titleText.count) / \(maxTitleLenght)"
        descriptionCountLabel.text = "\(descriptionText.count) / \(maxDescriptionLenght)"
        
        logoImageView.kf.setImage(with: logoURL, placeholder: UIImage.fundPlaceholder)
        
        removeImageButton.isHidden = isPictureURL(url: urlString) ? false : true
    }
    
    @objc private func titleFieldDidChange() {
        guard let titleText = titleTextField.text, !titleText.isEmpty else {
            titleCountLabel.text = "0 / \(maxTitleLenght)"
            return }
        
        titleCountLabel.text = "\(titleText.count) / \(maxTitleLenght)"
        
        if titleText.count > maxTitleLenght {
            titleCountLabel.textColor = UIColor.Common.red
        } else {
            titleCountLabel.textColor = UIColor.Cell.title
        }
        
    }
    
    @IBAction func removeButtomAction(_ sender: Any) {
        logoImageView.image = nil
        removeImageButton.isHidden = true
        viewModel.pickedImageURL = nil
    }
    
    @IBAction func uploadLogoButtonAction(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func updatePublicInfoButtonAction(_ sender: Any) {
        guard let titleText = titleTextField.text,
            !titleText.isEmpty, !descriptionTextView.text.isEmpty else { return }
        
        viewModel.newTitle = titleText
        viewModel.newDescription = descriptionTextView.text
        
        showProgressHUD()
        viewModel.updateFund { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                self?.showSuccessHUD()
                self?.navigationController?.popViewController(animated: true)
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
}

extension FundEditPublicInfoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else {
            descriptionCountLabel.text = "0 / \(maxDescriptionLenght)"
            return }
        
        descriptionCountLabel.text = "\(textView.text.count) / \(maxDescriptionLenght)"
        
        if textView.text.count > maxDescriptionLenght {
            descriptionCountLabel.textColor = UIColor.Common.red
        } else {
            descriptionCountLabel.textColor = UIColor.Cell.title
        }
    }
}

extension FundEditPublicInfoViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        return uploadLogoButton
    }
    
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        guard let pickedImage = pickedImage, let pickedImageURL = pickedImageURL else { return }

        viewModel?.pickedImageURL = pickedImageURL
        
        logoImageView.image = pickedImage
        
        removeImageButton.isHidden = false
    }
}


final class FundEditPublicInfoViewModel {
    var title: String?
    var description: String?
    var assetId: String
    
    var newTitle: String?
    var newDescription: String?
    var newLogoImage: UIImage?
    //var pickedImage: UIImage?
    var pickedImageURL: URL?
    var uploadedImageUuid: String?
    
    var fundPublicInfo: AssetPublicDetails?
    var entryFeeCurrent: Double?
    var exitFeeCurrent: Double?
    
    init(assetId: String) {
        self.assetId = assetId
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        
        FundsDataProvider.get(self.assetId, currencyType: .usdt, completion: { (fundDetails) in
            if let fundDetails = fundDetails, let publicInfo = fundDetails.publicInfo {
                self.fundPublicInfo = publicInfo
            }
            completion(.success)
        }, errorCompletion: completion)
    }
    
    private func saveImage(_ pickedImageURL: URL, completion: @escaping (CompletionBlock)) {
        BaseDataProvider.uploadImage(imageData: pickedImageURL.dataRepresentation, imageLocation: .fundAsset, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedImageUuid = uuidString
            completion(.success)
            }, errorCompletion: completion)
    }
    
    func updateFund(completion: @escaping CompletionBlock) {
        if let pickedImageUrl = self.pickedImageURL {
            saveImage(pickedImageUrl) { [weak self] (result) in
                switch result {
                case .success:
                    self?.updatePublicInfo(completion: completion)
                case .failure(errorType: let errorType):
                    completion(.failure(errorType: errorType))
                }
            }
        } else {
            updatePublicInfo(completion: completion)
        }
    }
    
    private func updatePublicInfo(completion: @escaping CompletionBlock) {
        var imageLogo: String?
        
        if let uploadedImageUuid = uploadedImageUuid {
            imageLogo = uploadedImageUuid
        } else {
            imageLogo = fundPublicInfo?.logo
        }
        

        let model = ProgramUpdate(title: newTitle, _description: newDescription, logo: imageLogo, entryFee: entryFeeCurrent, exitFee: exitFeeCurrent, successFee: nil, stopOutLevel: nil, investmentLimit: nil, tradesDelay: nil, hourProcessing: nil, isProcessingRealTime: nil)
        AssetsDataProvider.updateFundAssetDetails(assetId, model: model, completion: completion)
    }
}
