//
//  FilterSortTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 31.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class FilterSortTableViewCell: UITableViewCell {

    let picker = UIPickerView()
    
    // MARK: - Labels
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        }
    }
    
    // MARK: - Views
    @IBOutlet var arrowImageView: UIImageView! {
        didSet {
            arrowImageView.image = #imageLiteral(resourceName: "img_dropdown_icon")
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        contentView.backgroundColor = UIColor.Background.main
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tintColor = UIColor.primary
    }
    

    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override var canResignFirstResponder: Bool {
        return true
    }
    
    open override var inputView: UIView? {
        return picker
    }
    
}
