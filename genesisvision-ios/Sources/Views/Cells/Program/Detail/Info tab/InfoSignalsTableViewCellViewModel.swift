//
//  InfoSignalsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 20/02/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum InfoSignalType {
    case signal, subscription
}

struct InfoSignalsTableViewCellViewModel {
    let programDetailsFull: ProgramDetailsFull?
    let type: InfoSignalType
    weak var infoSignalsProtocol: InfoSignalsProtocol?
}

extension InfoSignalsTableViewCellViewModel: CellViewModel {
    func setup(on cell: InfoSignalsTableViewCell) {
        cell.infoSignalsProtocol = infoSignalsProtocol
        
        cell.titleLabel.text = type == .subscription ? "Subscription details" : "Signals"
        
        cell.followButton.isHidden = type == .subscription
        cell.signalStackView.isHidden = type == .subscription
        
        cell.editButton.isHidden = type == .signal
        cell.subscriptionStackView.isHidden = type == .signal
        
        if type == .subscription, let signalSubscription = programDetailsFull?.personalProgramDetails?.signalSubscription {
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
        } else {
            if let signalSuccessFee = programDetailsFull?.signalSuccessFee {
                cell.successFeeTitleLabel.text = "success fee"
                cell.successFeeValueLabel.text = signalSuccessFee.rounded(with: .undefined).toString() + "%"
            }
            
            if let signalSubscriptionFee = programDetailsFull?.signalVolumeFee {
                cell.subscriptionFeeTitleLabel.text = "volume fee"
                cell.subscriptionFeeValueLabel.text = signalSubscriptionFee.rounded(with: .undefined).toString() + "%"
            }
        }
        
        cell.followButton.setTitle("Follow trades", for: .normal)
        cell.followButton.configure(with: .normal)
        
        guard let signalSubscription = programDetailsFull?.personalProgramDetails?.signalSubscription else { return }
        
        let hasActiveSubscription = signalSubscription.hasActiveSubscription ?? false
        cell.followButton.setTitle(hasActiveSubscription ? "Unfollow trades" : "Follow trades", for: .normal)
        cell.followButton.configure(with: hasActiveSubscription ? .darkClear : .normal)
    }
}
