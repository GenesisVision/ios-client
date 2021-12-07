//
//  SocialManagerInfoAboutTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 02.12.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct SocialManagerInfoAboutTableViewCellViewModel {
    let title: String
    let subtitle: String
}

extension SocialManagerInfoAboutTableViewCellViewModel: CellViewModel {
    func setup(on cell: SocialManagerInfoAboutTableViewCell) {
        cell.titleLabel.text = title
        cell.subtitleLabel.text = subtitle
    }
}

class SocialManagerInfoAboutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: SubtitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var subtitleLabel: TitleLabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.regular, size: 14.0)
            subtitleLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
