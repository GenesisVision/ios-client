//
//  DashboardSignalTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/05/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct SignalTableViewCellViewModel {
    let signal: SignalDetails
    weak var reloadDataProtocol: ReloadDataProtocol?
    weak var delegate: FavoriteStateChangeProtocol?
}

extension SignalTableViewCellViewModel: CellViewModel {
    func setup(on cell: SignalTableViewCell) {
        cell.delegate = delegate
        cell.stackView.spacing = 24
        
        if let title = signal.title {
            cell.titleLabel.text = title
        }
        
        if let managerName = signal.manager?.username {
            cell.managerNameLabel.text = "by " + managerName
        }
        
        if let programId = signal.id?.uuidString {
            cell.assetId = programId
        }
        
        if let level = signal.level {
            cell.assetLogoImageView.levelButton.setTitle(level.toString(), for: .normal)
        }
        
        if let levelProgress = signal.levelProgress {
            cell.assetLogoImageView.levelButton.progress = levelProgress
        }
        
        if let currency = signal.currency {
            cell.currencyLabel.text = currency.rawValue
        }
        
        cell.firstTitleLabel.text = "trades"
        if let tradesCount = signal.personalDetails?.tradesCount {
            cell.firstValueLabel.text = tradesCount.toString()
        } else {
            cell.firstValueLabel.text = ""
        }
        
        cell.secondTitleLabel.text = "subscribers"
        if let subscribers = signal.subscribers {
            cell.secondValueLabel.text = subscribers.toString()
        } else {
            cell.secondValueLabel.text = ""
        }
        
        cell.thirdTitleLabel.text = "start date"
        if let subscriptionDate = signal.personalDetails?.subscriptionDate {
            cell.thirdValueLabel.text = subscriptionDate.dateAndTimeToString()
        } else {
            cell.thirdValueLabel.text = ""
        }
        
        if let color = signal.color {
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = UIColor.hexColor(color)
        }
        
        cell.assetLogoImageView.profilePhotoImageView.image = UIImage.programPlaceholder
        
        if let logo = signal.logo, let fileUrl = getFileURL(fileName: logo) {
            cell.assetLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.assetLogoImageView.profilePhotoImageView.kf.setImage(with: fileUrl, placeholder: UIImage.programPlaceholder)
            cell.assetLogoImageView.profilePhotoImageView.backgroundColor = .clear
        }
        
        if let profitPercent = signal.personalDetails?.profit {
            let sign = profitPercent > 0 ? "+" : ""
            cell.profitPercentLabel.text = sign + profitPercent.rounded(withType: .undefined).toString() + "%"
            cell.profitPercentLabel.textColor = profitPercent == 0 ? UIColor.Cell.title : profitPercent > 0 ? UIColor.Cell.greenTitle : UIColor.Cell.redTitle
        }
        
        if let status = signal.personalDetails?.status {
            cell.statusButton.handleUserInteractionEnabled = false
            cell.statusButton.setTitle(status.rawValue, for: .normal)
            cell.statusButton.layoutSubviews()
        }
    }
}

