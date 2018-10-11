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
        
        if let amountValue = programProfitChart.balance {
            cell.balanceTitleLabel.text = "Balance"
            cell.balanceValueLabel.text = amountValue.rounded(withType: .gvt).toString() + " GVT"
        }
        
        if let amountValue = programProfitChart.investors {
            cell.investorsCountTitleLabel.text = "Investors"
            cell.investorsCountValueLabel.text = amountValue.toString()
        }
        
        if let amountValue = programProfitChart.lastPeriodStarts {
            cell.startDateTitleLabel.text = "Last period starts"
            cell.startDateValueLabel.text = amountValue.toString()
        }
        
        if let amountValue = programProfitChart.lastPeriodEnds {
            cell.endDateTitleLabel.text = "Last period ends"
            cell.endDateValueLabel.text = amountValue.toString()
        }

        if let amountValue = programProfitChart.trades {
            cell.tradesCountTitleLabel.text = "Trades count"
            cell.tradesCountValueLabel.text = amountValue.toString()
        }
        
        if let amountValue = programProfitChart.successTradesPercent {
            cell.tradesSuccessCountTitleLabel.text = "Success trades"
            cell.tradesSuccessCountValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        if let amountValue = programProfitChart.profitFactor {
            cell.profitFactorPercentTitleLabel.text = "Profit factor"
            cell.profitFactorPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        if let amountValue = programProfitChart.sharpeRatio {
            cell.sharpeRatioPercentTitleLabel.text = "Sharpe ratio"
            cell.sharpeRatioPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        if let amountValue = programProfitChart.calmarRatio {
            cell.calmarRatioPercentTitleLabel.text = "Calmar Ratio"
            cell.calmarRatioPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        if let amountValue = programProfitChart.sortinoRatio {
            cell.sortinoRatioPercentTitleLabel.text = "Sortino Ratio"
            cell.sortinoRatioPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
        
        if let amountValue = programProfitChart.maxDrawdown {
            cell.drawdownPercentTitleLabel.text = "Max drawdown"
            cell.drawdownPercentValueLabel.text = amountValue.rounded(toPlaces: 2).toString() + " %"
        }
    }
}
