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
    @IBOutlet weak var availableToWithdrawValueTitleLabel: TitleLabel! {
        didSet {
            availableToWithdrawValueTitleLabel.text = "You invested in program"
            availableToWithdrawValueTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var availableToWithdrawValueLabel: TitleLabel! {
        didSet {
            availableToWithdrawValueLabel.textColor = UIColor.primary
            availableToWithdrawValueLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var amountToWithdrawTitleLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawTitleLabel.text = "Amount to withdraw"
        }
    }
    @IBOutlet weak var amountToWithdrawValueLabel: TitleLabel! {
        didSet {
            amountToWithdrawValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var amountToWithdrawGVTLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawGVTLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet weak var amountToWithdrawCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToWithdrawCurrencyLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet weak var copyMaxValueButton: UIButton! {
        didSet {
            copyMaxValueButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyMaxValueButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    @IBOutlet weak var payoutDayTitleLabel: SubtitleLabel! {
        didSet {
            payoutDayTitleLabel.text = "Payout day"
            payoutDayTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var payoutDayValueLabel: TitleLabel!
    
    // MARK: - Buttons
    @IBOutlet weak var withdrawButton: ActionButton!
    
    // MARK: - Views
    var confirmView: InvestWithdrawConfirmView!
    
    @IBOutlet weak var numpadView: NumpadView! {
        didSet {
            numpadView.isUserInteractionEnabled = true
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
            self.availableToWithdrawValueLabel.text = availableToWithdrawValue.toString() + " " + viewModel.programCurrency.rawValue
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
        
        amountToWithdrawGVTLabel.text = viewModel.programCurrency.rawValue
        
        if let availableToWithdraw = viewModel.programWithdrawInfo?.availableToWithdraw {
            self.availableToWithdrawValue = availableToWithdraw
        }

        if let periodEnds = viewModel.programWithdrawInfo?.periodEnds {
            self.payoutDayValueLabel.text = periodEnds.onlyDateFormatString
        }
        
        if let rate = viewModel.programWithdrawInfo?.rate {
            let selectedCurrency = getSelectedCurrency()
            let currency = CurrencyType(rawValue: selectedCurrency) ?? .gvt
            let amountToWithdrawValueCurrencyString = (amountToWithdrawValue * rate).rounded(withType: currency).toString()
            self.amountToWithdrawCurrencyLabel.text = "≈" + amountToWithdrawValueCurrencyString + " " + selectedCurrency
        }
        
        let withdrawButtonEnabled = amountToWithdrawValue > 0.0 && amountToWithdrawValue <= availableToWithdrawValue
        
        withdrawButton.setEnabled(withdrawButtonEnabled)
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
    
    @objc private func closeButtonAction() {
        viewModel.close()
    }
    
    private func showConfirmVC() {
        bottomSheetController = BottomSheetController()
        bottomSheetController.containerViewBackgroundColor = UIColor.Background.gray
        bottomSheetController.initializeHeight = 370.0
        
        confirmView = InvestWithdrawConfirmView.viewFromNib()
        
        let subtitle = "Your request will be processed at the end of the reporting period."
        
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

extension ProgramWithdrawViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        return availableToWithdrawValue
    }
    
    var textPlaceholder: String? {
        return viewModel.labelPlaceholder
    }
    
    var numbersLimit: Int? {
        return -1
    }
    
    var currency: CurrencyType? {
        return viewModel.programCurrency
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


extension ProgramWithdrawViewController: InvestWithdrawConfirmViewProtocol {
    func cancelButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func confirmButtonDidPress() {
        bottomSheetController.dismiss()
        withdrawMethod()
    }
}
