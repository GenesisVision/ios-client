//
//  WalletTransactionView.swift
//  genesisvision-ios
//
//  Created by George on 26/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol WalletTransactionViewProtocol: class {
    func closeButtonDidPress()
    func copyAddressButtonDidPress(_ address: String)
    func resendButtonDidPress(_ uuid: UUID)
    func cancelButtonDidPress(_ uuid: UUID)

}

class WalletTransactionView: UIView {
    // MARK: - Variables
    weak var delegate: WalletTransactionViewProtocol?
    
    var uuid: UUID?
    var transactionDetails: TransactionDetails?
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topStackView: TopStackView!
    @IBOutlet weak var statusStackView: StatusStackView!
    
    @IBOutlet weak var investmentStackView: InvestmentStackView! {
        didSet {
            investmentStackView.isHidden = true
        }
    }
    @IBOutlet weak var withdrawalStackView: WithdrawalStackView! {
        didSet {
            withdrawalStackView.isHidden = true
        }
    }
    @IBOutlet weak var convertingStackView: ConvertingStackView! {
        didSet {
            convertingStackView.isHidden = true
        }
    }
    @IBOutlet weak var externalWithdrawalStackView: ExternalWithdrawalStackView! {
        didSet {
            externalWithdrawalStackView.isHidden = true
        }
    }
    @IBOutlet weak var externalDepositStackView: ExternalDepositStackView! {
        didSet {
            externalDepositStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var openProgramStackView: OpenProgramStackView! {
        didSet {
            openProgramStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var platformFeeStackView: PlatformFeeStackView! {
        didSet {
            platformFeeStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var signalDepositStackView: SignalDepositStackView! {
        didSet {
            signalDepositStackView.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public Methods
    func configure(_ model: TransactionDetails, uuid: UUID) {
        self.scrollView.contentInset.bottom = 40.0
        self.uuid = uuid
        self.transactionDetails = model
        
        topStackView.titleLabel.text = "Transaction details"
        
        guard let type = model.type else { return }
    
        switch type {
        case .externalDeposit:
            setupExternalDeposit(model)
        case .externalWithdrawal:
            setupExternalWithdrawal(model)
        case .investing, .profit:
            setupInvestingAndProfit(model)
        case .withdrawal:
            setupWithdrawal(model)
        case .converting:
            setupConverting(model)
        case .open, .close:
            setupOpenCloseProgram(model)
        case .platformFee:
            setupPlatformFeeProgram(model)
        case .depositSignal:
            setupSignalDeposit(model)
        case .platform, .receiveSignal, .subscribeSignal, .withdrawalSignal:
            break
        }
        
        if let status = model.status {
            var image = #imageLiteral(resourceName: "img_wallet_status_pending_icon")
            switch status {
            case .done:
                image = #imageLiteral(resourceName: "img_wallet_status_done_icon")
            case .canceled, .error:
                image = #imageLiteral(resourceName: "img_wallet_status_delete_icon")
            case .pending:
                image = #imageLiteral(resourceName: "img_wallet_status_pending_icon")
            }
            
            statusStackView.iconImageView.image = image
            statusStackView.subtitleLabel.text = "Status"
            statusStackView.titleLabel.text = status.rawValue
            
            if let externalTransactionDetails = model.externalTransactionDetails, let description = externalTransactionDetails.description, let text = statusStackView.titleLabel.text {
                statusStackView.titleLabel.text = text + " " + description
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func copyAddressButtonAction(_ sender: UIButton) {
        if let fromAddress = transactionDetails?.externalTransactionDetails?.fromAddress {
            delegate?.copyAddressButtonDidPress(fromAddress)
        }
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.closeButtonDidPress()
    }
    
    @IBAction func resendButtonAction(_ sender: UIButton) {
        if let uuid = uuid {
            delegate?.resendButtonDidPress(uuid)
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        if let uuid = uuid {
            delegate?.cancelButtonDidPress(uuid)
        }
    }
}

// MARK: - Setups
extension WalletTransactionView {
    private func setupPlatformFeeProgram(_ model: TransactionDetails) {
        platformFeeStackView.isHidden = false
        topStackView.subtitleLabel.text = "Platform fee"
        
        platformFeeStackView.fromWalletStackView.headerLabel.text = "From"
        platformFeeStackView.fromWalletStackView.iconImageView.image = UIImage.walletPlaceholder
        if let logo = model.currencyLogo, let fileUrl = getFileURL(fileName: logo) {
            platformFeeStackView.fromWalletStackView.iconImageView.kf.indicatorType = .activity
            platformFeeStackView.fromWalletStackView.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            platformFeeStackView.fromWalletStackView.iconImageView.backgroundColor = .clear
        }
        if let currencyName = model.currencyName {
            platformFeeStackView.fromWalletStackView.titleLabel.text = currencyName
        }
        
        platformFeeStackView.amountStackView.subtitleLabel.text = "Amount"
        if let amount = model.amount, let currency = model.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
            platformFeeStackView.amountStackView.titleLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
        }
    }
    private func setupExternalDeposit(_ model: TransactionDetails) {
        externalDepositStackView.isHidden = false
        topStackView.subtitleLabel.text = "Deposit"
        
        externalDepositStackView.fromWalletStackView.headerLabel.text = "From external address"
        externalDepositStackView.fromWalletStackView.iconImageView.image = #imageLiteral(resourceName: "img_wallet_external_icon")
        
        if let fromAddress = model.externalTransactionDetails?.fromAddress {
            externalDepositStackView.fromWalletStackView.titleLabel.text = fromAddress
            externalDepositStackView.fromWalletStackView.copyButton.isHidden = false
        }
        
        externalDepositStackView.toAmountStackView.subtitleLabel.text = "Amount"
        if let amount = model.amount, let currency = model.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
            externalDepositStackView.toAmountStackView.titleLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
        }
    }
    private func setupExternalWithdrawal(_ model: TransactionDetails) {
        externalWithdrawalStackView.isHidden = false
        topStackView.subtitleLabel.text = "Withdrawal"
        
        externalWithdrawalStackView.fromWalletStackView.headerLabel.text = "From"
        externalWithdrawalStackView.fromWalletStackView.iconImageView.image = UIImage.walletPlaceholder
        if let logo = model.currencyLogo, let fileUrl = getFileURL(fileName: logo) {
            externalWithdrawalStackView.fromWalletStackView.iconImageView.kf.indicatorType = .activity
            externalWithdrawalStackView.fromWalletStackView.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            externalWithdrawalStackView.fromWalletStackView.iconImageView.backgroundColor = .clear
        }
        if let currencyName = model.currencyName {
            externalWithdrawalStackView.fromWalletStackView.titleLabel.text = currencyName
        }
        
        externalWithdrawalStackView.fromAmountStackView.subtitleLabel.text = "Amount"
        if let amount = model.amount, let currency = model.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
            externalWithdrawalStackView.fromAmountStackView.titleLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
        }
        
        if let details = model.externalTransactionDetails {
            externalWithdrawalStackView.toWalletStackView.headerLabel.text = "To external address"
            
            externalWithdrawalStackView.toWalletStackView.iconImageView.image = #imageLiteral(resourceName: "img_wallet_transaction_address_icon")
            
            if let fromAddress = details.fromAddress {
                externalWithdrawalStackView.toWalletStackView.titleLabel.text = fromAddress
                externalWithdrawalStackView.toWalletStackView.copyButton.isHidden = false
            }
            
            if let isEnableActions = details.isEnableActions {
                externalWithdrawalStackView.actionsStackView.isHidden = !isEnableActions
            }
        }
    }
    private func setupOpenCloseProgram(_ model: TransactionDetails) {
        openProgramStackView.isHidden = false
        openProgramStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let details = model.programDetails, let currency = model.currency, let type = model.type {
            if let programType = details.programType {
                openProgramStackView.assetStackView.headerLabel.text = programType == .program ? "Program" : "Fund"
                if type == .open {
                    topStackView.subtitleLabel.text = programType == .program ? "Open program" : "Open fund"
                } else if type == .close {
                    topStackView.subtitleLabel.text = programType == .program ? "Close program" : "Close fund"
                }
                
                if programType == .program, let level = details.level {
                    openProgramStackView.assetStackView.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
                } else {
                    openProgramStackView.assetStackView.assetLogoImageView.levelButton.isHidden = true
                }
            }
            
            if let color = details.color {
                openProgramStackView.assetStackView.assetLogoImageView?.profilePhotoImageView?.backgroundColor = UIColor.hexColor(color)
            }
            if let logo = details.logo, let fileUrl = getFileURL(fileName: logo) {
                openProgramStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.kf.indicatorType = .activity
                openProgramStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                openProgramStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.backgroundColor = .clear
            }
            
            if let title = details.title {
                openProgramStackView.assetStackView.titleLabel.text = title
            }
            if let managerName = model.programDetails?.managerName {
                openProgramStackView.assetStackView.subtitleLabel.text = managerName
            }
            
            openProgramStackView.amountStackView.subtitleLabel.text = "Investment amount"
            if let amount = model.amount, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                openProgramStackView.amountStackView.titleLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
            } else {
                openProgramStackView.amountStackView.isHidden = true
            }
        }
    }
    private func setupInvestingAndProfit(_ model: TransactionDetails) {
        investmentStackView.isHidden = false
        investmentStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let details = model.programDetails, let currency = model.currency, let programType = details.programType {
            investmentStackView.assetStackView.headerLabel.text = programType == .program ? "To the program" : "To the fund"
            topStackView.subtitleLabel.text = programType == .program ? "Program investment" : "Fund investment"
            
            if programType == .program, let level = details.level {
                investmentStackView.assetStackView.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
            } else {
                investmentStackView.assetStackView.assetLogoImageView.levelButton.isHidden = true
            }
            
            if let color = details.color {
            investmentStackView.assetStackView.assetLogoImageView?.profilePhotoImageView?.backgroundColor = UIColor.hexColor(color)
            }
            if let logo = details.logo, let fileUrl = getFileURL(fileName: logo) {
                investmentStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.kf.indicatorType = .activity
                investmentStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                investmentStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.backgroundColor = .clear
            }
            
            if let title = details.title {
                investmentStackView.assetStackView.titleLabel.text = title
            }
            if let managerName = model.programDetails?.managerName {
                investmentStackView.assetStackView.subtitleLabel.text = managerName
            }
            
            if programType == .program, let successFee = model.programDetails?.successFee, let successFeePercent = model.programDetails?.successFeePercent, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                investmentStackView.successFeeStackView.subtitleLabel.text = "Success fee"
                investmentStackView.successFeeStackView.titleLabel.text = "\(successFeePercent)% (" + successFee.rounded(withType: currencyType).toString() + " " + currencyType.rawValue + ")"
            } else {
                investmentStackView.successFeeStackView.isHidden = true
            }
            
            if programType == .fund, let exitFee = model.programDetails?.exitFee, let exitFeePercent = model.programDetails?.exitFeePercent, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                investmentStackView.exitFeeStackView.subtitleLabel.text = "Exit fee"
                investmentStackView.exitFeeStackView.titleLabel.text = "\(exitFeePercent)% (" + exitFee.rounded(withType: currencyType).toString() + " " + currencyType.rawValue + ")"
            } else {
                investmentStackView.exitFeeStackView.isHidden = true
            }
            
            investmentStackView.entryFeeStackView.subtitleLabel.text = "Entry fee"
            if let entryFee = model.programDetails?.entryFee, let entryFeePercent = model.programDetails?.entryFeePercent, let currencyType = CurrencyType(rawValue: currency.rawValue) {

                investmentStackView.entryFeeStackView.titleLabel.text = "\(entryFeePercent)% (" + entryFee.rounded(withType: currencyType).toString() + " " + currencyType.rawValue + ")"
            } else {
                investmentStackView.entryFeeStackView.isHidden = true
            }
            investmentStackView.gvCommissionStackView.subtitleLabel.text = "GV Commission"
            if let gvCommission = model.gvCommission, let gvCommissionCurrency = model.gvCommissionCurrency, let gvCommissionPercent = model.gvCommissionPercent, let currencyType = CurrencyType(rawValue: gvCommissionCurrency.rawValue) {
                investmentStackView.gvCommissionStackView.titleLabel.text = "\(gvCommissionPercent)% (" + gvCommission.rounded(withType: currencyType).toString() + " " + currencyType.rawValue + ")"
            } else {
                investmentStackView.gvCommissionStackView.isHidden = true
            }
            investmentStackView.amountStackView.subtitleLabel.text = "Investment amount"
            if let amount = model.amount, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                investmentStackView.amountStackView.titleLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
            } else {
                investmentStackView.amountStackView.isHidden = true
            }
        }
    }
    private func setupWithdrawal(_ model: TransactionDetails) {
        withdrawalStackView.isHidden = false
        withdrawalStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let details = model.programDetails, let currency = model.currency {
            if let programType = details.programType {
                withdrawalStackView.assetStackView.headerLabel.text = programType == .program ? "From the program" : "From the fund"
                topStackView.subtitleLabel.text = programType == .program ? "Program withdrawal" : "Fund withdrawal"
                
                if programType == .program, let level = details.level {
                    withdrawalStackView.assetStackView.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
                } else {
                    withdrawalStackView.assetStackView.assetLogoImageView.levelButton.isHidden = true
                }
            }
            if let color = details.color {
                withdrawalStackView.assetStackView.assetLogoImageView?.profilePhotoImageView?.backgroundColor = UIColor.hexColor(color)
            }
            if let logo = details.logo, let fileUrl = getFileURL(fileName: logo) {
                withdrawalStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.kf.indicatorType = .activity
                withdrawalStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                withdrawalStackView.assetStackView.assetLogoImageView?.profilePhotoImageView.backgroundColor = .clear
            }
            if let title = details.title {
                withdrawalStackView.assetStackView.titleLabel.text = title
            }
            if let managerName = model.programDetails?.managerName {
                withdrawalStackView.assetStackView.subtitleLabel.text = managerName
            }
            withdrawalStackView.amountStackView.subtitleLabel.text = "Withdrawal amount"
            if let amount = model.amount, let currencyType = CurrencyType(rawValue: currency.rawValue) {
                withdrawalStackView.amountStackView.titleLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
            } else {
                withdrawalStackView.amountStackView.isHidden = true
            }
        }
    }
    
    private func setupConverting(_ model: TransactionDetails) {
        convertingStackView.isHidden = false
        guard let currency = model.currency else { return }
        topStackView.subtitleLabel.text = "Converting"
        
        convertingStackView.fromWalletStackView.iconImageView.image = UIImage.walletPlaceholder
        convertingStackView.toWalletStackView.iconImageView.image = UIImage.walletPlaceholder
        
        convertingStackView.fromWalletStackView.headerLabel.text = "From"
        if let currencyName = model.currencyName {
            convertingStackView.fromWalletStackView.titleLabel.text = currencyName
        } else {
            convertingStackView.fromWalletStackView.isHidden = true
        }
        convertingStackView.fromWalletStackView.iconImageView.image = UIImage.walletPlaceholder
        if let logo = model.currencyLogo, let fileUrl = getFileURL(fileName: logo) {
            convertingStackView.fromWalletStackView.iconImageView.kf.indicatorType = .activity
            convertingStackView.fromWalletStackView.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            convertingStackView.fromWalletStackView.iconImageView.backgroundColor = .clear
        }
        
        convertingStackView.fromAmountStackView.subtitleLabel.text = "Written off wallet"
        if let amount = model.amount, let currencyType = CurrencyType(rawValue: currency.rawValue) {
            convertingStackView.fromAmountStackView.titleLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
        } else {
            convertingStackView.fromAmountStackView.isHidden = true
        }
        
        if let details = model.convertingDetails, let currencyTo = details.currencyTo {
            convertingStackView.toWalletStackView.headerLabel.text = "To"
            if let currencyName = details.currencyToName {
                convertingStackView.toWalletStackView.titleLabel.text = currencyName
            } else {
                convertingStackView.toWalletStackView.isHidden = true
            }
            convertingStackView.toWalletStackView.iconImageView.image = UIImage.walletPlaceholder
            if let logo = details.currencyToLogo, let fileUrl = getFileURL(fileName: logo) {
                convertingStackView.toWalletStackView.iconImageView.kf.indicatorType = .activity
                convertingStackView.toWalletStackView.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
                convertingStackView.toWalletStackView.iconImageView.backgroundColor = .clear
            }
            
            convertingStackView.toAmountStackView.subtitleLabel.text = "Credited to the wallet"
            if let amount = details.amountTo, let currencyType = CurrencyType(rawValue: currencyTo.rawValue) {
                convertingStackView.toAmountStackView.titleLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
            } else {
                convertingStackView.toAmountStackView.isHidden = true
            }
            
            if let amount = details.rateValue, let currencyType = CurrencyType(rawValue: currencyTo.rawValue) {
                convertingStackView.rateStackView.titleLabel.text = "1 \(currency.rawValue) = \(amount.rounded(withType: currencyType).toString()) \(currencyType.rawValue)"
            } else {
                convertingStackView.rateStackView.isHidden = true
            }
        }
    }
    
    private func setupSignalDeposit(_ model: TransactionDetails) {
        signalDepositStackView.isHidden = false
        topStackView.subtitleLabel.text = "Deposit to signal account"
        
        signalDepositStackView.amountStackView.subtitleLabel.text = "Investment amount"
        if let amount = model.amount, let currency = model.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
            signalDepositStackView.amountStackView.titleLabel.text = amount.rounded(withType: currencyType).toString() + " " + currencyType.rawValue
        }
    }
}

class InvestmentStackView: UIStackView {
    @IBOutlet weak var assetStackView: AssetStackView!
    @IBOutlet weak var successFeeStackView: DefaultStackView!
    @IBOutlet weak var exitFeeStackView: DefaultStackView!
    @IBOutlet weak var entryFeeStackView: DefaultStackView!
    @IBOutlet weak var gvCommissionStackView: DefaultStackView!
    @IBOutlet weak var amountStackView: AmountStackView!
}

class WithdrawalStackView: UIStackView {
    @IBOutlet weak var assetStackView: AssetStackView!
    @IBOutlet weak var amountStackView: AmountStackView!
}

class ConvertingStackView: UIStackView {
    @IBOutlet weak var fromWalletStackView: ExternalStackView!
    @IBOutlet weak var fromAmountStackView: DefaultStackView!
    @IBOutlet weak var toWalletStackView: ExternalStackView!
    @IBOutlet weak var toAmountStackView: DefaultStackView!
    @IBOutlet weak var rateStackView: RateStackView!
}

class ExternalWithdrawalStackView: UIStackView {
    @IBOutlet weak var fromWalletStackView: ExternalStackView!
    @IBOutlet weak var fromAmountStackView: AmountStackView!
    @IBOutlet weak var toWalletStackView: ExternalStackView!
    @IBOutlet weak var actionsStackView: ActionsStackView! {
        didSet {
            actionsStackView.isHidden = true
        }
    }
}

class ExternalDepositStackView: UIStackView {
    @IBOutlet weak var fromWalletStackView: ExternalStackView!
    @IBOutlet weak var toAmountStackView: AmountStackView!
}

class OpenProgramStackView: UIStackView {
    @IBOutlet weak var assetStackView: AssetStackView!
    @IBOutlet weak var amountStackView: AmountStackView!
}

class PlatformFeeStackView: UIStackView {
    @IBOutlet weak var fromWalletStackView: ExternalStackView!
    @IBOutlet weak var amountStackView: AmountStackView!
}

class SignalDepositStackView: UIStackView {
    @IBOutlet weak var amountStackView: AmountStackView!
}


class TopStackView: DefaultStackView {
    @IBOutlet weak var closeButton: UIButton!
    override var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 18.0)
        }
    }
    
    override var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
}

class DefaultStackView: UIStackView {
    @IBOutlet weak var headerLabel: SubtitleLabel! {
        didSet {
            headerLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 16.0)
        }
    }
    @IBOutlet weak var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
}

class StatusStackView: DefaultStackView {
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
        }
    }
}

class ActionsStackView: UIStackView {
    @IBOutlet weak var resendButton: ActionButton! {
        didSet {
            resendButton.setTitle("Resend email", for: .normal)
        }
    }
    @IBOutlet weak var cancelButton: ActionButton! {
        didSet {
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.configure(with: .highClear)
        }
    }
}

class AssetStackView: DefaultStackView {
    @IBOutlet weak var assetLogoImageView: ProfileImageView!
}

class AmountStackView: DefaultStackView {
    override var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.semibold, size: 20.0)
        }
    }
}

class RateStackView: UIStackView {
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 17.0)
        }
    }
}

class ExternalStackView: DefaultStackView {
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var copyButton: ActionButton! {
        didSet {
            copyButton.configure(with: .lightBorder)
            copyButton.isHidden = true
        }
    }
}
