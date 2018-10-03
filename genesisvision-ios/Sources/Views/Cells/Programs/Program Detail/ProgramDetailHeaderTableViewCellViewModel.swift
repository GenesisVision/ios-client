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
    let programDetailsFull: ProgramDetailsFull
    weak var delegate: DetailHeaderTableViewCellProtocol?
}

extension ProgramDetailHeaderTableViewCellViewModel: CellViewModel {
    func setup(on cell: DetailHeaderTableViewCell) {
        if let level = programDetailsFull.level {
            cell.programLogoImageView.levelLabel.text = level.toString()
        }
        
        cell.programLogoImageView.profilePhotoImageView.image = UIImage.placeholder
        
        if let logo = programDetailsFull.logo {
            let logoURL = getFileURL(fileName: logo)
            cell.programLogoImageView.profilePhotoImageView.kf.indicatorType = .activity
            cell.programLogoImageView.profilePhotoImageView.kf.setImage(with: logoURL, placeholder: UIImage.placeholder)
        }
        
        if let title = programDetailsFull.title {
            cell.titleLabel.text = title
        }
        
        if let username = programDetailsFull.manager?.username {
            cell.managerLabel.text = "by " + username
        }
        
        cell.delegate = delegate
    }
}

