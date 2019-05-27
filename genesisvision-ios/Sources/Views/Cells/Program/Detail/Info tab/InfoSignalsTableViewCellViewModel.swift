//
//  InfoSignalsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 20/02/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct InfoSignalsTableViewCellViewModel {
    let programDetailsFull: ProgramDetailsFull?
    weak var infoSignalsProtocol: InfoSignalsProtocol?
}

extension InfoSignalsTableViewCellViewModel: CellViewModel {
    func setup(on cell: InfoSignalsTableViewCell) {
        cell.titleLabel.text = "Signals"
        cell.infoSignalsProtocol = infoSignalsProtocol
        
        if let personalProgramDetails = programDetailsFull?.personalProgramDetails, let hasActiveSubscription = personalProgramDetails.signalSubscription?.hasActiveSubscription {
            cell.editButton.isHidden = !hasActiveSubscription
            cell.followButton.setTitle(hasActiveSubscription ? "Unfollow trades" : "Follow trades", for: .normal)
        }
        
        if let signalSuccessFee = programDetailsFull?.signalSuccessFee {
            cell.successFeeTitleLabel.text = "success fee"
            cell.successFeeValueLabel.text = signalSuccessFee.rounded(withType: .undefined).toString() + "%"
        }

        if let signalSubscriptionFee = programDetailsFull?.signalVolumeFee {
            cell.subscriptionFeeTitleLabel.text = "volume fee"
            cell.subscriptionFeeValueLabel.text = signalSubscriptionFee.rounded(withType: .undefined).toString() + "%"
        }
        
    }
}
