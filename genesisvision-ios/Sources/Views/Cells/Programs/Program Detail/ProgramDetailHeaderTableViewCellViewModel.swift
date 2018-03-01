//
//  ProgramDetailHeaderTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 19.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct ProgramDetailHeaderTableViewCellViewModel {
    let investmentProgramDetails: InvestmentProgramDetails
}

extension ProgramDetailHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailHeaderTableViewCell) {
        if let level = investmentProgramDetails.level {
            cell.programLogoImageView.levelLabel.text = String(describing: level)
        }
        
        cell.programLogoImageView.flagImageView.isHidden = true
        
        if let logo = investmentProgramDetails.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        if let description = investmentProgramDetails.description {
            cell.descriptionLabel.text = description
        }
    }
}

