//
//  RatingTableHeaderView.swift
//  genesisvision-ios
//
//  Created by George on 04/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol RatingTableHeaderViewProtocol: class {
    func levelButtonDidTap(_ level: Int)
}

class RatingTableHeaderView: UITableViewHeaderFooterView {
    // MARK: - Outlets
    @IBOutlet var levelButtons: [RatingLevelButton]!
    
    weak var delegate: RatingTableHeaderViewProtocol?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.BaseView.bg
        levelButtons.forEach { (levelButton) in
            levelButton.withBorderColor = true
            levelButton.showProgress = false
            
            if let text = levelButton.titleLabel?.text, let tag = Int(text) {
                levelButton.tag = tag
                if tag == 1 {
                    levelButton.isSelected = true
                    levelButton.isEnabled = false
                }
            } else {
                levelButton.tag = 0
            }
        }
    }
    
    @IBAction func levelButtonsAction(_ sender: RatingLevelButton) {
        levelButtons.forEach { (levelButton) in
            levelButton.isEnabled = true
            levelButton.isSelected = false
        }
        
        sender.isSelected = true
        sender.isEnabled = false
        
        delegate?.levelButtonDidTap(sender.tag)
    }
}
