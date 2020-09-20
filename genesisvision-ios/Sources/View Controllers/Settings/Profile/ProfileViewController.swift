//
//  ProfileViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ProfileViewController: BaseTableViewController, UINavigationControllerDelegate {
    // MARK: - View Model
    var viewModel: ProfileViewModel!
    
    private var saveBarButtonItem: UIBarButtonItem!
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: RoundedImageView! {
        didSet {
            profileImageView.borderSize = 2
        }
    }
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var usernameTextField: DesignableUITextField! {
        didSet {
            usernameTextField.delegate = self
            usernameTextField.designableTextFieldDelegate = self
        }
    }
    @IBOutlet weak var emailTextField: DesignableUITextField! {
        didSet {
            emailTextField.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var aboutTextView: UITextView! {
        didSet {
            aboutTextView.font = UIFont.getFont(.regular, size: 16)
            aboutTextView.textContainerInset = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: -6)
            aboutTextView.delegate = self
        }
    }
    
    // MARK: - Social links
    @IBOutlet weak var twitterTitleLabel: SubtitleLabel!
    @IBOutlet weak var telegramTitleLabel: SubtitleLabel!
    @IBOutlet weak var facebookTitleLabel: SubtitleLabel!
    @IBOutlet weak var linkedinTitleLabel: SubtitleLabel!
    @IBOutlet weak var youtubeTitleLabel: SubtitleLabel!
    @IBOutlet weak var wechatTitleLabel: SubtitleLabel!
    @IBOutlet weak var mailToTitleLabel: SubtitleLabel!
    
    @IBOutlet weak var twitterUrlLabel: SubtitleLabel!
    @IBOutlet weak var telegramUrlLabel: SubtitleLabel!
    @IBOutlet weak var facebookUrlLabel: SubtitleLabel!
    @IBOutlet weak var linkedinUrlLabel: SubtitleLabel!
    @IBOutlet weak var youtubeUrlLabel: SubtitleLabel!
    @IBOutlet weak var wechatUrlLabel: SubtitleLabel!
    @IBOutlet weak var mailToUrlLabel: SubtitleLabel!
    
    @IBOutlet weak var twitterTextField: DesignableUITextField! {
           didSet {
               twitterTextField.delegate = self
               twitterTextField.designableTextFieldDelegate = self
           }
       }
    @IBOutlet weak var telegramTextField: DesignableUITextField! {
           didSet {
               telegramTextField.delegate = self
               telegramTextField.designableTextFieldDelegate = self
           }
       }
    @IBOutlet weak var facebookTextField: DesignableUITextField! {
           didSet {
               facebookTextField.delegate = self
               facebookTextField.designableTextFieldDelegate = self
           }
       }
    @IBOutlet weak var linkedinTextField: DesignableUITextField! {
           didSet {
               linkedinTextField.delegate = self
               linkedinTextField.designableTextFieldDelegate = self
           }
       }
    @IBOutlet weak var youtubeTextField: DesignableUITextField! {
           didSet {
               youtubeTextField.delegate = self
               youtubeTextField.designableTextFieldDelegate = self
           }
       }
    @IBOutlet weak var wechatTextField: DesignableUITextField! {
           didSet {
               wechatTextField.delegate = self
               wechatTextField.designableTextFieldDelegate = self
           }
       }
    @IBOutlet weak var mailToTextField: DesignableUITextField! {
           didSet {
               mailToTextField.delegate = self
               mailToTextField.designableTextFieldDelegate = self
           }
       }
    
    @IBOutlet weak var twitterImageView: RoundedImageView!
    @IBOutlet weak var telegramImageView: RoundedImageView!
    @IBOutlet weak var facebookImageView: RoundedImageView!
    @IBOutlet weak var linkedinImageView: RoundedImageView!
    @IBOutlet weak var youtubeImageView: RoundedImageView!
    @IBOutlet weak var wechatImageView: RoundedImageView!
    @IBOutlet weak var mailToImageView: RoundedImageView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setupUI()
    }
    
    // MARK: - Private methods
    override func fetch() {
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    private func updateUI() {
        saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveMethod))
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        profileImageView.image = UIImage.profilePlaceholder
        if let url = viewModel.getAvatarURL() {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: url, placeholder: UIImage.profilePlaceholder)
        }
        
        if let email = viewModel.profileModel?.email {
            emailTextField.text = email
            emailTextField.textColor = UIColor.Common.lightGray
        } else {
            emailTextField.text = ""
        }
        
        if let userName = viewModel.profileModel?.userName {
            usernameTextField.text = userName
            title = userName
        } else {
            usernameTextField.text = ""
        }
        
        if let about = viewModel.profileModel?.about {
            aboutTextView.text = about
        } else {
            aboutTextView.text = ""
        }
        
        setupSocialLinks()
    }
    
    private func setupSocialLinks() {
        if let socialLinks = viewModel.socialLinksViewModel?.socialLinks {
            socialLinks.forEach { (viewModel) in
                guard let name = viewModel.name, let type = viewModel.type else { return }
                let value = viewModel.value ?? ""

                switch type {
                case .twitter:
                    twitterTitleLabel.text = name
                    if let url = viewModel.url {
                        twitterUrlLabel.text = url
                    } else {
                        twitterUrlLabel.isHidden = true
                    }
                    twitterTextField.text = value
                    if let logo = viewModel.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                        twitterImageView.kf.indicatorType = .activity
                        twitterImageView.kf.setImage(with: fileUrl)
                    }
                case .telegram:
                    telegramTitleLabel.text = name
                    if let url = viewModel.url {
                        telegramUrlLabel.text = url
                    } else {
                        telegramUrlLabel.isHidden = true
                    }
                    telegramTextField.text = value
                    if let logo = viewModel.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                        telegramImageView.kf.indicatorType = .activity
                        telegramImageView.kf.setImage(with: fileUrl)
                    }
                case .facebook:
                    facebookTitleLabel.text = name
                    if let url = viewModel.url {
                        facebookUrlLabel.text = url
                    } else {
                        facebookUrlLabel.isHidden = true
                    }
                    facebookTextField.text = value
                    if let logo = viewModel.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                        facebookImageView.kf.indicatorType = .activity
                        facebookImageView.kf.setImage(with: fileUrl)
                    }
                case .linkedIn:
                    linkedinTitleLabel.text = name
                    if let url = viewModel.url {
                        linkedinUrlLabel.text = url
                    } else {
                        linkedinUrlLabel.isHidden = true
                    }
                    linkedinTextField.text = value
                    if let logo = viewModel.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                        linkedinImageView.kf.indicatorType = .activity
                        linkedinImageView.kf.setImage(with: fileUrl)
                    }
                case .youtube:
                    youtubeTitleLabel.text = name
                    if let url = viewModel.url {
                        youtubeUrlLabel.text = url
                    } else {
                        youtubeUrlLabel.isHidden = true
                    }
                    youtubeTextField.text = value
                    if let logo = viewModel.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                        youtubeImageView.kf.indicatorType = .activity
                        youtubeImageView.kf.setImage(with: fileUrl)
                    }
                case .weChat:
                    wechatTitleLabel.text = name
                    if let url = viewModel.url {
                        wechatUrlLabel.text = url
                    } else {
                        wechatUrlLabel.isHidden = true
                    }
                    wechatTextField.text = value
                    if let logo = viewModel.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                        wechatImageView.kf.indicatorType = .activity
                        wechatImageView.kf.setImage(with: fileUrl)
                    }
                case .email:
                    mailToTitleLabel.text = name
                    if let url = viewModel.url {
                        mailToUrlLabel.text = url
                    } else {
                        mailToUrlLabel.isHidden = true
                    }
                    mailToTextField.text = value
                    if let logo = viewModel.logoUrl, let fileUrl = getFileURL(fileName: logo) {
                        mailToImageView.kf.indicatorType = .activity
                        mailToImageView.kf.setImage(with: fileUrl)
                    }
                default:
                    break
                }
            }
        }
    }
    
    @objc func saveMethod() {
        view.endEditing(true)
        
        showProgressHUD()
        viewModel.save { [weak self] (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.showSuccessHUD()
                    self?.fetch()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    private func setup() {
        showProgressHUD()
        fetch()
        setupUI()
        setupPullToRefresh(scrollView: tableView)
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        
        showInfiniteIndicator(value: false)
        tableView.backgroundColor = UIColor.BaseView.bg
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        tableView.registerHeaderNib(for: viewModel.viewModelsForRegistration)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    @IBAction func changePhotoButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        
        showImagePicker()
    }
}

extension ProfileViewController {
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowType = viewModel.rowType(at: indexPath)
        switch rowType {
        case .avatar:
            return 220
        case .about:
            return 128
        default:
            return 72
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else { return nil }

        guard let title = viewModel.headerTitle(for: section) else {
            return nil
        }
        
        let header = DefaultTableHeaderView.viewFromNib()
        header.headerBackgroundView.backgroundColor = UIColor.Cell.headerBg
        header.headerLabel.text = title
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}

extension ProfileViewController: ImagePickerPresentable {
    var choosePhotoButton: UIButton {
        return changePhotoButton
    }
    
    func selected(pickedImage: UIImage?, pickedImageURL: URL?) {
        viewModel.pickedImage = pickedImage
        viewModel.pickedImageURL = pickedImageURL
        
        let oldImage = profileImageView.image
        showProgressHUD()
        viewModel.saveProfilePhoto { [weak self] (result) in
            self?.hideAll()
            DispatchQueue.main.async {
                self?.profileImageView.image = nil
            }

            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.profileImageView.image = pickedImage
                }
            case .failure(let errorType):
                print(errorType)
                DispatchQueue.main.async {
                    self?.profileImageView.image = oldImage ?? UIImage.profilePlaceholder
                }
            }
        }
    }
}
extension ProfileViewController: UITextFieldDelegate, DesignableUITextFieldDelegate {
    func textFieldDidClear(_ textField: UITextField) {
        let text = ""
        switch textField {
        case usernameTextField:
            viewModel.username = text
        case twitterTextField:
            viewModel.socialLinks[.twitter] = text
        case telegramTextField:
            viewModel.socialLinks[.telegram] = text
        case facebookTextField:
            viewModel.socialLinks[.facebook] = text
        case linkedinTextField:
            viewModel.socialLinks[.linkedIn] = text
        case youtubeTextField:
            viewModel.socialLinks[.youtube] = text
        case wechatTextField:
            viewModel.socialLinks[.weChat] = text
        case mailToTextField:
            viewModel.socialLinks[.email] = text
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text
        switch textField {
        case usernameTextField:
            viewModel.username = text
        case twitterTextField:
            viewModel.socialLinks[.twitter] = text
        case telegramTextField:
            viewModel.socialLinks[.telegram] = text
        case facebookTextField:
            viewModel.socialLinks[.facebook] = text
        case linkedinTextField:
            viewModel.socialLinks[.linkedIn] = text
        case youtubeTextField:
            viewModel.socialLinks[.youtube] = text
        case wechatTextField:
            viewModel.socialLinks[.weChat] = text
        case mailToTextField:
            viewModel.socialLinks[.email] = text
        default:
            break
        }
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.about = textView.text
    }
}
