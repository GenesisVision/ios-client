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
        
        if let periodDuration = periodDuration {
            cell.durationLabel.text = periodDuration.toString()
            
            if let periodEnds = periodEnds {
                let today = Date()
                let daysLeft = today.interval(ofComponent: Calendar.Component.day, fromDate: periodEnds)
                
                cell.periodLeftLabel.text = daysLeft.toString()
                cell.progressView.progress = Float((periodDuration - daysLeft) / periodDuration)
            }
        }
    }
}
