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
    let isFollowed: Bool?
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
        
        guard let isFollowed = isFollowed else { return }
        cell.followButton.setTitle(isFollowed ? "Unfollow trades" : "Follow trades", for: .normal)
        cell.followButton.configure(with: isFollowed ? .darkClear : .normal)
    }
}
