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
        
        cell.disclaimerLabel.text = "You can withdraw only the invested funds, the profit will be withdrawn to your account at the end of the period automatically."
        
        cell.yourInvestmentProtocol = yourInvestmentProtocol
        cell.withdrawButton.setTitle("Withdraw", for: .normal)
        cell.titleLabel.text = "Your investment"
        
        if let status = fundDetailsFull?.personalFundDetails?.status?.rawValue {
            cell.statusButton.setTitle(status, for: .normal)
            cell.statusButton.layoutSubviews()
        } else {
            cell.statusButton.isHidden = true
        }
        
        cell.reinvestSwitch.isHidden = true
        cell.reinvestTitleLabel.isHidden = true
        
        let currency: CurrencyType = .usd
        
        
        if let value = fundDetailsFull?.personalFundDetails?.invested {
            cell.investedTitleLabel.text = "invested"
            cell.investedValueLabel.text = value.rounded(withType: currency).toString() + " " + currency.rawValue
        }
        
        if let value = fundDetailsFull?.personalFundDetails?.value {
            cell.valueTitleLabel.text = "value"
            cell.valueLabel.text = value.rounded(withType: currency).toString() + " " + currency.rawValue
        }
        
        if let profit = fundDetailsFull?.personalFundDetails?.profit {
            cell.profitTitleLabel.text = "profit"
            cell.profitValueLabel.text = profit.rounded(withType: currency).toString() + " " + currency.rawValue
        }
    }
}
