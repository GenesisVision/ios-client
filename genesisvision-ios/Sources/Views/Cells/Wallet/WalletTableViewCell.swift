//
//  WalletTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 08/02/2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 16)
        }
    }
    
    @IBOutlet weak var amountLabel: TitleLabel! {
        didSet {
            amountLabel.font = UIFont.getFont(.semibold, size: 14)
        }
    }
    
    @IBOutlet weak var amountCcyLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
