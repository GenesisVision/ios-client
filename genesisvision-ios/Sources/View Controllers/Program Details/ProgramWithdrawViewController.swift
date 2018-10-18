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
    @IBOutlet var availableToWithdrawValueTitleLabel: TitleLabel! {
        didSet {
            availableToWithdrawValueTitleLabel.text = "You invested in program"
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
            amountToWithdrawGVTLabel.font = UIFont.getFont(.regular, size: 18.0)
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
            numpadView.type = .currency
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
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    private func updateUI() {
        if let availableToWithdraw = viewModel.programWithdrawInfo?.availableToWithdraw {
            self.availableToWithdrawValue = availableToWithdraw
        }

        if let periodEnds = viewModel.programWithdrawInfo?.periodEnds {
            self.payoutDayValueLabel.text = periodEnds.onlyDateFormatString
        }
        
        if let rate = viewModel.programWithdrawInfo?.rate {
            let selectedCurrency = getSelectedCurrency()
            let currency = CurrencyType(rawValue: selectedCurrency) ?? .gvt
            let amountToWithdrawValueCurrencyString = (amountToWithdrawValue / rate).rounded(withType: currency).toString()
            self.amountToWithdrawCurrencyLabel.text = "= " + amountToWithdrawValueCurrencyString + " " + selectedCurrency
        }
        
        let withdrawButtonEnabled = amountToWithdrawValue > 0.0 && amountToWithdrawValue <= availableToWithdrawValue
        
        withdrawButton.setEnabled(withdrawButtonEnabled)
        updateNumPadState(value: amountToWithdrawValueLabel.text)
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
                    self?.bottomSheetController.dismiss()
                    self?.viewModel.goToBack()
                }
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
    
    private func showConfirmVC() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.containerViewBackgroundColor = UIColor.Background.gray
        bottomSheetController.initializeHeight = 400
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()
        let periodEnds = viewModel.programWithdrawInfo?.periodEnds
        let periodEndsString = periodEnds?.defaultFormatString ?? ""
        let subtitle = "Your request will be processed at the end of the reporting period " + periodEndsString
        
        let confirmViewModel = InvestWithdrawConfirmModel(title: "Confirm Withdraw",
                                                          subtitle: subtitle,
                                                          programLogo: nil,
                                                          programTitle: viewModel.programWithdrawInfo?.title,
                                                          managerName: nil,
                                                          firstTitle: "Amount to withdraw",
                                                          firstValue: amountToWithdrawValueLabel.text,
                                                          secondTitle: "Payout day",
                                                          secondValue: viewModel.programWithdrawInfo?.periodEnds?.onlyDateFormatString,
                                                          thirdTitle: nil,
                                                          thirdValue: nil)
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


extension ProgramWithdrawViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        withdrawMethod()
    }
}
