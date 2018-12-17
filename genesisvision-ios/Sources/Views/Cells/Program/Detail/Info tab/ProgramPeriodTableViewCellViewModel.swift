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
        
        if let periodEnds = periodEnds, let periodStarts = periodStarts {
            let periodEndDate = periodStarts.addDays(periodDuration ?? 0)
            let duration = periodEndDate.daysSinceDate(fromDate: periodStarts)
            cell.durationLabel.text = duration
            
            
            let today = Date()
            let periodLeft = periodEnds.daysSinceDate(fromDate: today)
            
            cell.periodLeftLabel.text = periodLeft.isEmpty ? "The period is over" : periodLeft + " left"
            
            if let periodDuration = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate:periodStarts).minute, let minutes = periodEnds.getDateComponents(ofComponent: Calendar.Component.minute, fromDate: today).minute {
                cell.progressView.progress = Float(periodDuration - minutes) / Float(periodDuration)
            }
        }
    }
}
