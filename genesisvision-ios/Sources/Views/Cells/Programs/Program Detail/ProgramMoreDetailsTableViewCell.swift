//
//  ProgramMoreDetailsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramMoreDetailsTableViewCell: UITableViewCell {

    // MARK: - Views
    @IBOutlet var programPropertiesView: ProgramPropertiesForTableViewCellView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
        contentView.backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
    
}
