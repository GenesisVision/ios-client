//
//  FundProfitStatisticTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct FundProfitStatisticTableViewCellViewModel {
    let currency: CurrencyType
    let statistic: FundChartStatistic
}

extension FundProfitStatisticTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailProfitStatisticTableViewCell) {
        
        cell.stackView.removeAllArrangedSubviews()
        
        cell.titleLabel.text = "Statistics"
        
        if let value = statistic.balance {
            let text = value.rounded(with: currency).toString() + " \(currency.rawValue)"
            cell.addToStackView(text, header: "Equity")
        }
        
        if let value = statistic.investors {
            let text = value.toString()
            cell.addToStackView(text, header: "Investors")
        }
        
        if let value = statistic.creationDate {
            let text = value.toString()
            cell.addToStackView(text, header: "Start date")
        }
        
        if let value = statistic.profitPercent {
            let text = value.rounded(with: .undefined).toString() + "%"
            cell.addToStackView(text, header: "Profit change")
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
