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
        
        if let canWithdraw = fundDetailsFull?.personalFundDetails?.canWithdraw {
            cell.withdrawButton.setEnabled(canWithdraw)
        }
        
        cell.disclaimerLabel.text = ""
        
        cell.yourInvestmentProtocol = yourInvestmentProtocol
        cell.withdrawButton.setTitle("Withdraw", for: .normal)
        cell.titleLabel.text = "Your investment"
        
        cell.statusButton.handleUserInteractionEnabled = false
        
        if let status = fundDetailsFull?.personalFundDetails?.status {
            cell.statusButton.setTitle(status.rawValue, for: .normal)
            cell.statusButton.layoutSubviews()
        } else {
            cell.statusButton.isHidden = true
        }
        
        cell.disclaimerLabel.isHidden = true
        
        cell.reinvestView.isHidden = true
        cell.reinvestSwitch.isHidden = true
        cell.reinvestTitleLabel.isHidden = true
        
        let currency: CurrencyType = .gvt
        
        if let value = fundDetailsFull?.personalFundDetails?.value {
            cell.investedTitleLabel.text = "value"
            cell.investedValueLabel.text = value.rounded(withType: currency).toString() + " " + currency.rawValue
        } else {
            cell.investedTitleLabel.isHidden = true
            cell.investedValueLabel.isHidden = true
        }
        
        if let value = fundDetailsFull?.personalFundDetails?.pendingInput, value > 0 {
            cell.valueTitleLabel.text = "pending input"
            cell.valueLabel.text = value.rounded(withType: currency).toString() + " " + currency.rawValue
        } else {
            cell.valueTitleLabel.isHidden = true
            cell.valueLabel.isHidden = true
        }
        
        if let value = fundDetailsFull?.personalFundDetails?.pendingOutput, value > 0 {
            cell.profitTitleLabel.text = "pending output"
            cell.profitValueLabel.text = value.rounded(withType: currency).toString() + " " + currency.rawValue
        } else {
            cell.profitTitleLabel.isHidden = true
            cell.profitValueLabel.isHidden = true
        }
    }
}
