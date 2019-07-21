//
//  SignalTradingLogTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 21/07/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

struct SignalTradingLogTableViewCellViewModel {
    let event: SignalTradingEvent
}

extension SignalTradingLogTableViewCellViewModel: CellViewModel {
    func setup(on cell: SignalTradingLogTableViewCell) {
        if let message = event.message {
            cell.titleLabel.text = message
        }
        
        if let date = event.date {
            cell.dateLabel.text = date.dateAndTimeToString()
        }
    }
}

