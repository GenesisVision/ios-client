//
//  FundWithdrawViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 25/10/18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FundWithdrawViewController: BaseViewController {

    var viewModel: FundWithdrawViewModel!
    
    // MARK: - Labels
    @IBOutlet var availableToWithdrawValueTitleLabel: TitleLabel! {
        didSet {
            availableToWithdrawValueTitleLabel.text = "Current invested value"
            availableToWithdrawValueTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var availableToWithdrawValueLabel: TitleLabel! {
        didSet {
            availableToWithdrawValueLabel.textColor = UIColor.primary
            availableToWithdrawValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var amountToWithdrawTitleLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawTitleLabel.text = "Amount to withdraw"
        }
    }
    @IBOutlet var amountToWithdrawValueLabel: TitleLabel! {
        didSet {
            amountToWithdrawValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet var amountToWithdrawGVTLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawGVTLabel.text = "%"
            amountToWithdrawGVTLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet var amountToWithdrawCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawCurrencyLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var copyMaxValueButton: UIButton! {
        didSet {
            copyMaxValueButton.isHidden = true
            copyMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    @IBOutlet var payoutDayTitleLabel: SubtitleLabel! {
        didSet {
            payoutDayTitleLabel.text = "Payout day"
            payoutDayTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet var payoutDayValueLabel: TitleLabel!
    
    // MARK: - Buttons
    @IBOutlet var withdrawButton: ActionButton!
    
    // MARK: - Views
    var confirmView: InvestWithdrawConfirmView!
    
    @IBOutlet var numpadView: NumpadView! {
        didSet {
            numpadView.delegate = self
            numpadView.type = .number
        }
    }
    
    // MARK: - Variables
    var amountToWithdrawValue: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    var availableToWithdrawValue: Double = 0.0 {
        didSet {
            self.availableToWithdrawValueLabel.text = availableToWithdrawValue.toString() + " " + Constants.gvtString
        }
    }
    
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
        withdrawButton.setEnabled(false)

        showProgressHUD()
        viewModel.getInfo(completion: { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        })
    }
    
    private func updateUI() {
        if let availableToWithdraw = viewModel.fundWithdrawInfo?.availableToWithdraw {
            self.availableToWithdrawValue = availableToWithdraw
        }

        
        let amountToWithdrawValueCurrencyString = (availableToWithdrawValue / 100 * amountToWithdrawValue).rounded(withType: .gvt).toString()
        self.amountToWithdrawCurrencyLabel.text = "≈ " + amountToWithdrawValueCurrencyString + " " + Constants.gvtString
        
        let withdrawButtonEnabled = amountToWithdrawValue > 0.0 && amountToWithdrawValue * 100 <= availableToWithdrawValue
        
        withdrawButton.setEnabled(withdrawButtonEnabled)
//        updateNumPadState(value: amountToWithdrawValueLabel.text)
    }
    
    private func withdrawMethod() {
        guard let text = amountToWithdrawValueLabel.text,
            let amount = text.doubleValue
            else { return showErrorHUD(subtitle: "Enter withdraw value, please") }
        
        showProgressHUD()
        viewModel.withdraw(with: amount) { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.viewModel.goToBack()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
//    private func updateNumPadState(value: String?) {
//        if let text = value, text.range(of: ".") != nil,
//            let lastComponents = text.components(separatedBy: ".").last,
//            lastComponents.count >= getDecimalCount(for: currency) {
//            changedActive(value: false)
//        } else {
//            changedActive(value: true)
//        }
//    }
    
    @objc private func closeButtonAction() {
        viewModel.close()
    }
    
    private func showConfirmVC() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.containerViewBackgroundColor = UIColor.Background.gray
        bottomSheetController.initializeHeight = 226.0
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()
    
        let confirmViewModel = InvestWithdrawConfirmModel(title: "Confirm Withdraw",
                                                          subtitle: nil,
                                                          programLogo: nil,
                                                          programTitle: nil,
                                                          managerName: nil,
                                                          firstTitle: "Amount to withdraw",
                                                          firstValue: amountToWithdrawValueLabel.text,
                                                          secondTitle: nil,
                                                          secondValue: nil,
                                                          thirdTitle: nil,
                                                          thirdValue: nil,
                                                          fourthTitle: nil,
                                                          fourthValue: nil)
        confirmView.configure(model: confirmViewModel)
        bottomSheetController.addContentsView(confirmView)
        confirmView.delegate = self
        bottomSheetController.present()
    }
    
    // MARK: - Actions
    @IBAction func withdrawButtonAction(_ sender: UIButton) {
        showConfirmVC()
    }
    
    @IBAction func copyAllButtonAction(_ sender: UIButton) {
        amountToWithdrawValueLabel.text = availableToWithdrawValue.toString(withoutFormatter: true)
        amountToWithdrawValue = availableToWithdrawValue
    }
}

extension FundWithdrawViewController: NumpadViewProtocol {
    var amountLimit: Double? {
        return availableToWithdrawValue / 100
    }
    
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return nil
    }
    
    var currency: CurrencyType? {
        return nil
    }
    
    func changedActive(value: Bool) {
        numpadView.isEnable = value
    }
    
    var textLabel: UILabel {
        return self.amountToWithdrawValueLabel
    }
    
    func textLabelDidChange(value: Double?) {
        guard let value = value, value <= availableToWithdrawValue else { return }
        
        numpadView.isEnable = true
        amountToWithdrawValue = value
    }
}


extension FundWithdrawViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        bottomSheetController.dismiss()
        withdrawMethod()
    }
}
