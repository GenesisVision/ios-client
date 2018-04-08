//
//  ProgramDetailsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramDetailsTableViewCell: UITableViewCell {

    // MARK: - Views
    @IBOutlet var programDetailsView: ProgramDetailsForTableViewCellView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.NavBar.grayBackground
        selectionStyle = .none
    }
}
