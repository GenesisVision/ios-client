//
//  RatingTableHeaderView.swift
//  genesisvision-ios
//
//  Created by George on 04/12/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol RatingTableHeaderViewProtocol: AnyObject {
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
            }
        }
    }
    
    @IBAction func levelButtonsAction(_ sender: RatingLevelButton) {
        levelButtons.forEach { (levelButton) in
            if levelButton == sender {
                levelButton.isSelected = !levelButton.isSelected
            } else {
                levelButton.isSelected = false
            }
        }
        
        delegate?.levelButtonDidTap(sender.tag)
    }
}
