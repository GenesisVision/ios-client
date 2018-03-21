//
//  FilterSortTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FilterSortTableViewCell: UITableViewCell {

    // MARK: - Labels
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.regular, size: 16)
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.Background.main
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
