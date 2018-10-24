//
//  PortfolioEventTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

struct PortfolioEventTableViewCellViewModel {
    let dashboardPortfolioEvent: DashboardPortfolioEvent
}

extension PortfolioEventTableViewCellViewModel: CellViewModel {
    func setup(on cell: PortfolioEventTableViewCell) {
        cell.iconImageView.image = UIImage.placeholder
        
        if let fileName = dashboardPortfolioEvent.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.placeholder)
        }
        
        if let type = dashboardPortfolioEvent.type {
            switch type {
            case .profit:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
            case .loss:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_close_period")
            case .withdraw:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_up")
            case .invest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_entry_arrow_down")
            case .all:
                cell.typeImageView.image = nil
            case .reinvest:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_reinvest")
            case .cancelled:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_close_period")
            case .ended:
                cell.typeImageView.image = #imageLiteral(resourceName: "img_end_of_period")
            }
        }
            
        if let title = dashboardPortfolioEvent.description {
            cell.titleLabel.text = title
        }
        
        if let value = dashboardPortfolioEvent.value {
            cell.amountLabel.text = value.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
            cell.amountLabel.textColor = value == 0
                ? UIColor.Cell.subtitle
                : value > 0
                    ? UIColor.Cell.greenTitle
                    : UIColor.Cell.redTitle
        }
        
        if let date = dashboardPortfolioEvent.date {
            cell.dateLabel.text = date.defaultFormatString
        }
    }
}

