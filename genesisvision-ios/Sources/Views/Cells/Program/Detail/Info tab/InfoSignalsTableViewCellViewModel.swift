//
//  InfoSignalsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 20/02/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct InfoSignalsTableViewCellViewModel {
    let programDetailsFull: ProgramFollowDetailsFull?
    weak var infoSignalsProtocol: InfoSignalsProtocol?
}

extension InfoSignalsTableViewCellViewModel: CellViewModel {
    func setup(on cell: InfoSignalsTableViewCell) {
        cell.infoSignalsProtocol = infoSignalsProtocol
        
        cell.titleLabel.text = "Signals"
        
        if let signalSuccessFee = programDetailsFull?.followDetails?.signalSettings?.signalSuccessFee {
            cell.successFeeTitleLabel.text = "success fee"
            cell.successFeeValueLabel.text = signalSuccessFee.rounded(with: .undefined).toString() + "%"
        }
        
        if let signalVolumeFee = programDetailsFull?.followDetails?.signalSettings?.signalVolumeFee {
            cell.subscriptionFeeTitleLabel.text = "volume fee"
            cell.subscriptionFeeValueLabel.text = signalVolumeFee.rounded(with: .undefined).toString() + "%"
        }
        
        cell.followButton.setTitle("Follow trades", for: .normal)
        cell.followButton.configure(with: .normal)
        
        guard let signalSettings = programDetailsFull?.followDetails?.signalSettings else { return }
        
        let isActive = signalSettings.isActive ?? false
        cell.followButton.setTitle(isActive ? "Unfollow trades" : "Follow trades", for: .normal)
        cell.followButton.configure(with: isActive ? .darkClear : .normal)
    }
}

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
