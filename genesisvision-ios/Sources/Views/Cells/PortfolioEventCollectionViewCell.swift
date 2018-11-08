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
            iconImageView.roundCorners()
        }
    }
    
    @IBOutlet var typeImageView: UIImageView! {
        didSet {
            typeImageView.roundCorners()
        }
    }
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var balanceValueLabel: TitleLabel!
    @IBOutlet var titleLabel: TitleLabel!
    @IBOutlet var dateLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
        roundCorners(with: SystemSizes.cornerSize)
    }
    
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        layer.masksToBounds = true
        layer.cornerRadius = SystemSizes.cornerSize
    }
}
