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
    @IBOutlet var stackedProgressView: StackedProgressView!
    @IBOutlet var availableTokensTooltip: TooltipButton! {
        didSet {
            availableTokensTooltip.tooltipText = String.Tooltitps.availableTokens
        }
    }
    
    weak var programPropertiesForTableViewCellViewProtocol: ProgramPropertiesForTableViewCellViewProtocol? {
        didSet {
            programPropertiesView.delegate = programPropertiesForTableViewCellViewProtocol
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
    deinit {
        programPropertiesView.stopTimer()
    }
}
