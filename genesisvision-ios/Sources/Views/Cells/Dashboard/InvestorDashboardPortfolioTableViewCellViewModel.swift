//
//  InvestorDashboardPortfolioTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/08/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct InvestorDashboardPortfolioTableViewCellViewModel {
    
}

extension InvestorDashboardPortfolioTableViewCellViewModel: CellViewModel {
    func setup(on cell: InvestorDashboardPortfolioTableViewCell) {
        cell.configure(with: ["Portfolio", "Profit"])
    }
}
