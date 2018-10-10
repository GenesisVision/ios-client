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
    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var profileNameLabel: UILabel! {
        didSet {
            profileNameLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var profileEmailLabel: UILabel! {
        didSet {
            profileEmailLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet weak var changePasswordTitleLabel: UILabel! {
        didSet {
            changePasswordTitleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet weak var passcodeSwitch: UISwitch!
    @IBOutlet weak var passcodeTitleLabel: UILabel! {
        didSet {
            passcodeTitleLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var biometricIDTitleLabel: UILabel! {
        didSet {
            biometricIDTitleLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var biometricIDSwitch: UISwitch! {
        didSet {
            biometricIDSwitch.isEnabled = false
        }
    }
    @IBOutlet weak var twoFactorSwitch: UISwitch!
    @IBOutlet weak var twoFactorTitleLabel: UILabel! {
        didSet {
            twoFactorTitleLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    @IBOutlet weak var darkThemeTitleLabel: UILabel! {
        didSet {
            darkThemeTitleLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var sendFeedbackTitleLabel: UILabel! {
        didSet {
            sendFeedbackTitleLabel.textColor = UIColor.Cell.title
        }
    }
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var termsLinkButton: UIButton! {
        didSet {
            termsLinkButton.setTitleColor(UIColor.Cell.title, for: .normal)
        }
    }
    @IBOutlet weak var privacyLinkButton: UIButton! {
        didSet {
            privacyLinkButton.setTitleColor(UIColor.Cell.title, for: .normal)
        }
    }
    
    @IBOutlet weak var footerView: UITableViewHeaderFooterView!
    
    // MARK: - Cells
    @IBOutlet weak var changePasswordCell: PlateTableViewCell!
    @IBOutlet weak var passcodeCell: PlateTableViewCell!
    @IBOutlet weak var biometricCell: PlateTableViewCell!
    @IBOutlet weak var twoFactorCell: PlateTableViewCell!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSecurity()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: .UIApplicationDidBecomeActive, object: nil)
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .twoFactorChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    func setupSecurity() {
        passcodeSwitch.isOn = viewModel.enablePasscode
        biometricIDSwitch.isEnabled = viewModel.enablePasscode
        biometricIDSwitch.isOn = viewModel.enableBiometricID
        twoFactorSwitch.isOn = viewModel.enableTwoFactor
        darkThemeSwitch.isOn = viewModel.enableDarkTheme
        
        biometricIDTitleLabel.text = viewModel.biometricTitleText
        biometricCell.isHidden = !viewModel.enableBiometricCell
        if let indexPath = tableView.indexPath(for: biometricCell) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // MARK: - Private methods
    override func fetch() {
        viewModel.fetchProfile { [weak self] (result) in
            DispatchQueue.main.async {
                self?.hideAll()
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.profileImageView.image = UIImage.placeholder
                        
                        if let url = self?.viewModel.avatarURL {
                            self?.profileImageView.kf.indicatorType = .activity
                            self?.profileImageView.kf.setImage(with: url, placeholder: UIImage.placeholder)
                        }
                        
                        if let name = self?.viewModel.fullName {
                            self?.profileNameLabel.isHidden = false
                            self?.profileNameLabel.text = name
                        } else {
                            self?.profileNameLabel.isHidden = true
                        }
                        
                        self?.profileEmailLabel.text = self?.viewModel.email
                        self?.reloadData()
                    }
                case .failure(let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self)
                }
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
    
    @objc private func twoFactorChangeNotification(notification: Notification) {
        if let enable = notification.userInfo?["enable"] as? Bool {
            viewModel.enableTwoFactor = enable
        }
    }
    
    @objc func applicationDidBecomeActive(notification: Notification) {
        setupSecurity()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    private func setup() {
        fetch()
        setupUI()
        setupPullToRefresh(scrollView: tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(twoFactorChangeNotification(notification:)), name: .twoFactorChange, object: nil)
    }
    
    private func setupUI() {
        navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion())
        
        versionLabel.text = "App version " + getFullVersion()
        
        showInfiniteIndicator(value: false)
        
        changePasswordCell.roundType = .top
        changePasswordCell.shouldHaveVerticalMargin = false
        
        passcodeCell.roundType = .none
        passcodeCell.shouldHaveVerticalMargin = false
        passcodeCell.highlighting = false
        
        biometricCell.roundType = .none
        biometricCell.shouldHaveVerticalMargin = false
        biometricCell.highlighting = false
        
        twoFactorCell.roundType = .bottom
        twoFactorCell.shouldHaveVerticalMargin = false
        twoFactorCell.highlighting = false
        
        tableView.tableFooterView = footerView
        
        profileNameLabel.textColor = UIColor.Cell.title
        profileEmailLabel.textColor = UIColor.Cell.title
        changePasswordTitleLabel.textColor = UIColor.Cell.title
        passcodeTitleLabel.textColor = UIColor.Cell.title
        biometricIDTitleLabel.textColor = UIColor.Cell.title
        twoFactorTitleLabel.textColor = UIColor.Cell.title
        darkThemeTitleLabel.textColor = UIColor.Cell.title
        sendFeedbackTitleLabel.textColor = UIColor.Cell.title
        termsLinkButton.setTitleColor(UIColor.Cell.title, for: .normal)
        privacyLinkButton.setTitleColor(UIColor.Cell.title, for: .normal)
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }

    private func signOutMethod() {
        showAlertWithTitle(title: nil, message: "Log out?", actionTitle: "Yes", cancelTitle: "Cancel", handler: { [weak self] in
            self?.viewModel.signOut()
            }, cancelHandler: nil)
    }
    
    private func feedbackMethod() {
        let alert = UIAlertController(title: "", message: String.Alerts.Feedback.alertTitle, preferredStyle: .alert)
        alert.view.tintColor = UIColor.primary
        
        alert.addAction(UIAlertAction(title: String.Alerts.Feedback.websiteButtonText, style: .default, handler: { [weak self] (action) in
            self?.viewModel.sendFeedback()
        }))
        
        alert.addAction(UIAlertAction(title: String.Alerts.Feedback.emailButtonText, style: .default, handler: { [weak self] (action) in
            self?.sendEmailFeedback()
        }))
        
        alert.addAction(UIAlertAction(title: String.Alerts.cancelButtonText, style: .cancel, handler:nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func passcodeSwitchChangedAction(_ sender: UISwitch) {
        viewModel.enablePasscode(sender.isOn)
    }
    
    @IBAction func biometricIDSwitchChangedAction(_ sender: UISwitch) {
        viewModel.enableBiometricID(sender.isOn)
    }
    
    @IBAction func twoFactorSwitchChangedAction(_ sender: UISwitch) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.viewModel.enableTwoFactor(sender.isOn)
        })
    }
    
    @IBAction func darkThemeSwitchChangedAction(_ sender: UISwitch) {
        viewModel.enableDarkTheme(sender.isOn)
        updateTheme()
        reloadData()
        setupUI()
    }
    
    @IBAction func termsLinkButtonAction(_ sender: UIButton) {
        viewModel.showTerms()
    }
    
    @IBAction func privacyLinkButtonAction(_ sender: UIButton) {
        viewModel.showPrivacy()
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
        case .changePassword:
            viewModel.changePassword()
        case .sendFeedback:
            feedbackMethod()
        case .signOut:
            signOutMethod()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let fieldType = viewModel.rowType(at: indexPath) else {
            return UITableViewAutomaticDimension
        }
        
        switch fieldType {
        case .profile:
            return UITableViewAutomaticDimension
        case .biometricID:
            return viewModel.enableBiometricCell ? 50.0 : 0.0
        default:
            return 50.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
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
