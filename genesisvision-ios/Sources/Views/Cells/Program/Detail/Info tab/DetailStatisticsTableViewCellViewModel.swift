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
        } else {
            cell.brokerStackView.isHidden = true
        }
        
        if let value = programDetailsFull.programDetails?.periodDuration {
            cell.topStackView.isHidden = false
            cell.periodLabel.text = value.toString() + " d"
        } else {
            cell.periodStackView.isHidden = true
        }
        if let value = programDetailsFull.programDetails?.ageDays {
            cell.topStackView.isHidden = false
            cell.ageLabel.text = value.toString() + " d"
        } else {
            cell.ageStackView.isHidden = true
        }
        if let value = programDetailsFull.programDetails?.genesisRatio {
            cell.topStackView.isHidden = false
            cell.wpdLabel.text = value.toString()
        } else {
            cell.wpdStackView.isHidden = true
        }
        if let value = programDetailsFull.programDetails?.investmentScale {
            cell.bottomStackView.isHidden = false
            cell.investmentScaleLabel.text = value.toString()
        } else {
            cell.investmentScaleStackView.isHidden = true
        }
        if let value = programDetailsFull.programDetails?.volumeScale {
            cell.bottomStackView.isHidden = false
            cell.volumeLabel.text = value.toString()
        } else {
            cell.volumeStackView.isHidden = true
        }
        if let min = programDetailsFull.tradingAccountInfo?.leverageMin, let max = programDetailsFull.tradingAccountInfo?.leverageMax {
            cell.bottomStackView.isHidden = false
            cell.leverageLabel.text = (min == max) ? "1:\(min)" : "1:\(min)-1:\(max)"
        } else {
            cell.leverageStackView.isHidden = true
        }
    }
}
