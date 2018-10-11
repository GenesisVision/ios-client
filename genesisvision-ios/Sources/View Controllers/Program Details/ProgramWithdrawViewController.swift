//
//  ProgramWithdrawViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramWithdrawViewController: BaseViewController {

    var viewModel: ProgramWithdrawViewModel!
    
    // MARK: - Labels
    @IBOutlet var investedTitleLabel: TitleLabel! {
        didSet {
            investedTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var investedValueLabel: TitleLabel! {
        didSet {
            investedValueLabel.textColor = UIColor.primary
            investedValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var amountToWithdrawTitleLabel: SubtitleLabel!
    @IBOutlet var amountToWithdrawValueLabel: TitleLabel! {
        didSet {
            amountToWithdrawValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet var amountToWithdrawCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawCurrencyLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var copyMaxValueButton: UIButton!
    
    @IBOutlet var payoutDayTitleLabel: SubtitleLabel! {
        didSet {
            payoutDayTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var payoutDayValueLabel: TitleLabel!
    
    // MARK: - Buttons
    @IBOutlet var withdrawButton: ActionButton!
    
    private var closeBarButtonItem: UIBarButtonItem!
    
    // MARK: - Views
    @IBOutlet var numpadView: NumpadView! {
        didSet {
            numpadView.delegate = self
            numpadView.type = .currency
        }
    }
    
    // MARK: - Variables
    var amountToWithdrawValue: Double = 0.0 {
        didSet {
            withdrawButton.setEnabled(amountToWithdrawValue > 0.0 && amountToWithdrawValue <= investedValue)
            updateNumPadState(value: amountToWithdrawValueLabel.text)
        }
    }
    
    var investedValue: Double = 0.0
    
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
        closeBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_close_icon"), style: .done, target: self, action: #selector(closeButtonAction))
        navigationItem.rightBarButtonItem = closeBarButtonItem
        
        withdrawButton.setEnabled(false)
        
        if let investedValue = viewModel.investedValue {
            self.investedValue = investedValue
            investedValueLabel.text = self.investedValue.toString()
        }
        
        self.amountToWithdrawCurrencyLabel.text = "tokens"
    }
    
    private func withdrawMethod() {
        hideKeyboard()

        guard let text = amountToWithdrawValueLabel.text,
            let amount = text.doubleValue
            else { return showErrorHUD(subtitle: "Enter withdraw value, please") }
        
        showProgressHUD()
        viewModel.withdraw(with: amount) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.viewModel.showWithdrawRequestedVC()
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    private func updateNumPadState(value: String?) {
        if let text = value, text.range(of: ".") != nil,
            let lastComponents = text.components(separatedBy: ".").last,
            lastComponents.count >= getDecimalCount(for: currency) {
            changedActive(value: false)
        } else {
            changedActive(value: true)
        }
    }
    
    @objc private func closeButtonAction() {
        viewModel.close()
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        withdrawMethod()
    }
    
    @IBAction func copyAllButtonAction(_ sender: UIButton) {
        amountToWithdrawValueLabel.text = investedValue.toString(withoutFormatter: true)
        amountToWithdrawValue = investedValue
    }
}

extension ProgramWithdrawViewController: NumpadViewProtocol {
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int {
        return -1
    }
    
    var currency: String? {
        return ""
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.amountToWithdrawValueLabel
    }
    
    func textLabelDidChange(value: Double?) {
        numpadView.isEnable = true
        amountToWithdrawValue = value != nil ? value! : 0.0
    }
}
