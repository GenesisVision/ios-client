//
//  DetailStatisticsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 30/06/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

struct DetailStatisticsTableViewCellViewModel {
    let details: Codable?
}

extension DetailStatisticsTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailStatisticsTableViewCell) {
        if let details = details as? ProgramFollowDetailsFull {
            setupProgramFollowDetails(details, cell: cell)
        } else if let details = details as? PrivateTradingAccountFull {
            setupPrivateTradingAccount(details, cell: cell)
        }
    }
    func setupPrivateTradingAccount(_ details: PrivateTradingAccountFull, cell: DetailStatisticsTableViewCell) {
        if let fileName = details.brokerDetails?.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
            cell.brokerLogo.kf.indicatorType = .activity
            cell.brokerLogo.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        } else {
            cell.brokerStackView.isHidden = true
        }
        
        cell.topStackView.removeAllArrangedSubviews()
        cell.bottomStackView.removeAllArrangedSubviews()
        
        if let value = details.tradingAccountInfo?.currency?.rawValue {
            cell.addToStackView(cell.bottomStackView, value: value, header: "currency")
        }
        if let leverage = details.tradingAccountInfo?.leverage {
            cell.addToStackView(cell.bottomStackView, value: "1:\(leverage)", header: "leverage")
        }
        if let creationDate = details.publicInfo?.creationDate {
            let duration = Date().daysSinceDate(fromDate: creationDate)
            cell.addToStackView(cell.bottomStackView, value: duration, header: "age")
        }
    }
    func setupProgramFollowDetails(_ details: ProgramFollowDetailsFull, cell: DetailStatisticsTableViewCell) {
        if let fileName = details.brokerDetails?.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
            cell.brokerLogo.kf.indicatorType = .activity
            cell.brokerLogo.kf.setImage(with: fileUrl, placeholder: UIImage.profilePlaceholder)
        } else {
            cell.brokerStackView.isHidden = true
        }
        cell.topStackView.removeAllArrangedSubviews()
        cell.bottomStackView.removeAllArrangedSubviews()
        
        if let value = details.programDetails?.investmentScale {
            cell.addToStackView(cell.topStackView, value: value.toString(), header: "invest. ratio")
        }
        
        if let value = details.programDetails?.periodDuration {
            cell.addToStackView(cell.topStackView, value: details.tradingAccountInfo?.currency?.rawValue ?? "", header: "currency")
        }
        
        if let brokerName = details.brokerDetails?.name, brokerName == "Genesis Markets" {
            
        }
        
        if let value = details.programDetails?.genesisRatio {
            cell.addToStackView(cell.topStackView, value: value.toString(), header: "genesis ratio")
        }
        
        if let value = details.programDetails?.volumeScale {
            cell.addToStackView(cell.bottomStackView, value: value.toString(), header: "volume scale")
        }
        
        if let min = details.tradingAccountInfo?.leverageMin, let max = details.tradingAccountInfo?.leverageMax, let type = details.brokerDetails?.type, type != .binance {
            cell.addToStackView(cell.bottomStackView, value: (min == max) ? "1:\(min)" : "1:\(min)-1:\(max)", header: "leverage")
        }
        
        if let value = details.programDetails?.ageDays {
            cell.addToStackView(cell.bottomStackView, value: value.toString() + " days", header: "age")
        }
    }
}
