//
//  PortfolioAssetTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 06/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class PortfolioAssetTableViewCell: UITableViewCell {

    // MARK: - Variables
    @IBOutlet weak var coloredView: UIView! {
        didSet {
            coloredView.roundCorners(with: 2.0)
            coloredView.isHidden = true
        }
    }
    
    @IBOutlet weak var assetLogoImageView: UIImageView! {
        didSet {
            assetLogoImageView.roundCorners()
            assetLogoImageView.isHidden = true
        }
    }
    
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.textColor = UIColor.Cell.title
            titleLabel.font = UIFont.getFont(.regular, size: 14)
        }
    }
    @IBOutlet weak var balanceLabel: SubtitleLabel! {
        didSet {
            balanceLabel.textColor = UIColor.Cell.subtitle
            balanceLabel.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    @IBOutlet weak var changeValueLabel: TitleLabel! {
        didSet {
            changeValueLabel.textColor = UIColor.Cell.title
            changeValueLabel.font = UIFont.getFont(.semibold, size: 14)
        }
    }
    @IBOutlet weak var changePercentLabel: SubtitleLabel! {
        didSet {
            changePercentLabel.textColor = UIColor.Cell.greenTitle
            changePercentLabel.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
        contentView.backgroundColor = UIColor.Cell.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.Cell.bg
        
        selectionStyle = .none
    }

    // MARK: - Public methods
    func configure() {
        
    }
    
}
