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
        
        if let color = programRequest.color {
            cell.iconImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        if let fileName = programRequest.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
        }
        
        if let type = programRequest.type {
            switch type {
            case .invest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
                cell.statusLabel.text = "Invest"
                cell.amountValueLabel.text = "-"
            case .withdrawal:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_down")
                cell.statusLabel.text = "Withdraw"
                cell.amountValueLabel.text = "+"
            }
            
            if let value = programRequest.value {
                let text = cell.amountValueLabel.text ?? ""
                cell.amountValueLabel.text = text + value.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
            }
        }
        
//        if let status = programRequest.status {
//            cell.statusLabel.text = status.rawValue
//        }
        
        if let date = programRequest.date {
            cell.dateLabel.text = date.onlyDateFormatString
        }
    }
}
