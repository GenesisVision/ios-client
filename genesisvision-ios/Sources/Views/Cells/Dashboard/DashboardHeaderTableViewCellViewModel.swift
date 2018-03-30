//
//  DashboardHeaderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct DashboardHeaderTableViewCellViewModel {
    let investorDashboard: InvestorDashboard
}

extension DashboardHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: DashboardHeaderTableViewCell) {
        
        if let investedAmount = investorDashboard.investedAmount {
            cell.investedAmountLabel.text = investedAmount.rounded(withType: .gvt).toString()
        }
        
        if let profitFromPrograms = investorDashboard.profitFromPrograms {
            cell.profitFromProgramsLabel.text = profitFromPrograms.rounded(withType: .gvt).toString()
        }
    }
}
