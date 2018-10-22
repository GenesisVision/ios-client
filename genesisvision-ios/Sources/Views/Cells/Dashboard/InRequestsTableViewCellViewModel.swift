//
//  InRequestsTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 25/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

struct InRequestsTableViewCellViewModel {
    let programRequest: ProgramRequest
}

extension InRequestsTableViewCellViewModel: CellViewModel {
    func setup(on cell: InRequestsTableViewCell) {
        if let title = programRequest.title {
            cell.titleLabel.text = title
        }
        
        cell.iconImageView.image = UIImage.programPlaceholder
        
        if let fileName = programRequest.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
        }
        
        if let type = programRequest.type {
            switch type {
            case .invest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
            case .withdrawal:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_down")
            }
        }
        
        if let status = programRequest.status {
            cell.statusLabel.text = status.rawValue
        }
        
        if let value = programRequest.value {
            cell.amountValueLabel.text = value.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        }
        
        if let date = programRequest.date {
            cell.dateLabel.text = date.dateAndTimeFormatString
        }
    }
}
