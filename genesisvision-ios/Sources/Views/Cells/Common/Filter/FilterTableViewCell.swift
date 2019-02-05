//
//  FilterTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 09/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel?.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var detailLabel: SubtitleLabel!
    @IBOutlet weak var detailImageView: UIImageView! {
        didSet {
            detailImageView.tintColor = UIColor.Cell.subtitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
    }
}
