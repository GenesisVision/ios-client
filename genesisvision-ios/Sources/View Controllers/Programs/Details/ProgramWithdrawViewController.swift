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
    @IBOutlet weak var availableToWithdrawValueTitleLabel: SubtitleLabel! {
        didSet {
            availableToWithdrawValueTitleLabel.text = "You invested in program"
        }
    }
    @IBOutlet weak var availableToWithdrawValueLabel: TitleLabel!
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
    @IBOutlet weak var withdrawButton: ActionButton! {
        didSet {
            withdrawButton.titleLabel?.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var withdrawAllStackView: UIStackView!
    
    @IBOutlet weak var withdrawAllSwitchButton: UIButton! {
        didSet {
            withdrawAllSwitchButton.setImage(#imageLiteral(resourceName: "img_checkbox_unselected_icon"), for: .normal)
            withdrawAllSwitchButton.setImage(#imageLiteral(resourceName: "img_checkbox_selected_icon"), for: .selected)
        }
    }
    
    @IBOutlet weak var approxLabelValue: SubtitleLabel! {
        didSet {
            
        }
    }
    
    private var isGenesisMarkets: Bool = false
    
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
        isGenesisMarkets = viewModel.programDetails?.brokerDetails?.type == .binance
        
        guard !isGenesisMarkets else {
            updateUIasGM()
            return
        }
        
        amountToWithdrawGVTLabel.text = viewModel.programCurrency.rawValue
        
        if let availableToWithdraw = viewModel.programWithdrawInfo?.availableToWithdraw {
            self.availableToWithdrawValue = availableToWithdraw
        }

        if let periodEnds = viewModel.programWithdrawInfo?.periodEnds {
            self.payoutDayValueLabel.text = periodEnds.onlyDateFormatString
        }
        
        if let isOwner = viewModel.programWithdrawInfo?.isOwner, isOwner {
            withdrawAllStackView.isHidden = true
        }
        
        let withdrawButtonEnabled = amountToWithdrawValue > 0.0 && amountToWithdrawValue <= availableToWithdrawValue
        
        withdrawButton.setEnabled(withdrawButtonEnabled)
    }
    
    private func updateUIasGM() {
        
        if let availableToWithdraw = viewModel.programWithdrawInfo?.availableToWithdraw {
            availableToWithdrawValue = availableToWithdraw
        }
        
        if amountToWithdrawValue > 100 {
            amountToWithdrawValueLabel.text = "100"
        }
        
        let withdrawingValue = availableToWithdrawValue / 100 * amountToWithdrawValue
        
        approxLabelValue.text = "≈" + withdrawingValue.toString() + " " + viewModel.programCurrency.rawValue
        
        if let isOwner = viewModel.programWithdrawInfo?.isOwner, isOwner {
            withdrawAllStackView.isHidden = true
        }
        
        if let periodEnds = viewModel.programWithdrawInfo?.periodEnds {
            payoutDayValueLabel.text = periodEnds.onlyDateFormatString
        }
        
        amountToWithdrawGVTLabel.text = "%"
        
        let withdrawButtonEnabled = withdrawingValue > 0.0 && withdrawingValue <= availableToWithdrawValue
        
        withdrawButton.setEnabled(withdrawButtonEnabled)
    }
    
    private func withdrawMethod() {
        
        var amountRaw: Double?
        
        if isGenesisMarkets {
            amountRaw = (availableToWithdrawValue / 100 * (amountToWithdrawValueLabel.text?.doubleValue ?? 0))
            amountRaw = viewModel.withdrawAll ? availableToWithdrawValue : amountRaw
        } else {
            guard let amountValue = amountToWithdrawValueLabel.text?.doubleValue
                else { return showErrorHUD(subtitle: "Enter withdraw value, please") }
            amountRaw = amountValue
        }
        
        guard let amount = amountRaw else {
            return
        }
        
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
        
        let withdrawAll = viewModel.withdrawAll
        
        var subtitle: String = "Your request will be processed at the end of the reporting period."
        
        if viewModel.programDetails?.brokerDetails?.type == .binance, let realTime =
            viewModel.programDetails?.programDetails?.dailyPeriodDetails?.isProcessingRealTime, !realTime, let date = viewModel.programDetails?.programDetails?.dailyPeriodDetails?.nextProcessingDate {
            subtitle = "Your request will be processed at \(date.textDateAndHours) GMT."
        }
        
        
        var withdrawingValue = amountToWithdrawValueLabel.text
        
        if isGenesisMarkets, let amountValue = amountToWithdrawValueLabel.text?.doubleValue {
            withdrawingValue = (availableToWithdrawValue / 100 * amountValue).toString() + " " + viewModel.programCurrency.rawValue
        }
        
        
        let confirmViewModel = InvestWithdrawConfirmModel(title: "Confirm Withdraw",
                                                          subtitle: subtitle,
                                                          programLogo: nil,
                                                          programTitle: viewModel.programWithdrawInfo?.title,
                                                          managerName: nil,
                                                          firstTitle: "Amount to withdraw",
                                                          firstValue: withdrawAll ? "All" : withdrawingValue,
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
        if isGenesisMarkets {
            amountToWithdrawValueLabel.text = "100"
            approxLabelValue.text = availableToWithdrawValue.toString() + " " + viewModel.programCurrency.rawValue
        } else {
            amountToWithdrawValueLabel.text = availableToWithdrawValue.toString(withoutFormatter: true)
            amountToWithdrawValue = availableToWithdrawValue
        }
        
        withdrawButton.setEnabled(true)
    }
    
    @IBAction func switchButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        numpadView.isBlock = !sender.isSelected
        viewModel.withdrawAll = sender.isSelected
        
        withdrawButton.setEnabled(sender.isSelected)
    }
}

extension ProgramWithdrawViewController: NumpadViewProtocol {
    var maxAmount: Double? {
        if isGenesisMarkets {
            return 100.0
        } else {
            return availableToWithdrawValue
        }
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
        guard let value = value else { return }
        
        if isGenesisMarkets {
            
        } else {
            guard value <= availableToWithdrawValue else { return }
        }
        

        
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
