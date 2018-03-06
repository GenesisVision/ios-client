//
//  WalletFilterTypeTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 06.03.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol WalletFilterTypeTableViewCellProtocol: class {
    func segmentControlDidChanged(index: Int)
}

class WalletFilterTypeTableViewCell: UITableViewCell {

    // MARK: - Variables
    weak var delegate: WalletFilterTypeTableViewCellProtocol?
    
    // MARK: - Views
    @IBOutlet var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.tintColor = UIColor.primary
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        contentView.backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
    
    // MARK: - Private methods
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.segmentControlDidChanged(index: sender.selectedSegmentIndex)
    }
}
