//
//  AuthThreeFactorSignInViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 20.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class AuthThreeFactorSignInViewController: BaseViewController {
    
    var viewModel: AuthThreeFactorSignInViewModel!
    
    @IBOutlet weak var numpadView: NumpadView! {
        didSet {
            numpadView.delegate = self
            numpadView.type = .number
        }
    }
    
    @IBOutlet weak var authCodeLabel: TitleLabel! {
        didSet {
            authCodeLabel.font = UIFont.getFont(.medium, size: 32)
            authCodeLabel.text = viewModel.labelPlaceholder
        }
    }
    
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.textColor = UIColor.Cell.title
            titleLabel.font = UIFont.getFont(.regular, size: 16.0)
        }
    }
    
    private var enteredValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        title = viewModel.title
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
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func signIn(completion: @escaping CompletionBlock) {
        var authenticatorCode = authCodeLabel.text ?? ""
        authenticatorCode = authenticatorCode.trimmingCharacters(in: .whitespaces)
        
        viewModel.signIn(authenticatorCode: authenticatorCode, completion: completion)
    }
}

extension AuthThreeFactorSignInViewController: NumpadViewProtocol {
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
        return authCodeLabel
    }
    
    func textLabelDidChange(value: Double?) {
        guard let text = authCodeLabel.text?.replacingOccurrences(of: " ", with: "") else { return }
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


final class AuthThreeFactorSignInViewModel {
    
    var title: String = "Security verification"
    var labelPlaceholder: String = ""
    
    var titleText: String {
        return "To secure your account, please complete the following verification\n\nEnter the 6 digit code received by \n\(email)"
    }
    
    public private(set) var numbersLimit: Int = 6
    private let email: String
    private let password: String
    private var router: Router!
    
    init(withRouter router: Router, email: String, password: String) {
        self.router = router
        self.email = email
        self.password = password
    }
    
    func signIn(authenticatorCode: String, completion: @escaping CompletionBlock) {
        guard let token = AuthManager.tempAuthorizedToken else { return completion(.failure(errorType: .apiError(message: nil))) }
        
        let model = ThreeFactorAuthenticatorConfirm(email: email, code: authenticatorCode, token: token)
        
        TwoFactorDataProvider.confirmThreeStepAuth(model: model, completion: { [weak self] (viewModel) in
            if let viewModel = viewModel {
                AuthManager.authorizedToken = viewModel
                self?.router.startAsAuthorized()
            }
        }, errorCompletion: completion)
    }
}
