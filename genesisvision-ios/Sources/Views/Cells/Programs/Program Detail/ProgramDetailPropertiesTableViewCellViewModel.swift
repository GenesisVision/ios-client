//
//  ProgramDetailPropertiesTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramDetailPropertiesTableViewCellViewModel {
    let investmentProgramDetails: InvestmentProgramDetails
}

extension ProgramDetailPropertiesTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramDetailPropertiesTableViewCell) {
        cell.programDetailsView.setup(investorsCount: investmentProgramDetails.investorsCount,
                                      balance: investmentProgramDetails.balance,
                                      avrProfit: investmentProgramDetails.profitAvg,
                                      totalProfit: investmentProgramDetails.profitTotal)
        
        cell.programPropertiesView.setup(with: investmentProgramDetails.endOfPeriod, periodDuration: investmentProgramDetails.periodDuration, feeSuccess: investmentProgramDetails.feeSuccess, feeManagement: investmentProgramDetails.feeManagement, trades: investmentProgramDetails.tradesCount, availableInvestment: investmentProgramDetails.availableInvestment)
    }
}
