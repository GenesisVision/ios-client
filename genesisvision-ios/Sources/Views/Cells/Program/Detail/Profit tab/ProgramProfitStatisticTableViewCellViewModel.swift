//
//  ProgramProfitStatisticTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramProfitStatisticTableViewCellViewModel {
    let programProfitChart: ProgramProfitChart
}

extension ProgramProfitStatisticTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailProfitStatisticTableViewCell) {
        cell.titleLabel.text = "Statistics"
        
        cell.balanceTitleLabel.text = "Equity"
        if let value = programProfitChart.balance, let programCurrency = programProfitChart.programCurrency, let currency = CurrencyType(rawValue: programCurrency.rawValue) {
            cell.balanceValueLabel.text = value.rounded(with: currency).toString() + " \(currency.rawValue)"
        }
        
        cell.investorsCountTitleLabel.text = "Investors"
        if let value = programProfitChart.investors {
            cell.investorsCountValueLabel.text = value.toString()
        }
        
        cell.startDateTitleLabel.text = "Last period starts"
        if let value = programProfitChart.lastPeriodStarts {
            cell.startDateValueLabel.text = value.toString()
        }
        
        cell.endDateTitleLabel.text = "Last period ends"
        if let value = programProfitChart.lastPeriodEnds {
            cell.endDateValueLabel.text = value.toString()
        }

        cell.tradesCountTitleLabel.text = "Trades count"
        if let value = programProfitChart.trades {
            cell.tradesCountValueLabel.text = value.toString()
        }
        
        cell.tradesSuccessCountTitleLabel.text = "Success trades"
        if let value = programProfitChart.successTradesPercent {
            cell.tradesSuccessCountValueLabel.text = value.rounded(with: .undefined).toString() + "%"
        }
        
        cell.profitFactorPercentTitleLabel.text = "Profit factor"
        if let value = programProfitChart.profitFactor {
            cell.profitFactorPercentValueLabel.text = value.rounded(with: .undefined).toString()
        }
        
        cell.sharpeRatioPercentTitleLabel.text = "Sharpe ratio"
        if let value = programProfitChart.sharpeRatio {
            cell.sharpeRatioPercentValueLabel.text = value.rounded(with: .undefined).toString()
        }
        
        cell.calmarRatioPercentTitleLabel.text = "Calmar ratio"
        if let value = programProfitChart.calmarRatio {
            cell.calmarRatioPercentValueLabel.text = value.rounded(with: .undefined).toString()
            
        }
        
        cell.sortinoRatioPercentTitleLabel.text = "Sortino ratio"
        if let value = programProfitChart.sortinoRatio {
            cell.sortinoRatioPercentValueLabel.text = value.rounded(with: .undefined).toString()
        }
        
        cell.drawdownPercentTitleLabel.text = "Max drawdown"
        if let value = programProfitChart.maxDrawdown {
            cell.drawdownPercentValueLabel.text = value.rounded(with: .undefined).toString() + "%"
        }
    }
}
