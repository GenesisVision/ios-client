//
//  AuthTwoFactorConfirmationViewController.swift
//  genesisvision-ios
//
//  Created by George on 30/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AuthTwoFactorConfirmationViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: AuthTwoFactorConfirmationViewModel!
    
    // MARK: - TextFields
    @IBOutlet var codeTitleLabel: SubtitleLabel! {
        didSet {
            codeTitleLabel.text = "2FA Code"
        }
    }
    @IBOutlet var codeTextField: DesignableUITextField! {
        didSet {
            codeTextField.placeholder = "2FA Code"
            codeTextField.setClearButtonWhileEditing()
            codeTextField.delegate = self
        }
    }
    @IBOutlet var passwordTitleLabel: SubtitleLabel! {
        didSet {
            passwordTitleLabel.text = "Your Password"
        }
    }
    @IBOutlet var passwordTextField: DesignableUITextField! {
        didSet {
            passwordTextField.placeholder = "Your Password"
            passwordTextField.setClearButtonWhileEditing()
            passwordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var recoveryCodeStackView: UIStackView! {
        didSet {
            recoveryCodeStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var recoveryCodeSwitch: UISwitch!
    
    // MARK: - Buttons
    @IBOutlet var confirmButton: ActionButton!

    // MARK: - Variables
    private var isRecoveryCode: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if DEBUG
        passwordTextField.text = "qwerty123"
        #endif
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        confirmButton.setTitle(viewModel.buttonTitleText, for: .normal)
    }
    
    private func confirmMethod() {
        hideKeyboard()
        showProgressHUD()
        
        confirmMethod(completion: { [weak self] (recoveryCodes) in
            self?.hideAll()
            self?.viewModel.showSuccess(recoveryCodes: recoveryCodes)
        }) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func confirmMethod(completion: @escaping (_ recoveryCodes: [String]?) -> Void, errorCompletion: @escaping CompletionBlock) {
        var code = codeTextField.text ?? ""
        var password = passwordTextField.text ?? ""
        
        code = code.trimmingCharacters(in: .whitespaces)
        password = password.trimmingCharacters(in: .whitespaces)
        
        isRecoveryCode
            ? viewModel.confirm(twoFactorCode: nil, recoveryCode: code, password: password, completion: completion, errorCompletion: errorCompletion)
            : viewModel.confirm(twoFactorCode: code, recoveryCode: nil, password: password, completion: completion, errorCompletion: errorCompletion)
    }
    
    // MARK: - Actions
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        confirmMethod()
    }
    
    @IBAction func recoveryCodeSwitchChanged(_ sender: UISwitch) {
        isRecoveryCode = sender.isOn
    }
}

extension AuthTwoFactorConfirmationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case codeTextField:
            confirmMethod()
        default:
            IQKeyboardManager.sharedManager().goNext()
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == codeTextField, let text = textField.text, string != "" else { return true }
        
        if text.count == viewModel.numbersLimit - 1 {
            textField.text?.append(string)

            if let text = passwordTextField.text, !text.isEmpty {
                confirmMethod()
            }
        }
        
        if let text = textField.text, text.count == viewModel.numbersLimit {
            textField.resignFirstResponder()
        }
        
        return text.count < viewModel.numbersLimit
    }
}
