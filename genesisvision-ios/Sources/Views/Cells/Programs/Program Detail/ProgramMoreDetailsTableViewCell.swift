//
//  ProgramMoreDetailsTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 01.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ProgramMoreDetailsTableViewCell: PlateTableViewCell {

    // MARK: - Views
    @IBOutlet var programPropertiesView: ProgramPropertiesForTableViewCellView!
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
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    deinit {
        programPropertiesView.stopTimer()
    }
}
