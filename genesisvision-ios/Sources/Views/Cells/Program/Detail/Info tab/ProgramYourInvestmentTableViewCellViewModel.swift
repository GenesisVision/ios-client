//
//  YourInvestmentTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct ProgramYourInvestmentTableViewCellViewModel {
    let details: Codable?
    weak var yourInvestmentProtocol: YourInvestmentProtocol?
}

extension ProgramYourInvestmentTableViewCellViewModel: CellViewModel {
    func setup(on cell: YourInvestmentTableViewCell) {
        if let details = details as? ProgramFollowDetailsFull {
            setupProgramDetails(details, cell: cell)
        } else if let details = details as? PrivateTradingAccountFull {
            setupAccountDetails(details, cell: cell)
        }
    }
    func setupAccountDetails(_ details: PrivateTradingAccountFull, cell: YourInvestmentTableViewCell) {
        cell.depositButton.isHidden = false
        cell.disclaimerLabel.isHidden = true
        cell.reinvestView.isHidden = true
        cell.statusButton.isHidden = true
        cell.investedTitleLabel.isHidden = true
        cell.investedValueLabel.isHidden = true
        cell.profitTitleLabel.isHidden = true
        cell.profitValueLabel.isHidden = true
        
        cell.yourInvestmentProtocol = yourInvestmentProtocol
        
        cell.withdrawButton.setTitle("Withdraw", for: .normal)
        cell.depositButton.setTitle("Add funds", for: .normal)
        cell.withdrawButton.isHidden = true//details.tradingAccountInfo?.isExternal ?? true
        cell.depositButton.isHidden = true//details.tradingAccountInfo?.isExternal ?? true
        
        cell.titleLabel.text = "Your deposit"
        
        cell.valueTitleLabel.text = "value"
        if let value = details.tradingAccountInfo?.balance {
            if let currency = details.tradingAccountInfo?.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency) {
                cell.valueLabel.text = value.rounded(with: currencyType).toString() + " " + currency
            } else {
                cell.valueLabel.text = value.rounded(with: .undefined).toString()
            }
        }
    }
    func setupProgramDetails(_ programDetailsFull: ProgramFollowDetailsFull, cell: YourInvestmentTableViewCell) {
        let programDetails = programDetailsFull.programDetails
        cell.withdrawButton.setEnabled(false)
        
        if let canWithdraw = programDetails?.personalDetails?.canWithdraw {
            cell.withdrawButton.setEnabled(canWithdraw)
        }
        
        if let isOwner = programDetailsFull.publicInfo?.isOwnAsset, isOwner {
            cell.reinvestView.isHidden = true
        }
        
        cell.disclaimerLabel.text = "You can withdraw only the invested funds, the profit will be withdrawn to your account at the end of the period automatically."

        cell.yourInvestmentProtocol = yourInvestmentProtocol
        cell.withdrawButton.setTitle("Withdraw", for: .normal)
        cell.titleLabel.text = "Current period investment"
        cell.reinvestTitleLabel.text = "Reinvest profit"
        
        if let status = programDetails?.personalDetails?.status?.rawValue {
            cell.statusButton.setTitle(status, for: .normal)
            cell.statusButton.layoutSubviews()
        } else {
            cell.statusButton.isHidden = true
        }
        
        if let isReinvesting = programDetails?.personalDetails?.isReinvest {
            cell.reinvestSwitch.isOn = isReinvesting
        }
        
        let currency = CurrencyType(rawValue: programDetailsFull.tradingAccountInfo?.currency?.rawValue ?? "") ?? .usd
        
        cell.investedTitleLabel.isHidden = true
        cell.investedValueLabel.isHidden = true
        
        cell.profitTitleLabel.text = "profit"
        if let profitPercent = programDetails?.personalDetails?.profitPercent,
            let value = programDetails?.personalDetails?.value,
            let invested = programDetails?.personalDetails?.invested {
            let profitValue = value - invested
            let sign = profitValue > 0 ? "+" : ""
            cell.profitValueLabel.text = sign + profitValue.rounded(with: currency).toString() + " " + currency.rawValue + " (\(profitPercent.rounded(with: .undefined).toString())%)"
            cell.profitValueLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        cell.valueTitleLabel.text = "value"
        if let value = programDetails?.personalDetails?.value {
            cell.valueLabel.text = value.rounded(with: currency).toString() + " " + currency.rawValue
        }
    }
}
