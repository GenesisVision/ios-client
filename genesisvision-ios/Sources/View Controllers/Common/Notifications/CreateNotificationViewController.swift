//
//  CreateNotificationViewController.swift
//  genesisvision-ios
//
//  Created by George on 26/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class CreateNotificationViewController: BaseViewController {
    
    var viewModel: CreateNotificationViewModel!
    
    // MARK: - Variables
    
    var profitAmountValue: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Labels
    @IBOutlet weak var typeTitleLabel: SubtitleLabel! {
        didSet {
            typeTitleLabel.text = "Type"
        }
    }
    
    @IBOutlet weak var levelTitleLabel: SubtitleLabel! {
        didSet {
            levelTitleLabel.text = "Select level"
        }
    }
    
    @IBOutlet weak var profitTitleLabel: SubtitleLabel! {
        didSet {
            profitTitleLabel.text = "Enter amount"
        }
    }
    
    @IBOutlet weak var profitAmountValueLabel: TitleLabel! {
        didSet {
            profitAmountValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    
    // MARK: - Views
    @IBOutlet weak var numpadHeightConstraint: NSLayoutConstraint! {
        didSet {
            numpadHeightConstraint.constant = 0.0
        }
    }
    
    @IBOutlet weak var numpadBackView: UIView! {
        didSet {
            numpadBackView.isHidden = true
            numpadBackView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideNumpadView))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.delegate = self
            numpadBackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var numpadView: NumpadView! {
        didSet {
            numpadView.isUserInteractionEnabled = true
            numpadView.delegate = self
            numpadView.type = .currency
        }
    }
    
    @IBOutlet weak var typeStackView: UIStackView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTypeButtonAction(_:)))
            tapGesture.numberOfTapsRequired = 1
            typeStackView.isUserInteractionEnabled = true
            typeStackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var profitStackView: UIStackView! {
        didSet {
            profitStackView.isHidden = false
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showNumPadButtonAction(_:)))
            tapGesture.numberOfTapsRequired = 1
            profitStackView.isUserInteractionEnabled = true
            profitStackView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var levelStackView: UIStackView! {
        didSet {
            levelStackView.isHidden = false
        }
    }
    
    
    // MARK: - TextFields
    @IBOutlet weak var typeTextField: DesignableUITextField! {
        didSet {
            typeTextField.setClearButtonWhileEditing()
            typeTextField.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Buttons
    @IBOutlet weak var createButton: ActionButton!
    
    // MARK: - Variables
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = viewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        createButton.setEnabled(false)
        
    }
    
    private func updateUI() {
        
//        let createButtonEnabled = amountToInvestValue >= minInvestmentAmount ?? 0 && amountToInvestValue <= availableToInvestValue
//        
//        createButton.setEnabled(createButtonEnabled)
    }
    
    @IBAction func showNumPadButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        numpadHeightConstraint.constant = 212.0
        numpadBackView.setNeedsUpdateConstraints()
        numpadBackView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.numpadBackView.layoutIfNeeded()
        })
    }
    
    @objc private func hideNumpadView() {
        numpadHeightConstraint.constant = 0.0
        numpadBackView.setNeedsUpdateConstraints()
        numpadBackView.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.numpadBackView.layoutIfNeeded()
        })
    }
    
    private func createMethod() {
        //TODO: Create
    }
    
    // MARK: - Actions
    @IBAction func showTypeButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func createButtonAction(_ sender: UIButton) {
        createMethod()
    }
    
}

extension CreateNotificationViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        return 100
    }
    
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return -1
    }
    
    var currency: CurrencyType? {
        return nil
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.profitAmountValueLabel
    }
    
    var enteredAmountValue: Double {
        return profitAmountValue
    }
    
    func textLabelDidChange(value: Double?) {
        guard let value = value else { return }
        
        numpadView.isEnable = true
        profitAmountValue = value
    }
}

extension CreateNotificationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
