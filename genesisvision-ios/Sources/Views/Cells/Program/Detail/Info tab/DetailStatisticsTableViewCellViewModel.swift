//
//  DetailStatisticsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 30/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct DetailStatisticsTableViewCellViewModel {
    let programFollowDetailsFull: ProgramFollowDetailsFull?
}

extension DetailStatisticsTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailStatisticsTableViewCell) {
        guard let programDetailsFull = programFollowDetailsFull else { return }
        
        if let fileName = programDetailsFull.brokerDetails?.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.brokerLogo.kf.indicatorType = .activity
            cell.brokerLogo.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        }
        
        if let value = programDetailsFull.programDetails?.periodDuration {
            cell.periodLabel.text = value.toString() + " d"
        }
        if let value = programDetailsFull.programDetails?.ageDays {
            cell.ageLabel.text = value.toString() + " d"
        }
        if let value = programDetailsFull.programDetails?.genesisRatio {
            cell.wpdLabel.text = value.toString()
        }
        if let value = programDetailsFull.programDetails?.investmentScale {
            cell.investmentScaleLabel.text = value.toString()
        }
        if let value = programDetailsFull.programDetails?.volumeScale {
            cell.volumeLabel.text = value.toString()
        }
        if let min = programDetailsFull.tradingAccountInfo?.leverageMin, let max = programDetailsFull.tradingAccountInfo?.leverageMax {
            cell.leverageLabel.text = (min == max) ? "1:\(min)" : "1:\(min)-1:\(max)"
        }
    }
}
