//
//  FilterTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 09/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol FilterTableViewCellProtocol: class {
    func didChangeSwitch(value: Bool)
}

class FilterTableViewCell: UITableViewCell {
    // MARK: - Variables
    weak var delegate: FilterTableViewCellProtocol?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: TitleLabel! {
        didSet {
            titleLabel?.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var detailStackView: UIStackView! {
        didSet {
            detailStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var detailLabel: SubtitleLabel!
    @IBOutlet weak var detailImageView: UIImageView! {
        didSet {
            detailImageView.tintColor = UIColor.Cell.subtitle
        }
    }
    
    @IBOutlet weak var switcher: UISwitch! {
        didSet {
            switcher.isHidden = true
            switcher.onTintColor = UIColor.primary
            switcher.thumbTintColor = UIColor.Cell.switchThumbTint
            switcher.tintColor = UIColor.Cell.switchTint
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
    }
    
    @IBAction func filterSwitchAction(_ sender: UISwitch) {
        delegate?.didChangeSwitch(value: sender.isOn)
    }
}
