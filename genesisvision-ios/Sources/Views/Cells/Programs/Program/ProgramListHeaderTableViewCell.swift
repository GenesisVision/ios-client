//
//  ProgramListHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 21/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramListHeaderTableViewCell: UITableViewCell {

    // MARK: - Labels
    @IBOutlet var programListCountLabel: UILabel! {
        didSet {
            programListCountLabel.textColor = UIColor.Header.darkTitle
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.Background.darkGray
        selectionStyle = .none
    }
    
}
