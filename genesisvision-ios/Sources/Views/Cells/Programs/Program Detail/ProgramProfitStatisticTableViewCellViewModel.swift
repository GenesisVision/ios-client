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
        cell.titleLabel.text = "Settings"
        
        if let amountValue = programProfitChart.maxDrawdown {
            cell.drawdownPercentTitleLabel.text = "Max drawdown"
            cell.drawdownPercentValueLabel.text = amountValue.toString()
        }

        if let amountValue = programProfitChart.lastPeriodStarts {
            cell.startDateTitleLabel.text = "Start day"
            cell.startDateValueLabel.text = amountValue.toString()
        }
        
        if let amountValue = programProfitChart.successTradesPercent {
            cell.tradesSuccessCountTitleLabel.text = "Success trades"
            cell.tradesSuccessCountValueLabel.text = amountValue.toString()
        }
        
        if let amountValue = programProfitChart.sharpeRatio {
            cell.sharpeRatioPercentTitleLabel.text = "Sharpe ratio"
            cell.sharpeRatioPercentValueLabel.text = amountValue.toString()
        }
        
        if let amountValue = programProfitChart.trades {
            cell.tradesCountTitleLabel.text = "Trades count"
            cell.tradesCountValueLabel.text = amountValue.toString()
        }
        
        if let amountValue = programProfitChart.investors {
            cell.investorsCountTitleLabel.text = "Investors"
            cell.investorsCountValueLabel.text = amountValue.toString()
        }
        
        if let amountValue = programProfitChart.balance {
            cell.startBalanceTitleLabel.text = "Balance"
            cell.startBalanceValueLabel.text = amountValue.toString()
        }
        
        if let amountValue = programProfitChart.profitFactor {
            cell.profitFactorPercentTitleLabel.text = "Profit factor"
            cell.profitFactorPercentValueLabel.text = amountValue.toString()
        }
    }
}
