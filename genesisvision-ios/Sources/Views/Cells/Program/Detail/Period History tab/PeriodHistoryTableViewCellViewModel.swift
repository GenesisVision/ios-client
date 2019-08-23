//
//  PeriodHistoryTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct PeriodHistoryTableViewCellViewModel {
    let model: ProgramPeriodViewModel
    let currency: CurrencyType?
}

extension PeriodHistoryTableViewCellViewModel: CellViewModel {
    func setup(on cell: PeriodHistoryTableViewCell) {
        cell.periodTitleLabel.text = "Period"

        if let number = model.number {
            cell.periodLabel.text = number.toString()
        }
        cell.investorsTitleLabel.text = "Investors"
        if let investors = model.investors {
            cell.investorsLabel.text = investors.toString()
        }
        cell.dateStartTitleLabel.text = "Date start"
        if let dateFrom = model.dateFrom {
            cell.dateStartLabel.text = dateFrom.onlyTimeFormatString
        }
        cell.dateFinishTitleLabel.text = "Period length"
        if let periodLength = model.periodLength {
            cell.dateFinishLabel.text = getPeriodDuration(from: Int(periodLength / 60))
        }
        cell.balanceTitleLabel.text = "Balance"
        if let balance = model.balance, let currency = currency {
            cell.balanceLabel.text = balance.toString() + " " + currency.rawValue
        }
        cell.profitTitleLabel.text = "Profit"
        if let profit = model.profit, let currency = currency {
            cell.profitLabel.text = profit.toString() + " " + currency.rawValue
            cell.profitLabel.textColor = profit == 0 ? UIColor.Cell.title : profit > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
    }
}


