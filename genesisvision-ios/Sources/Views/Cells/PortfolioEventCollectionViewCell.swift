//
//  PortfolioEventCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/08/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class PortfolioEventCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundWithBorder(2.0, color: UIColor.Cell.bg)
        }
    }
    
    @IBOutlet var typeImageView: UIImageView! {
        didSet {
            typeImageView.roundCorners()
        }
    }
    
    @IBOutlet var stackView: UIStackView! {
        didSet {
            
        }
    }
    
    @IBOutlet var balanceValueLabel: UILabel! {
        didSet {
            balanceValueLabel.font = UIFont.getFont(.bold, size: 27.0)
            balanceValueLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 17.0)
            titleLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.font = UIFont.getFont(.regular, size: 13.0)
            dateLabel.textColor = UIColor.Cell.subtitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
        roundCorners(with: Constants.SystemSizes.cornerSize)
    }

}
