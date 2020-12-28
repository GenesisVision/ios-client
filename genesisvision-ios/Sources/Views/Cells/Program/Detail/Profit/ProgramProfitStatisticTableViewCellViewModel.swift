//
//  ProgramProfitStatisticTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct ProgramProfitStatisticTableViewCellViewModel {
    let currency: CurrencyType
    let statistic: ProgramChartStatistic
    let programType: BrokerTradeServerType
}

extension ProgramProfitStatisticTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailProfitStatisticTableViewCell) {
        cell.titleLabel.text = "Statistics"
        
        cell.stackView.removeAllArrangedSubviews()
        
        if let value = statistic.balance {
            let text = value.rounded(with: getPlatformCurrencyType()).toString() + " \(getPlatformCurrencyType().rawValue)"
            cell.addToStackView(text, header: "Equity")
        }
        
        if let value = statistic.investors {
            let text = value.toString()
            cell.addToStackView(text, header: "Investors")
        }
        
        if let value = statistic.lastPeriodStarts, !(programType == .binance) {
            let text = value.toString()
            cell.addToStackView(text, header: "Last period starts")
        }
        
        if let value = statistic.lastPeriodEnds, !(programType == .binance) {
            let text = value.toString()
            cell.addToStackView(text, header: "Last period ends")
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
