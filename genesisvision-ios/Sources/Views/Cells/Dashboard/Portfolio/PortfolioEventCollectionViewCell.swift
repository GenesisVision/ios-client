//
//  PortfolioEventCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/08/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class PortfolioEventCollectionViewCell: BaseCollectionViewCell {

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
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var balanceStackView: UIStackView! {
        didSet {
            balanceStackView.isHidden = true
        }
    }
    @IBOutlet weak var balanceValueLabel: TitleLabel!
    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var dateLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
