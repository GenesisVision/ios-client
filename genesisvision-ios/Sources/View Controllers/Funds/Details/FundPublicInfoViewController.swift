//
//  FundEditPublicInfoViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 25.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class FundPublicInfoViewController: BaseViewController {
    
    var viewModel: FundPublicInfoViewModel!
    
    @IBOutlet weak var titleTextField: DesignableUITextField! {
        didSet {
            titleTextField.addTarget(self, action: #selector(titleFieldDidChange), for: .editingChanged)
            titleTextField.addTarget(self, action: #selector(titleFieldEndEditing), for: .editingDidEnd)
        }
    }
    
    @IBOutlet weak var titleUnderLabel: SubtitleLabel!
    
    @IBOutlet weak var titleCountLabel: TitleLabel! {
        didSet {
            titleCountLabel.text = "0 / \(maxTitleLenght)"
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.delegate = self
            descriptionTextView.tintColor = UIColor.primary
        }
    }
    
    @IBOutlet weak var descriptionTextViewUnderLabel: SubtitleLabel!
    
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
    
    @IBOutlet weak var updateInfoButton: ActionButton! {
        didSet {
            updateInfoButton.setEnabled(false)
        }
    }
    
    @IBOutlet weak var removeImageButton: UIButton!
    
    private let minTitleLenght = 4
    private let maxTitleLenght = 20
    private let minDescriptionLenght = 20
    private let maxDescriptionLenght =  500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Public Info"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fundMode == .create ? setupCreateMode() : setupEditMode()
    }
    
    private func setupCreateMode() {
        updateInfoButton.setTitle("Next", for: .normal)
        removeImageButton.isHidden = true
    }
    
    private func setupEditMode() {
        title = "Public Info"
        updateInfoButton.setTitle("Update public info", for: .normal)
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
        if let titleText = viewModel.fundPublicInfo?.title {
            titleTextField.text = titleText
            titleCountLabel.text = "\(titleText.count) / \(maxTitleLenght)"
        }
        
        if let descriptionText = viewModel.fundPublicInfo?._description {
            descriptionTextView.text = descriptionText
            descriptionCountLabel.text = "\(descriptionText.count) / \(maxDescriptionLenght)"
        }
        
        if let urlString = viewModel.fundPublicInfo?.logoUrl, let logoURL = getFileURL(fileName: urlString) {
            logoImageView.kf.setImage(with: logoURL, placeholder: UIImage.fundPlaceholder)
            removeImageButton.isHidden = false
        } else {
            removeImageButton.isHidden = true
        }
    }
    
    @objc private func titleFieldDidChange() {
        guard let titleText = titleTextField.text, !titleText.isEmpty else {
            titleCountLabel.text = "0 / \(maxTitleLenght)"
            checkActionButton()
            return }
        
        titleCountLabel.text = "\(titleText.count) / \(maxTitleLenght)"
        
        if titleText.count >= minTitleLenght {
            titleUnderLabel.textColor = UIColor.Cell.subtitle
        }
        
        if titleText.count > maxTitleLenght {
            titleCountLabel.textColor = UIColor.Common.red
        } else {
            titleCountLabel.textColor = UIColor.Cell.title
        }
        checkActionButton()
    }
    
    @objc private func titleFieldEndEditing() {
        guard let titleText = titleTextField.text, titleText.count >= minTitleLenght else {
            titleUnderLabel.textColor = UIColor.Common.red
            return
        }
    }
    
    private func checkActionButton() {
        guard let titleText = titleTextField.text, titleText.count >= minTitleLenght, titleText.count <= maxTitleLenght, descriptionTextView.text.count >= minDescriptionLenght, descriptionTextView.text.count <= maxDescriptionLenght else {
            updateInfoButton.setEnabled(false)
            return
        }
        updateInfoButton.setEnabled(true)
    }
    
    @IBAction func removeButtomAction(_ sender: Any) {
        logoImageView.image = nil
        removeImageButton.isHidden = true
        viewModel.pickedImageURL = nil
        checkActionButton()
    }
    
    @IBAction func uploadLogoButtonAction(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func updatePublicInfoButtonAction(_ sender: Any) {
        viewModel.fundMode == .create ? createFundPublicInfo() : updateFundPublicInfo()
    }
    
    private func updateFundPublicInfo() {
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
    
    private func createFundPublicInfo() {
        guard let titleText = titleTextField.text,
            !titleText.isEmpty, !descriptionTextView.text.isEmpty else { return }
        
        let viewModel = CreateNewFundViewModel()
        viewModel.description = descriptionTextView.text
        viewModel.title = titleText
        viewModel.pickedImageURL = self.viewModel.pickedImageURL
        
        guard let viewController = FundReallocationViewController.storyboardInstance(.fund) else { return }
        viewController.viewModel = FundReallocationViewModel(with: nil)
        viewController.viewModel.createViewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FundPublicInfoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else {
            descriptionCountLabel.text = "0 / \(maxDescriptionLenght)"
            checkActionButton()
            return }
        
        descriptionCountLabel.text = "\(textView.text.count) / \(maxDescriptionLenght)"
        
        if textView.text.count >= minDescriptionLenght {
            descriptionTextViewUnderLabel.textColor = UIColor.Cell.subtitle
        }
        
        if textView.text.count > maxDescriptionLenght {
            descriptionCountLabel.textColor = UIColor.Common.red
        } else {
            descriptionCountLabel.textColor = UIColor.Cell.title
        }
        
        checkActionButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.count >= minDescriptionLenght else {
            descriptionTextViewUnderLabel.textColor = UIColor.Common.red
            return
        }
    }
}

extension FundPublicInfoViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        return uploadLogoButton
    }
    
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        guard let pickedImage = pickedImage, let pickedImageURL = pickedImageURL else { return }

        viewModel?.pickedImageURL = pickedImageURL
        
        logoImageView.image = pickedImage
        
        removeImageButton.isHidden = false
        
        checkActionButton()
        
    }
}


