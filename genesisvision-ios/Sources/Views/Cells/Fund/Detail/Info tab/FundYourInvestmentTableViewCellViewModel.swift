//
//  FundYourInvestmentTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct FundYourInvestmentTableViewCellViewModel {
    let fundDetailsFull: FundDetailsFull?
    weak var yourInvestmentProtocol: YourInvestmentProtocol?
}

extension FundYourInvestmentTableViewCellViewModel: CellViewModel {
    func setup(on cell: YourInvestmentTableViewCell) {
        cell.withdrawButton.setEnabled(false)
        
        if let canWithdraw = fundDetailsFull?.personalDetails?.canWithdraw {
            cell.withdrawButton.setEnabled(canWithdraw)
        }
        
        cell.disclaimerLabel.text = ""
        
        cell.yourInvestmentProtocol = yourInvestmentProtocol
        cell.withdrawButton.setTitle("Withdraw", for: .normal)
        cell.titleLabel.text = "Current investment"
                
        if let status = fundDetailsFull?.personalDetails?.status {
            cell.statusButton.setTitle(status.rawValue, for: .normal)
            cell.statusButton.layoutSubviews()
        } else {
            cell.statusButton.isHidden = true
        }
        
        cell.disclaimerLabel.isHidden = true
        
        cell.reinvestView.isHidden = true
        cell.reinvestSwitch.isHidden = true
        cell.reinvestTitleLabel.isHidden = true
        
        let currency = getPlatformCurrencyType()
        
        if let value = fundDetailsFull?.personalDetails?.value {
            cell.investedTitleLabel.text = "value"
            cell.investedValueLabel.text = value.rounded(with: currency).toString() + " " + currency.rawValue
        } else {
            cell.investedTitleLabel.isHidden = true
            cell.investedValueLabel.isHidden = true
        }
        
        if let value = fundDetailsFull?.personalDetails?.pendingInput, value > 0, let currency = fundDetailsFull?.personalDetails?.pendingInOutCurrency {
            cell.valueTitleLabel.text = "pending input"
            cell.valueLabel.text = value.rounded(with: currency).toString() + " " + currency.rawValue
        } else {
            cell.valueTitleLabel.isHidden = true
            cell.valueLabel.isHidden = true
        }
        
        if let value = fundDetailsFull?.personalDetails?.pendingOutput, value > 0,
            let currency = fundDetailsFull?.personalDetails?.pendingInOutCurrency {
            cell.profitTitleLabel.text = "pending output"
            cell.profitValueLabel.text = value.rounded(with: currency).toString() + " " + currency.rawValue
        } else {
            cell.profitTitleLabel.isHidden = true
            cell.profitValueLabel.isHidden = true
        }
    }
}
