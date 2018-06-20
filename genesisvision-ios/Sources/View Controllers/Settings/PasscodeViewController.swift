//
//  PasscodeViewController.swift
//  genesisvision-ios
//
//  Created by George on 19/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import SmileLock

enum PasscodeActionType {
    case unlocked, enabled, disabled
}

protocol PasscodeProtocol: class {
    func passcodeAction(_ action: PasscodeActionType)
}

class PasscodeViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: PasscodeViewModel!
    
    weak var delegate: PasscodeProtocol?
    
    var bgColor: UIColor = .clear
    var passcodeState: PasscodeState = .openApp {
        didSet {
            setupUI()
        }
    }
    
    var attempts: Int = 0
    var newPasscode: String!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordStackView: UIStackView!
    
    // MARK: - Variables
    var passwordContainerView: PasswordContainerView!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = bgColor
        
        setupUI()
    }
    
    // MARK: - Private methods
    fileprivate func setup() {
        //create PasswordContainerView
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: viewModel.passwordDigit)
        passwordContainerView.delegate = self
        passwordContainerView.deleteButtonLocalizedTitle = viewModel.deleteButtonTitle
        
        //customize password UI
        passwordContainerView.isVibrancyEffect = viewModel.isVibrancyEffect
        
        // customize font
        for inputView in passwordContainerView.passwordInputViews {
            inputView.label.font = viewModel.labelFont
        }
    }
    
    private func setupUI() {
        guard passwordContainerView != nil, closeButton != nil, titleLabel != nil else {
            return
        }
        
        closeButton.isHidden = true
        passwordContainerView.touchAuthenticationEnabled = false
        
        switch passcodeState {
        case .enable, .disable:
            closeButton.isHidden = false
            hidePasswordView(false)
        case .lock:
            passwordContainerView.touchAuthenticationEnabled = UserDefaults.standard.bool(forKey: Constants.UserDefaults.biometricEnable)

            if passwordContainerView.touchAuthenticationEnabled {
                passwordContainerView.touchAuthenticationButton.sendActions(for: .touchUpInside)
            }
            
            hidePasswordView(false)
        case .openApp:
            hidePasswordView(true)
        }
    }
    
    private func hidePasswordView(_ value: Bool) {
        passwordContainerView.isHidden = value
        titleLabel.isHidden = value
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        viewModel.closeVC()
    }
}

extension PasscodeViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        attempts += 1
        
        if attempts == 1, passcodeState == .enable {
            newPasscode = input
            validationSuccess()
            return
        }
        
        if validation(input) {
            validationSuccess()
        } else {
            validationFail()
        }
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        if success {
            self.validationSuccess()
        } else {
            passwordContainerView.clearInput()
        }
    }
}

private extension PasscodeViewController {
    func validation(_ input: String) -> Bool {
        switch passcodeState {
        case .enable:
            if let newPasscode = newPasscode {
                return input == newPasscode
            }
        default:
            return input == viewModel.passcode
        }
        
        return false
    }
    
    func validationSuccess() {
        print("*️⃣ success!")
        
        switch passcodeState {
        case .enable:
            guard attempts == 2 else {
                passwordContainerView.clearInput()
                titleLabel.text = viewModel.againTitleLabelText
                return
            }
            viewModel.updatePasscode(newPasscode)
            delegate?.passcodeAction(.enabled)
            dismiss(animated: true, completion: nil)
        case .disable:
            viewModel.updatePasscode(nil)
            delegate?.passcodeAction(.disabled)
            dismiss(animated: true, completion: nil)
        case .lock:
            delegate?.passcodeAction(.unlocked)
            dismiss(animated: true, completion: nil)
        default:
            dismiss(animated: true, completion: nil)
        }
    }
    
    func validationFail() {
        print("*️⃣ failure!")
        attempts = 0
        newPasscode = nil
        titleLabel.text = viewModel.titleLabelText
        passwordContainerView.wrongPassword()
    }
}

