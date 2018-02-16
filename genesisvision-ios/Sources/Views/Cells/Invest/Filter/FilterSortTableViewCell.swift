//
//  FilterSortTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FilterSortTableViewCell: UITableViewCell {

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tintColor = UIColor.primary
    }
    
}
