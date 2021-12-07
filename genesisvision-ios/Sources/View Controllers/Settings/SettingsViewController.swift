//
//  SettingsViewController.swift
//  genesisvision-ios
//
//  Created by George on 13/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SettingsViewController: BaseTableViewController {
    // MARK: - View Model
    var viewModel: SettingsViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var profileNameLabel: TitleLabel! {
        didSet {
            profileNameLabel.font = UIFont.getFont(.semibold, size: 17)
        }
    }
    
    @IBOutlet weak var profileEmailLabel: SubtitleLabel!
    
    @IBOutlet weak var kycStatusButton: UIButton! {
        didSet {
            kycStatusButton.isHidden = true
            kycStatusButton.backgroundColor = UIColor.Cell.redTitle.withAlphaComponent(0.1)
            kycStatusButton.tintColor = UIColor.Cell.redTitle
            kycStatusButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet weak var verifyView: UIView! {
        didSet {
            verifyView.isHidden = true
            verifyView.backgroundColor = UIColor.Cell.redTitle.withAlphaComponent(0.1)
        }
    }
    
    @IBOutlet weak var verifyTextLabel: TitleLabel! {
        didSet {
            verifyTextLabel.font = UIFont.getFont(.regular, size: 14.0)
            verifyTextLabel.textColor = UIColor.Cell.redTitle
        }
    }
    
    @IBOutlet weak var platformCurrencyTitleLabel: TitleLabel! {
        didSet {
            platformCurrencyTitleLabel.text = "Platform currency"
            platformCurrencyTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var platformCurrencyValueLabel: SubtitleLabel! {
        didSet {
            platformCurrencyValueLabel.text = ""
        }
    }
    @IBOutlet weak var changePasswordTitleLabel: TitleLabel! {
        didSet {
            changePasswordTitleLabel.text = SettingsViewModel.RowType.changePassword.rawValue
            changePasswordTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var publicProfileSwitch: UISwitch! {
        didSet {
            publicProfileSwitch.onTintColor = UIColor.primary
            publicProfileSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            publicProfileSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var passcodeSwitch: UISwitch! {
        didSet {
            passcodeSwitch.onTintColor = UIColor.primary
            passcodeSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            passcodeSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var passcodeTitleLabel: TitleLabel! {
        didSet {
            passcodeTitleLabel.text = SettingsViewModel.RowType.passcode.rawValue
            passcodeTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var biometricIDTitleLabel: TitleLabel! {
        didSet {
            biometricIDTitleLabel.text = SettingsViewModel.RowType.biometricID.rawValue
            biometricIDTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var biometricIDSwitch: UISwitch! {
        didSet {
            biometricIDSwitch.isEnabled = false
            biometricIDSwitch.onTintColor = UIColor.primary
            biometricIDSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            biometricIDSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var twoFactorSwitch: UISwitch! {
        didSet {
            twoFactorSwitch.onTintColor = UIColor.primary
            twoFactorSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            twoFactorSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var twoFactorTitleLabel: TitleLabel! {
        didSet {
            twoFactorTitleLabel.text = SettingsViewModel.RowType.twoFactor.rawValue
            twoFactorTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var termsTitleLabel: TitleLabel! {
        didSet {
            termsTitleLabel.text = SettingsViewModel.RowType.termsAndConditions.rawValue
            termsTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var privacyTitleLabel: TitleLabel! {
        didSet {
            privacyTitleLabel.text = SettingsViewModel.RowType.privacyPolicy.rawValue
            privacyTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var sendFeedbackTitleLabel: TitleLabel! {
        didSet {
            sendFeedbackTitleLabel.text = SettingsViewModel.RowType.contactUs.rawValue
            sendFeedbackTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var versionLabel: SubtitleLabel! {
        didSet {
            versionLabel.text = ""
        }
    }
    @IBOutlet weak var footerView: UITableViewHeaderFooterView!
    
    private var signOutBarButtonItem: UIBarButtonItem!
    
    // MARK: - Cells
    @IBOutlet weak var kycStatusCell: TableViewCell!
    
    @IBOutlet weak var mySocialProfileCell: TableViewCell!
    @IBOutlet weak var profilePrivacyCell: TableViewCell!
    
    @IBOutlet weak var publicProfileCell: TableViewCell! {
        didSet {
            publicProfileCell.isHidden = true
        }
    }
    @IBOutlet weak var currencyCell: TableViewCell!
    
    @IBOutlet weak var changePasswordCell: TableViewCell!
    
    @IBOutlet weak var profileCell: TableViewCell!
    
    @IBOutlet weak var passcodeCell: TableViewCell!
    @IBOutlet weak var biometricCell: TableViewCell!
    @IBOutlet weak var twoFactorCell: TableViewCell!
    
    @IBOutlet weak var termsCell: TableViewCell!
    @IBOutlet weak var privacyCell: TableViewCell!
    @IBOutlet weak var contactUsCell: TableViewCell!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetch()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .twoFactorChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func setupSecurity() {
        passcodeSwitch.isOn = viewModel.enablePasscode
        biometricIDSwitch.isEnabled = viewModel.enablePasscode
        biometricIDSwitch.isOn = viewModel.enableBiometricID
        twoFactorSwitch.isOn = viewModel.enableTwoFactor
        
        biometricIDTitleLabel.text = viewModel.biometricTitleText
        biometricCell.isHidden = !viewModel.enableBiometricCell
        
        if let indexPath = tableView.indexPath(for: biometricCell) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // MARK: - Private methods
    override func fetch() {
        viewModel.fetchProfile { [weak self] (result) in
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
        
        viewModel.fetchTwoFactorStatus { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                DispatchQueue.main.async {
                    guard let twoFactorEnabled = self?.viewModel.enableTwoFactor else { return }
                    self?.twoFactorSwitch.isOn = twoFactorEnabled
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    private func updateUI() {
        profileImageView.image = UIImage.profilePlaceholder
        publicProfileSwitch.isOn = viewModel.isPublic
        
        if let verificationStatus = viewModel.verificationStatus {
            kycStatusButton.isHidden = false
            switch verificationStatus {
            case .rejected:
                kycStatusButton.setTitle("Rejected", for: .normal)
                kycStatusButton.tintColor = UIColor.Cell.redTitle
                kycStatusButton.backgroundColor = UIColor.Cell.redTitle.withAlphaComponent(0.1)
            case .verified:
                kycStatusButton.setTitle("Verified", for: .normal)
                kycStatusButton.tintColor = UIColor.Cell.greenTitle
                kycStatusButton.backgroundColor = UIColor.Cell.greenTitle.withAlphaComponent(0.1)
            case .notVerified:
                kycStatusButton.setTitle("Not verified", for: .normal)
                kycStatusButton.tintColor = UIColor.Cell.redTitle
                kycStatusButton.backgroundColor = UIColor.Cell.redTitle.withAlphaComponent(0.1)
            case .underReview:
                kycStatusButton.setTitle("Under Review", for: .normal)
                kycStatusButton.tintColor = UIColor.Cell.yellowTitle
                kycStatusButton.backgroundColor = UIColor.Cell.yellowTitle.withAlphaComponent(0.1)
            }
        }
            
        if let url = viewModel.avatarURL {
            profileImageView.kf.indicatorType = .activity
            profileImageView.kf.setImage(with: url, placeholder: UIImage.profilePlaceholder)
        }
        
        if let username = viewModel.username {
            profileNameLabel.text = username
        } else {
            profileNameLabel.text = "Profile"
        }
        
        if viewModel.currencyListViewModel != nil, let name = viewModel.currencyListViewModel.selected()?.name {
            platformCurrencyValueLabel.text = name
        }
        
        if versionLabel != nil {
            versionLabel.text = "App version " + getFullVersion()
        }
        
        profileEmailLabel.text = viewModel.email
        tableView?.reloadDataSmoothly()
    }
    
    @objc private func twoFactorChangeNotification(notification: Notification) {
        if let enable = notification.userInfo?["enable"] as? Bool {
            viewModel.enableTwoFactor = enable
        }
    }
    
    @objc func applicationDidBecomeActive(notification: Notification) {
        setupSecurity()
    }
    
    private func setup() {
        showProgressHUD()
        fetch()
        setupPullToRefresh(scrollView: tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(twoFactorChangeNotification(notification:)), name: .twoFactorChange, object: nil)
    }
    
    private func setupUI() {
        setupSecurity()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        
        signOutBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_profile_logout"), style: .done, target: self, action: #selector(signOutMethod))
        navigationItem.rightBarButtonItem = signOutBarButtonItem

        
        showInfiniteIndicator(value: false)
        
        tableView.tableFooterView = footerView
        tableView.backgroundColor = UIColor.Cell.headerBg
        
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }

    @objc private func signOutMethod() {
        showAlertWithTitle(title: String.Alerts.SignOut.title, message: String.Alerts.SignOut.message, actionTitle: String.Alerts.SignOut.confirm, cancelTitle: String.Alerts.cancelButtonText, handler: { [weak self] in
            self?.viewModel.signOut()
            }, cancelHandler: nil)
    }
    
    private func feedbackMethod() {
        let alert = UIAlertController(title: "", message: String.Alerts.Feedback.alertTitle, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: String.Alerts.Feedback.websiteButtonText, style: .default, handler: { [weak self] (action) in
            self?.viewModel.sendFeedback()
        }))
        
        alert.addAction(UIAlertAction(title: String.Alerts.Feedback.emailButtonText, style: .default, handler: { [weak self] (action) in
            self?.sendEmailFeedback()
        }))
        
        alert.addAction(UIAlertAction(title: String.Alerts.cancelButtonText, style: .cancel, handler:nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func changePlatformCurrency() {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()

        bottomSheetController.addNavigationBar(viewModel.currencyListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.currencyListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.currencyListDataSource
            tableView.dataSource = viewModel.currencyListDataSource
            tableView.reloadDataSmoothly()
        }

        bottomSheetController.present()
    }
    
    // MARK: - Actions
    @IBAction func passcodeSwitchChangedAction(_ sender: UISwitch) {
        viewModel.enablePasscode(sender.isOn)
    }
    
    @IBAction func publicProfileSwitchChangedAction(_ sender: UISwitch) {
        showProgressHUD()
        viewModel.publicChange(sender.isOn) { [weak self] (result) in
            self?.hideAll()
        }
    }
    
    @IBAction func biometricIDSwitchChangedAction(_ sender: UISwitch) {
        viewModel.enableBiometricID(sender.isOn)
    }
    
    @IBAction func twoFactorSwitchChangedAction(_ sender: UISwitch) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.viewModel.enableTwoFactor(sender.isOn)
        })
    }
    
    @IBAction func kycStatusButtonAction(_ sender: Any) {
        guard viewModel.verificationStatus != .verified, let token = viewModel.kycVerificationTokens?.accessToken, let baseUrl = viewModel.kycVerificationTokens?.baseAddress, let flowName = viewModel.kycVerificationTokens?.flowName, let _ = PlatformManager.shared.getKYCViewController(token: token, baseUrl: baseUrl, flowName: flowName) else { return }
        
        viewModel.showKYC()
    }
    
}

extension SettingsViewController {
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let fieldType = viewModel.rowType(at: indexPath) else {
            return
        }
        
        switch fieldType {
        case .profile:
            viewModel.showProfile()
        case .privacy:
            viewModel.showProfilePrivacy()
        case .currency:
            changePlatformCurrency()
        case .changePassword:
            viewModel.changePassword()
        case .termsAndConditions:
            viewModel.showTerms()
        case .privacyPolicy:
            viewModel.showPrivacy()
        case .contactUs:
            feedbackMethod()
        case .referralProgram:
            viewModel.showReferral()
        case .socialProfile:
            viewModel.showSocialProfile()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let fieldType = viewModel.rowType(at: indexPath) else {
            return UITableView.automaticDimension
        }
        
        switch fieldType {
        case .publicProfile:
            return publicProfileCell.isHidden ? 0.0 : 60.0
        case .profile:
            return UITableView.automaticDimension
        case .biometricID:
            return viewModel.enableBiometricCell ? 60.0 : 0.0
        default:
            return 60.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerHeight(for: section)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.Cell.headerBg
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let rowType = viewModel.rowType(at: indexPath) {
            switch rowType {
            case .changePassword, .termsAndConditions, .privacyPolicy, .contactUs:
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.contentView.backgroundColor = UIColor.Cell.subtitle.withAlphaComponent(0.3)
                }
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.BaseView.bg
        }
    }
}

extension SettingsViewController: PasscodeProtocol {
    func passcodeAction(_ action: PasscodeActionType) {
        switch action {
        case .enabled:
            viewModel.enablePasscode = true
        case .disabled:
            viewModel.enablePasscode = false
        default:
            break
        }
        
        setupSecurity()
    }
}

extension SettingsViewController: BaseTableViewProtocol {
    func didSelect(_ type: DidSelectType, index: Int) {
        switch type {
        case .currency:
            bottomSheetController.dismiss()
            if let name = viewModel.currencyListViewModel.selected()?.name {
                selectedPlatformCurrency = name
                platformCurrencyValueLabel.text = name
            }
        default:
            break
        }
    }
    
    func didReload(_ indexPath: IndexPath) {
        
    }
}
