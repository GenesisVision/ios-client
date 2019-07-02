//
//  DetailStatisticsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 30/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct DetailStatisticsTableViewCellViewModel {
    let programDetailsFull: ProgramDetailsFull?
}

extension DetailStatisticsTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailStatisticsTableViewCell) {
        guard let programDetailsFull = programDetailsFull else { return }
        
        if let fileName = programDetailsFull.brokerDetails?.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.brokerLogo.kf.indicatorType = .activity
            cell.brokerLogo.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
        
        if let value = programDetailsFull.periodDuration {
            cell.periodLabel.text = value.toString() + " d"
        }
        if let value = programDetailsFull.ageDays {
            cell.ageLabel.text = value.toString() + " d"
        }
        if let value = programDetailsFull.genesisRatio {
            cell.wpdLabel.text = value.toString()
        }
        if let value = programDetailsFull.investmentScale {
            cell.investmentScaleLabel.text = value.toString()
        }
        if let value = programDetailsFull.volumeScale {
            cell.volumeLabel.text = value.toString()
        }
        if let min = programDetailsFull.leverageMin, let max = programDetailsFull.leverageMax {
            cell.leverageLabel.text = "\(min):\(max)"
        }
    }
}
