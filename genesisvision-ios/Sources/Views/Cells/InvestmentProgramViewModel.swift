//
//  TraderTableViewCellModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct InvestmentProgramViewModel {
    let traderEntity: TraderEntity
    let index: Int
}

extension InvestmentProgramViewModel: CellViewModel {
    func setup(on cell: TraderTableViewCell) {
        cell.userNameLabel.text = traderEntity.userName
        cell.currencyLabel.text = traderEntity.currency.uppercased()
        
        cell.profileImageView.levelLabel.text = "\(traderEntity.level)"
        
        cell.depositLabel.text = "\(traderEntity.deposit)" + " " + traderEntity.currency.uppercased()
        cell.tradesLabel.text = "\(traderEntity.trades)"
        cell.weeksLabel.text = "\(traderEntity.weeks)"
        cell.profitLabel.text = "\(traderEntity.profit)"
    }
}
