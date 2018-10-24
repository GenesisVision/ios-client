//
//  PortfolioEventCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 20/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct PortfolioEventCollectionViewCellViewModel {
    weak var reloadDataProtocol: ReloadDataProtocol?
    let dashboardPortfolioEvent: DashboardPortfolioEvent
}

extension PortfolioEventCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: PortfolioEventCollectionViewCell) {
        if let title = dashboardPortfolioEvent.description {
            cell.titleLabel.text = title
        }
        
        if let value = dashboardPortfolioEvent.value {
            cell.balanceValueLabel.text = value.rounded(withType: .gvt).toString() + " \(Constants.gvtString)"
        }
        
        if let date = dashboardPortfolioEvent.date {
            cell.dateLabel.text = date.dateAndTimeFormatString
        }
        
        cell.iconImageView.image = UIImage.eventPlaceholder
        
        if let fileName = dashboardPortfolioEvent.logo, let fileUrl = getFileURL(fileName: fileName) {
            cell.iconImageView.kf.indicatorType = .activity
            cell.iconImageView.kf.setImage(with: fileUrl, placeholder: UIImage.eventPlaceholder)
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
    }
}

