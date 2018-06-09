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
            cell.portfolioInvestedLabel.amountValue = investedAmount
        }
        
        if let profitFromPrograms = investorDashboard.profitFromPrograms {
            cell.portfolioProfitLabel.amountValue = profitFromPrograms
        }
        
        if let totalPortfolioAmount = investorDashboard.totalPortfolioAmount {
            cell.portfolioValueLabel.amountValue = totalPortfolioAmount
        }
        
        
    }
}