final class FundPublicInfoViewModel {
    var title: String?
    var description: String?
    var assetId: String?
    
    var newTitle: String?
    var newDescription: String?
    var newLogoImage: UIImage?
    var pickedImageURL: URL?
    var uploadedImageUuid: String?
    
    var fundPublicInfo: AssetPublicDetails?
    var entryFeeCurrent: Double?
    var exitFeeCurrent: Double?
    
    enum FundPublicInfoMode {
        case create
        case edit
    }
    
    var fundMode: FundPublicInfoMode = .create
    
    init(mode: FundPublicInfoMode, assetId: String? = nil) {
        if mode == .edit, let assetId = assetId {
            self.fundMode = mode
            self.assetId = assetId
        } else {
            self.fundMode = mode
        }
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        guard let assetId = self.assetId else { return completion(.failure(errorType: .apiError(message: nil))) }
        FundsDataProvider.get(assetId, currencyType: .usdt, completion: { (fundDetails) in
            if let fundDetails = fundDetails, let publicInfo = fundDetails.publicInfo {
                self.fundPublicInfo = publicInfo
            }
            completion(.success)
        }, errorCompletion: completion)
    }
    
    private func saveImage(completion: @escaping (CompletionBlock)) {
        guard let pickedImageURL = pickedImageURL else { return completion(.failure(errorType: .apiError(message: ""))) }
        BaseDataProvider.uploadImage(imageData: pickedImageURL.dataRepresentation, imageLocation: .fundAsset, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedImageUuid = uuidString
            completion(.success)
            }, errorCompletion: completion)
    }
    
    func updateFund(completion: @escaping CompletionBlock) {
        if let _ = pickedImageURL {
            saveImage() { [weak self] (result) in
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
        guard let assetId = assetId else { return completion(.failure(errorType: .apiError(message: nil))) }
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

final class CreateNewFundViewModel {
    var title: String?
    var description: String?
    var pickedImageURL: URL?
    var fundAssets: [FundAssetPart]?
    var exitFee: Double?
    var entryFee: Double?
}
