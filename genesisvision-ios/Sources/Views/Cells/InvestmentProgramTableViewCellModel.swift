//
//  InvestmentProgramTableViewCellModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct InvestmentProgramTableViewCellModel {
    let investmentProgramEntity: InvestmentProgramEntity
}

extension InvestmentProgramTableViewCellModel: CellViewModel {
    func setup(on cell: TraderTableViewCell) {
        cell.userNameLabel.text = investmentProgramEntity.nickname
        cell.currencyLabel.text = investmentProgramEntity.currency.uppercased()
        
        cell.profileImageView.levelLabel.text = "\(investmentProgramEntity.rating)"
        
        cell.depositLabel.text = "" + investmentProgramEntity.currency.uppercased()
        cell.tradesLabel.text = "\(investmentProgramEntity.ordersCount)"
        cell.weeksLabel.text = "\(investmentProgramEntity.period)"
        cell.profitLabel.text = "\(investmentProgramEntity.totalProfit)"
    }
}
