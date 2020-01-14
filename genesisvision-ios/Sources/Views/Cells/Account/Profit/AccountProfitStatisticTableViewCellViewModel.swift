//
//  AccountProfitStatisticTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 13.01.2020.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct AccountProfitStatisticTableViewCellViewModel {
    let currency: CurrencyType
    let statistic: AccountChartStatistic
}

extension AccountProfitStatisticTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailProfitStatisticTableViewCell) {
        cell.titleLabel.text = "Statistics"
        
        cell.stackView.removeAllArrangedSubviews()
        
        if let value = statistic.balance {
            let text = value.rounded(with: currency).toString() + " \(currency.rawValue)"
            cell.addToStackView(text, header: "Equity")
        }
        
        if let value = statistic.trades {
            let text = value.toString()
            cell.addToStackView(text, header: "Trades count")
        }
        
        if let value = statistic.successTradesPercent {
            let text = value.rounded(with: .undefined).toString() + "%"
            cell.addToStackView(text, header: "Success trades")
        }
        
        if let value = statistic.profitFactor {
            let text = value.rounded(with: .undefined).toString()
            cell.addToStackView(text, header: "Profit factor")
        }
        
        if let value = statistic.sharpeRatio {
            let text = value.rounded(with: .undefined).toString()
            cell.addToStackView(text, header: "Sharpe ratio")
        }
        
        if let value = statistic.calmarRatio {
            let text = value.rounded(with: .undefined).toString()
            cell.addToStackView(text, header: "Calmar ratio")
            
        }
        
        if let value = statistic.sortinoRatio {
            let text = value.rounded(with: .undefined).toString()
            cell.addToStackView(text, header: "Sortino ratio")
        }
        
        if let value = statistic.maxDrawdown {
            let text = value.rounded(with: .undefined).toString() + "%"
            cell.addToStackView(text, header: "Max drawdown")
        }
    }
}
