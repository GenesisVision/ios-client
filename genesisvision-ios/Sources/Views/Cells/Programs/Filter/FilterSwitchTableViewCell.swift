//
//  FilterSwitchTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 26/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol FilterSwitchTableViewCellProtocol: class {
    func switchControl(_ sender: UISwitch!, didChangeSelectedValue: Bool)
}

class FilterSwitchTableViewCell: PlateTableViewCell {

    weak var delegate: FilterSwitchTableViewCellProtocol?
    
    // MARK: - Labels
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.getFont(.bold, size: 18)
        }
    }
    
    @IBOutlet var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = UIFont.getFont(.regular, size: 14)
        }
    }
    
    // MARK: - Views
    @IBOutlet var switchControl: UISwitch!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
    
    // MARK: - Private methods
    private func setupUI() {
        switchControl.tintColor = UIColor.primary
        switchControl.onTintColor = UIColor.primary
        
        switchControl.addTarget(self, action: #selector(stateChanged(_:)), for: .valueChanged)
        
        contentView.backgroundColor = UIColor.Cell.bg
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @objc func stateChanged(_ switchControl: UISwitch) {
        delegate?.switchControl(switchControl, didChangeSelectedValue: switchControl.isOn)
    }
}
