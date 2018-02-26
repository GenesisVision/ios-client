//
//  ProfileHeaderTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol ProfileHeaderTableViewCellDelegate: class {
    func chooseProfilePhotoCellDidPressOnPhoto(_ cell: ProfileHeaderTableViewCell)
}

class ProfileHeaderTableViewCell: UITableViewCell {

    // MARK: - Variables
    weak var delegate: ProfileHeaderTableViewCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!
    
    // MARK: - Views
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: - Buttons
    @IBOutlet var chooseProfilePhotoButton: ChooseProfilePhotoButton!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        selectionStyle = .none
    }
    
    // MARK: - Public Methods
    func hideLabel(value: Bool) {
        nameLabelHeightConstraint.constant = value ? 0.0 : 30.0
        nameLabelTopConstraint.constant = value ? 0.0 : 16.0
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    @IBAction func chooseButtonAction(_ sender: Any) {
        delegate?.chooseProfilePhotoCellDidPressOnPhoto(self)
    }
    
}
