//
//  ProgramStrategyTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramStrategyTableViewCellViewModel {
    var descriptionText: String?
}

extension ProgramStrategyTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramStrategyTableViewCell) {
        cell.titleLabel.text = "Strategy"
        
        if let descriptionText = descriptionText {
            cell.descriptionLabel.text = descriptionText
        }
    }
}
