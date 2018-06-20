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
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    
    @IBOutlet weak var passcodeSwitch: UISwitch!
    @IBOutlet weak var biometricIDTitleLabel: UILabel!
    @IBOutlet weak var biometricIDSwitch: UISwitch! {
        didSet {
            biometricIDSwitch.isEnabled = false
        }
    }
    @IBOutlet weak var twoFactorSwitch: UISwitch!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var termsLinkButton: UIButton!
    @IBOutlet weak var privacyLinkButton: UIButton!
    
    @IBOutlet weak var footerView: UITableViewHeaderFooterView!
    
    // MARK: - Cells
    @IBOutlet weak var changePasswordCell: PlateTableViewCell!
    @IBOutlet weak var passcodeCell: PlateTableViewCell!
    @IBOutlet weak var biometricCell: PlateTableViewCell!
    @IBOutlet weak var twoFactorCell: PlateTableViewCell!
    
    // MARK: - Variables
    var passcodeEnable: Bool = false {
        didSet {
            passcodeSwitch.isOn = passcodeEnable
        }
    }
    
    var biometricIDEnable: Bool = false {
        didSet {
            biometricIDSwitch.isOn = biometricIDEnable
        }
    }
    
    var twoFactorEnable: Bool = false {
        didSet {
            twoFactorSwitch.isOn = twoFactorEnable
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSecurity()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .twoFactorChange, object: nil)
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
                    self?.twoFactorEnable = twoFactorEnabled
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    @objc private func twoFactorChangeNotification(notification: Notification) {
        if let enable = notification.userInfo?["enable"] as? Bool {
            twoFactorEnable = enable
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setup() {
        fetch()
        setupUI()
        setupPullToRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(twoFactorChangeNotification(notification:)), name: .twoFactorChange, object: nil)
    }
    
    private func setupUI() {
        title = viewModel.title.uppercased()
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
    }
    
    private func setupSecurity() {
        passcodeSwitch.isOn = viewModel.enablePasscode
        biometricIDSwitch.isEnabled = viewModel.enablePasscode
        biometricIDSwitch.isOn = viewModel.enableBiometricID
        twoFactorSwitch.isOn = viewModel.enableTwoFactor
        
        biometricIDTitleLabel.text = UIDevice().type == .iPhoneX ? "Face ID" : "Touch ID"
        biometricCell.isHidden = !(AuthManager.isTouchAuthenticationAvailable && viewModel.enablePasscode)
        if let indexPath = tableView.indexPath(for: biometricCell) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private func setupTableConfiguration() {
        tableView.configure(with: .defaultConfiguration)
        
        setupPullToRefresh()
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
            return AuthManager.isTouchAuthenticationAvailable && viewModel.enablePasscode ? 50.0 : 0.0
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
