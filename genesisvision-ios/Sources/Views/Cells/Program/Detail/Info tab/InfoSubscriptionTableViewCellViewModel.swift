//
//  InfoSubscriptionTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 08.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation

struct InfoSubscriptionTableViewCellViewModel {
    let signalSubscription: SignalSubscription?
    weak var infoSignalsProtocol: InfoSignalsProtocol?
}

extension InfoSubscriptionTableViewCellViewModel: CellViewModel {
    func setup(on cell: InfoSubscriptionTableViewCell) {
        cell.infoSignalsProtocol = infoSignalsProtocol
        
        cell.titleLabel.text = "Subscription details"
        
        if let signalSubscription = signalSubscription {
            if let hasActiveSubscription = signalSubscription.hasActiveSubscription {
                cell.statusTitleLabel.text = "status"
                cell.statusValueLabel.text = hasActiveSubscription ? "Active" : ""
            }

            if let totalProfit = signalSubscription.totalProfit {
                cell.profitTitleLabel.text = "profit"
                cell.profitValueLabel.text = totalProfit.rounded(with: .undefined).toString() + "%"
            }
            
            if let mode = signalSubscription.mode {
                cell.typeTitleLabel.text = "subscription type"
                var type = ""
                switch mode {
                case .byBalance:
                    type = "By balance"
                case .percent:
                    type = "Percentage"
                case .fixed:
                    type = "Fixed"
                }
                cell.typeValueLabel.text = type
            }

            if let value = signalSubscription.openTolerancePercent {
                cell.valueTitleLabel.text = "tolerance percentage"
                cell.valueValueLabel.text = value.rounded(with: .undefined).toString() + "%"
            }
        }
    }
}
