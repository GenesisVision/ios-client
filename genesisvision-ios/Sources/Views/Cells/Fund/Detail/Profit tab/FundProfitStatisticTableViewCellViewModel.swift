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
        if let value = fundProfitChart.balance {
            cell.balanceValueLabel.text = value.rounded(with: .gvt).toString() + " \(Constants.gvtString)"
        }
        
        cell.investorsCountTitleLabel.text = "Investors"
        if let value = fundProfitChart.investors {
            cell.investorsCountValueLabel.text = value.toString()
        }
        
        cell.startDateTitleLabel.text = "Start date"
        if let value = fundProfitChart.creationDate {
            cell.startDateValueLabel.text = value.toString()
        }
        
        cell.endDateStackView.isHidden = true
        cell.tradesCountStackView.isHidden = true
        cell.tradesSuccessCountStackView.isHidden = true
        
        cell.profitFactorPercentTitleLabel.text = "Profit change"
        if let value = fundProfitChart.profitChangePercent {
            cell.profitFactorPercentValueLabel.text = value.rounded(with: .undefined).toString() + "%"
        }
        
        cell.sharpeRatioPercentTitleLabel.text = "Sharpe ratio"
        if let value = fundProfitChart.sharpeRatio {
            cell.sharpeRatioPercentValueLabel.text = value.rounded(with: .undefined).toString()
        }
        
        cell.calmarRatioPercentTitleLabel.text = "Calmar ratio"
        if let value = fundProfitChart.calmarRatio {
            cell.calmarRatioPercentValueLabel.text = value.rounded(with: .undefined).toString()
        }
        
        cell.sortinoRatioPercentTitleLabel.text = "Sortino ratio"
        if let value = fundProfitChart.sortinoRatio {
            cell.sortinoRatioPercentValueLabel.text = value.rounded(with: .undefined).toString()
        }
        
        cell.drawdownPercentTitleLabel.text = "Max drawdown"
        if let value = fundProfitChart.maxDrawdown {
            cell.drawdownPercentValueLabel.text = value.rounded(with: .undefined).toString() + "%"
        }
    }
}
