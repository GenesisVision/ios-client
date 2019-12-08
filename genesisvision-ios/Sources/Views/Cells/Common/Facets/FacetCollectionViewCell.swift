//
//  FacetCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 19/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FacetCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.isHidden = true
            iconImageView.tintColor = UIColor.primary
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var titleLabel: TitleLabel!
    @IBOutlet weak var detailLabel: SubtitleLabel! {
        didSet {
            detailLabel.isHidden = true
            detailLabel.textColor = UIColor.primary
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
