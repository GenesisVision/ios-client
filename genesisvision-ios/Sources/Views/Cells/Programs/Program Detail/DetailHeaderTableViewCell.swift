//
//  DetailHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol DetailHeaderTableViewCellProtocol: class {
    func showDescriptionDidPress()
}

class DetailHeaderTableViewCell: UITableViewCell {

    // MARK: - Variables
    weak var delegate: DetailHeaderTableViewCellProtocol?
    
    // MARK: - Views
    @IBOutlet var programLogoImageView: ProfileImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var managerLabel: UILabel!
    @IBOutlet var currencyLabel: CurrencyLabel!
    
    // MARK: - Buttons
    @IBOutlet weak var descriptionButton: UIButton! {
        didSet {
            descriptionButton.isHidden = true
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func descriptionButtonAction(_ sender: Any) {
        delegate?.showDescriptionDidPress()
    }
}
