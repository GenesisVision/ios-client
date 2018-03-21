//
//  ProgramMoreDetailsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramMoreDetailsTableViewCellViewModel {
    let investmentProgramDetails: InvestmentProgramDetails
}

extension ProgramMoreDetailsTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramMoreDetailsTableViewCell) {
        cell.programPropertiesView.setup(with: investmentProgramDetails.endOfPeriod, periodDuration: investmentProgramDetails.periodDuration, feeSuccess: investmentProgramDetails.feeSuccess, feeManagement: investmentProgramDetails.feeManagement, trades: investmentProgramDetails.tradesCount, investedTokens: investmentProgramDetails.investedTokens)
    }
}
