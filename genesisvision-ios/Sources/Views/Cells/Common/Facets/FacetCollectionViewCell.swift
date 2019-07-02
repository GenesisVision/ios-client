//
//  FacetCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 19/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FacetCollectionViewCell: UICollectionViewCell {
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
    
    override var isHighlighted: Bool {
        didSet {
            guard cellAnimations else { return }
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.alpha = self.isHighlighted ? 0.8 : 1
                self.transform = self.isHighlighted ? self.transform.scaledBy(x: 0.96, y: 0.96) : .identity
            }, completion: nil)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
        roundCorners(with: Constants.SystemSizes.cornerSize)
    }
    
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        layer.masksToBounds = true
        layer.cornerRadius = Constants.SystemSizes.cornerSize
    }
}
