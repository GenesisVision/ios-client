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
    
    override var isHighlighted: Bool {
        didSet {
            guard cellAnimations else { return }
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.alpha = self.isHighlighted ? 0.8 : 1
                self.titleLabel.alpha = self.isHighlighted ? 0.7 : 1
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
