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
    case unlocked, enabled, disabled, closed
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
        didSet(value) {
            guard passcodeState != value else {
                return
            }
            
            setupUI()
        }
    }
    
    var attempts: Int = 0
    var newPasscode: String!
    
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.isHidden = true
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    @IBOutlet weak var subtitleLabel: TitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    @IBOutlet weak var passwordStackView: UIStackView!
    @IBOutlet weak var blurView: UIVisualEffectView! {
        didSet {
            blurView.isHidden = false
        }
    }

    // MARK: - Variables
    var passwordContainerView: PasswordContainerView! {
        didSet {
            passwordContainerView.touchAuthenticationEnabled = false
            passwordContainerView.backgroundColor = .clear
            passwordContainerView.tintColor = UIColor.Common.numpadDotsBackground
            passwordContainerView.highlightedColor = UIColor.primary
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.isHidden = true
        }
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    // MARK: - Private methods
    fileprivate func setup() {
        //create PasswordContainerView
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: viewModel.passwordDigit)
        passwordContainerView.delegate = self
        passwordContainerView.deleteButton.setImage(#imageLiteral(resourceName: "img_numpad_delete"), for: .normal)
        passwordContainerView.deleteButtonLocalizedTitle = ""
        
        //customize password UI
        passwordContainerView.isVibrancyEffect = viewModel.isVibrancyEffect
        
        passwordContainerView.passwordDotView.strokeColor = UIColor.Border.forButton
        passwordContainerView.passwordDotView.fillColor = UIColor.primary
        
        passwordContainerView.touchAuthenticationButton.tintColor = UIColor.Border.forButton
        for inputView in passwordContainerView.passwordInputViews {
            inputView.label.font = viewModel.numButtonFont
            inputView.circleBackgroundColor = .clear
            inputView.borderColor = .clear
            inputView.textColor = UIColor.Font.numPadText
            inputView.highlightTextColor = UIColor.primary
            inputView.highlightBackgroundColor = .clear
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private
    func setupUI() {
        view.backgroundColor = .clear//UIColor.BaseView.bg
        titleLabel.text = viewModel.title
        
        guard passwordContainerView != nil, closeButton != nil, subtitleLabel != nil else {
            return
        }
        
        passwordContainerView.touchAuthenticationEnabled = false
        
        switch passcodeState {
        case .enable:
            subtitleLabel.text = viewModel.enableText
            subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
            subtitleLabel.textColor = UIColor.Cell.subtitle
            
            closeButton.isHidden = false
            titleLabel.isHidden = false
            hidePasswordView(false)
        case .disable:
            subtitleLabel.text = viewModel.disableText
            subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
            subtitleLabel.textColor = UIColor.Cell.subtitle
            
            closeButton.isHidden = false
            titleLabel.isHidden = false
            hidePasswordView(false)
        case .lock:
            subtitleLabel.text = viewModel.enterText
            
            let touchAuthenticationEnabled = viewModel.touchAuthenticationEnabled
        
            if viewModel.changedMessageEnable {
                let texts = viewModel.changedAlertTexts
                showAlertWithTitle(title: texts.0, message: texts.1, actionTitle: nil, cancelTitle: String.Alerts.okButtonText, handler: nil, cancelHandler: nil)
            }
            
            if touchAuthenticationEnabled {
                passwordContainerView.touchAuthenticationButton.sendActions(for: .touchUpInside)
            }
            
            passwordContainerView.touchAuthenticationEnabled = touchAuthenticationEnabled
            
            hidePasswordView(false)
        case .openApp:
            hidePasswordView(true)
        }
    }
    
    private func hidePasswordView(_ value: Bool) {
        passwordContainerView.isHidden = value
        subtitleLabel.isHidden = value
    }
    
    @objc func willEnterForeground() {
        setupUI()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        viewModel.closeVC()
        delegate?.passcodeAction(.closed)
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
                subtitleLabel.text = viewModel.enterAgainText
                subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
                subtitleLabel.textColor = UIColor.Cell.subtitle
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
            delegate?.passcodeAction(.closed)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func validationFail() {
        print("*️⃣ failure!")
        attempts = 0
        newPasscode = nil
        passwordContainerView.wrongPassword()
        
        switch passcodeState {
        case .enable:
            subtitleLabel.text = viewModel.enableText
        case .disable:
            subtitleLabel.text = viewModel.disableText
        case .lock:
            subtitleLabel.text = viewModel.enterText
        case .openApp:
            break
        }
    }
}

