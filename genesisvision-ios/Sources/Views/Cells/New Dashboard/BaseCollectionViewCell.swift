//
//  BaseCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by George on 04.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
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
}
