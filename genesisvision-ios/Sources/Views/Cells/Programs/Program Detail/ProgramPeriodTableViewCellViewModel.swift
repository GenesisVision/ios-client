//
//  ProgramPeriodTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 01/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

struct ProgramPeriodTableViewCellViewModel {
    let periodDuration: Int?
    let periodStarts: Date?
    let periodEnds: Date?
}

extension ProgramPeriodTableViewCellViewModel: CellViewModel {
    func setup(on cell: ProgramPeriodTableViewCell) {
        cell.titleLabel.text = "Period"
        
        if let periodEnds = periodEnds, let periodStarts = periodStarts, let periodDuration = periodDuration {
            cell.durationLabel.text = periodEnds.timeSinceDate(fromDate: periodStarts)
            
            let periodLeft = periodEnds.timeSinceDate(fromDate: Date())
            
            cell.periodLeftLabel.text = periodLeft + " left"
            
            let today = Date()
            if let minutes = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate: today).minute {
                cell.progressView.progress = Float(periodDuration - minutes) / Float(periodDuration)
            }
        }
    }
}
