//
//  FundProfitStatisticTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct FundProfitStatisticTableViewCellViewModel {
    let fundProfitChart: FundProfitChart
}

extension FundProfitStatisticTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailProfitStatisticTableViewCell) {
        cell.titleLabel.text = "Statistics"
        
        cell.balanceTitleLabel.text = "Balance"
        if let amountValue = fundProfitChart.balance {
            cell.balanceValueLabel.text = amountValue.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        }
        
        cell.investorsCountTitleLabel.text = "Investors"
        if let amountValue = fundProfitChart.investors {
            cell.investorsCountValueLabel.text = amountValue.toString()
        }
        
        cell.startDateTitleLabel.text = "Last period starts"
        if let amountValue = fundProfitChart.lastPeriodStarts {
            cell.startDateValueLabel.text = amountValue.toString()
        }
        
        cell.endDateTitleLabel.text = "Last period ends"
        if let amountValue = fundProfitChart.lastPeriodEnds {
            cell.endDateValueLabel.text = amountValue.toString()
        }

        cell.tradesCountTitleLabel.text = "Rebalances"
        if let amountValue = fundProfitChart.rebalances {
            cell.tradesCountValueLabel.text = amountValue.toString()
        }
        
        cell.tradesSuccessCountStackView.isHidden = true
        cell.profitFactorPercentStackView.isHidden = true
        
        cell.sharpeRatioPercentTitleLabel.text = "Sharpe ratio"
        if let amountValue = fundProfitChart.sharpeRatio {
            cell.sharpeRatioPercentValueLabel.text = amountValue.rounded(withType: .undefined).toString() + " %"
        }
        
        cell.calmarRatioPercentTitleLabel.text = "Calmar ratio"
        if let amountValue = fundProfitChart.calmarRatio {
            cell.calmarRatioPercentValueLabel.text = amountValue.rounded(withType: .undefined).toString() + " %"
        }
        
        cell.sortinoRatioPercentTitleLabel.text = "Sortino ratio"
        if let amountValue = fundProfitChart.sortinoRatio {
            cell.sortinoRatioPercentValueLabel.text = amountValue.rounded(withType: .undefined).toString() + " %"
        }
        
        cell.drawdownPercentTitleLabel.text = "Max drawdown"
        if let amountValue = fundProfitChart.maxDrawdown {
            cell.drawdownPercentValueLabel.text = amountValue.rounded(withType: .undefined).toString() + " %"
        }
    }
}
