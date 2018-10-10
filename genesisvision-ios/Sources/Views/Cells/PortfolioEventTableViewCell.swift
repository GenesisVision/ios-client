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
    
    @IBOutlet var titleLabel: TitleLabel!
    @IBOutlet var dateLabel: SubtitleLabel!
    @IBOutlet var amountLabel: SubtitleLabel! {
        didSet {
            amountLabel.textColor = UIColor.Cell.greenTitle
        }
    }
    
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.BaseView.bg
    }}
