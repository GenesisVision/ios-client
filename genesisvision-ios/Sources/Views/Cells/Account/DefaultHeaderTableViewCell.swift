//
//  DefaultHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 24.01.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

protocol DefaultHeaderProtocol: class {
    func didTapManageAction(_ assetType: AssetType)
}

class DefaultHeaderTableViewCell: UITableViewCell {
    // MARK: - Variables
    weak var delegate: DefaultHeaderProtocol?
    
    var assetType: AssetType = .program
    var assetId: String?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: LargeTitleLabel!
    @IBOutlet weak var manageButton: UIButton! {
        didSet {
            manageButton.setTitle("Manage", for: .normal)
            manageButton.isHidden = true
            manageButton.tintColor = UIColor.primary
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Actions
    @IBAction func manageButtonAction(_ sender: UIButton) {
        delegate?.didTapManageAction(assetType)
    }
}
