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
            programListCountLabel.textColor = UIColor.Header.title
        }
    }
    
    @IBOutlet var programListTitleLabel: UILabel! {
        didSet {
            programListTitleLabel.textColor = UIColor.Header.subtitle
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
}
