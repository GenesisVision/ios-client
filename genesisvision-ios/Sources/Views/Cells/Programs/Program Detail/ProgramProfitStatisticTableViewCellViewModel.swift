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
    func setup(on cell: ProgramProfitStatisticTableViewCell) {
        cell.titleLabel.text = "Statistics"
        
        cell.balanceTitleLabel.text = "Balance"
        if let amountValue = programProfitChart.balance {
            cell.balanceValueLabel.text = amountValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        }
        
        cell.investorsCountTitleLabel.text = "Investors"
        if let amountValue = programProfitChart.investors {
            cell.investorsCountValueLabel.text = amountValue.toString()
        }
        
        cell.startDateTitleLabel.text = "Last period starts"
        if let amountValue = programProfitChart.lastPeriodStarts {
            cell.startDateValueLabel.text = amountValue.toString()
        }
        
        cell.endDateTitleLabel.text = "Last period ends"
        if let amountValue = programProfitChart.lastPeriodEnds {
            cell.endDateValueLabel.text = amountValue.toString()
        }

        cell.tradesCountTitleLabel.text = "Trades count"
        if let amountValue = programProfitChart.trades {
            cell.tradesCountValueLabel.text = amountValue.toString()
        }
        
        cell.tradesSuccessCountTitleLabel.text = "Success trades"
        if let amountValue = programProfitChart.successTradesPercent {
            cell.tradesSuccessCountValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        cell.profitFactorPercentTitleLabel.text = "Profit factor"
        if let amountValue = programProfitChart.profitFactor {
            cell.profitFactorPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        cell.sharpeRatioPercentTitleLabel.text = "Sharpe ratio"
        if let amountValue = programProfitChart.sharpeRatio {
            cell.sharpeRatioPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        cell.calmarRatioPercentTitleLabel.text = "Calmar ratio"
        if let amountValue = programProfitChart.calmarRatio {
            cell.calmarRatioPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        cell.sortinoRatioPercentTitleLabel.text = "Sortino ratio"
        if let amountValue = programProfitChart.sortinoRatio {
            cell.sortinoRatioPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        cell.drawdownPercentTitleLabel.text = "Max drawdown"
        if let amountValue = programProfitChart.maxDrawdown {
            cell.drawdownPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
    }
}
