//
//  AuthTwoFactorSignInViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class AuthTwoFactorSignInViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: AuthTwoFactorSignInViewModel!
    
    // MARK: - Views
    @IBOutlet weak var numpadView: NumpadView! {
        didSet {
            numpadView.delegate = self
            numpadView.type = .number
        }
    }
    
    // MARK: - Labels
    @IBOutlet weak var authenticatorCodeLabel: TitleLabel! {
        didSet {
            authenticatorCodeLabel.font = UIFont.getFont(.medium, size: 32)
            authenticatorCodeLabel.text = viewModel.labelPlaceholder
        }
    }
    
    @IBOutlet weak var recoveryCodeSwitch: UISwitch! {
        didSet {
            recoveryCodeSwitch.onTintColor = UIColor.primary
            recoveryCodeSwitch.thumbTintColor = UIColor.Cell.switchThumbTint
            recoveryCodeSwitch.tintColor = UIColor.Cell.switchTint
        }
    }
    @IBOutlet weak var recoveryCodeTitleLabel: TitleLabel! {
        didSet {
            recoveryCodeTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.text = "Enter the 2F authentication code "
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    @IBOutlet weak var underLineView: UIView! {
        didSet {
            underLineView.backgroundColor = UIColor.Border.forButton
        }
    }
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Variables
    var enteredValue: String = ""
    private var isRecoveryCode: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        signInButton.setEnabled(false)
        signInButton.setTitle(viewModel.buttonTitle, for: .normal)
        
        titleLabel.text = viewModel.titleText
        titleLabel.textColor = UIColor.TwoFactor.title
    }
    
    private func signInMethod() {
        hideKeyboard()
        showProgressHUD()
        
        signIn { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.showSuccessHUD(completion: { [weak self] (finish) in
                    self?.viewModel.startAsAuthorized()
                })
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func signIn(completion: @escaping CompletionBlock) {
        var authenticatorCode = authenticatorCodeLabel.text ?? ""
        authenticatorCode = authenticatorCode.trimmingCharacters(in: .whitespaces)
        
        isRecoveryCode
            ? viewModel.riskControl(recoveryCode: authenticatorCode, completion: completion)//viewModel.signIn(recoveryCode: authenticatorCode, completion: completion)
            : viewModel.riskControl(twoFactorCode: authenticatorCode, completion: completion)//viewModel.signIn(twoFactorCode: authenticatorCode, completion: completion)
    }
    
    // MARK: - Actions
    @IBAction func signInButtonAction(_ sender: UIButton) {
        signInMethod()
    }
    
    @IBAction func recoveryCodeSwitchChanged(_ sender: UISwitch) {
        isRecoveryCode = sender.isOn
    }
}

extension AuthTwoFactorSignInViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        return nil
    }
    
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return viewModel.numbersLimit
    }
    
    var currency: CurrencyType? {
        return nil
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.authenticatorCodeLabel
    }
    
    func textLabelDidChange(value: Double?) {
        guard let text = authenticatorCodeLabel.text?.replacingOccurrences(of: " ", with: "") else { return }
        signInButton.setEnabled(text.count == viewModel.numbersLimit)
        updateNumPadState(value: text)
    }
    
    func onClearClicked(view: NumpadView) {
        guard let text = textLabel.text, !text.isEmpty, text != textPlaceholder else { return }
        
        if text.last == " " {
            textLabel.text?.removeLast(1)
        }
        
        textLabel.text?.removeLast(1)
        
        textLabelDidChange(value: textLabel.text?.doubleValue)
    }
    
    func onSeparatorClicked(view: NumpadView) {
    }
    
    func onNumberClicked(view: NumpadView, value: Int) {
        guard let text = textLabel.text else { return }
    
        text == textPlaceholder ? textLabel.text = value.toString() : textLabel.text?.append(value.toString())

        if let text = textLabel.text {
            let count = text.replacingOccurrences(of: " ", with: "").count
            
            switch count {
            case 3:
                textLabel.text?.append(" ")
            case 6:
                signInMethod()
            default:
                break
            }
        }
        
        textLabelDidChange(value: textLabel.text?.doubleValue)
    }
    
    func updateNumPadState(value: String?) {
        guard let text = value else { return }
        changedActive(value: text.count < viewModel.numbersLimit)
    }
}

