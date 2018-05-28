//
//  AuthTwoFactorSignInViewController.swift
//  genesisvision-ios
//
//  Created by George on 25/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class AuthTwoFactorSignInViewController: BaseViewController {
    
    var viewModel: AuthTwoFactorSignInViewModel!
    
    // MARK: - Views
    @IBOutlet var numpadView: NumpadView! {
        didSet {
            numpadView.delegate = self
            numpadView.type = .number
        }
    }
    
    // MARK: - Labels
    @IBOutlet var authenticatorCodeLabel: UILabel! {
        didSet {
            authenticatorCodeLabel.font = UIFont.getFont(.light, size: 72)
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Buttons
    @IBOutlet var signInButton: ActionButton!
    
    // MARK: - Variables

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setTitle(title: viewModel.title, subtitle: getFullVersion(), type: .primary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = UIColor.Background.main
        
        setupNavigationBar(with: .primary)
        
        signInButton.setEnabled(false)
    }
    
    private func updateNumPadState(value: String?) {
        guard let text = value else { return }
        changedActive(value: text.count < viewModel.numbersLimit)
    }
    
    private func sighInMethod() {
        hideKeyboard()
        showProgressHUD()
        
        var authenticatorCode = authenticatorCodeLabel.text ?? ""
        authenticatorCode = authenticatorCode.trimmingCharacters(in: .whitespaces)
        
        viewModel.signIn(twoFactorCode: authenticatorCode) { [weak self] (result) in
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
    
    // MARK: - Actions
    @IBAction func signInButtonAction(_ sender: UIButton) {
        sighInMethod()
    }
}

extension AuthTwoFactorSignInViewController: NumpadViewProtocol {
    var numbersLimit: Int {
        return viewModel.numbersLimit
    }
    
    var currency: String? {
        return nil
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.authenticatorCodeLabel
    }
    
    func textLabelDidChange(value: Double?) {
        guard let text = authenticatorCodeLabel.text else { return }
        signInButton.setEnabled(text.count > 0)
        updateNumPadState(value: text)
    }
}

