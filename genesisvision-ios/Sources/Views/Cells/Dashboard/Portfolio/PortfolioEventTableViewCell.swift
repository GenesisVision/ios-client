//
//  PortfolioEventTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 10/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class PortfolioEventTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var typeImageView: UIImageView! {
        didSet {
            typeImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var dateLabel: SubtitleLabel!
    @IBOutlet weak var amountLabel: TitleLabel! {
        didSet {
            amountLabel.font = UIFont.getFont(.semibold, size: 12.0)
        }
    }
    
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
