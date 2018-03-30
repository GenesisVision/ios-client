//
//  ProgramDetailsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramDetailsTableViewCellViewModel {
    let investmentProgramDetails: InvestmentProgramDetails
}

extension ProgramDetailsTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramDetailsTableViewCell) {
        cell.programDetailsView.setup(investorsCount: investmentProgramDetails.investorsCount,
                                      balance: investmentProgramDetails.balance,
                                      avgProfit: investmentProgramDetails.profitAvg,
                                      totalProfit: investmentProgramDetails.profitTotal,
                                      currency: investmentProgramDetails.currency?.rawValue)
    }
}

