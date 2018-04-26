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
    weak var reloadDataProtocol: ReloadDataProtocol?
    weak var programPropertiesForTableViewCellViewProtocol: ProgramPropertiesForTableViewCellViewProtocol?
}

extension ProgramMoreDetailsTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramMoreDetailsTableViewCell) {

        cell.programPropertiesForTableViewCellViewProtocol = programPropertiesForTableViewCellViewProtocol
        cell.programPropertiesView.setup(with: investmentProgramDetails.endOfPeriod,
                                         periodDuration: investmentProgramDetails.periodDuration,
                                         feeSuccess: investmentProgramDetails.feeSuccess,
                                         feeManagement: investmentProgramDetails.feeManagement,
                                         trades: investmentProgramDetails.tradesCount,
                                         ownBalance: investmentProgramDetails.ownBalance,
                                         balance: investmentProgramDetails.balance,
                                         isEnable: investmentProgramDetails.isEnabled ?? false,
                                         reloadDataProtocol: reloadDataProtocol)
    }
}
