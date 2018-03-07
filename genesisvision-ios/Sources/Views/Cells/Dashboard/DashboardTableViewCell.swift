//
//  DashboardTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol DashboardTableViewCellProtocol: class {
    func investProgramDidPress(with investmentProgramId: String)
    func withdrawProgramDidPress(with investmentProgramId: String)
}

class DashboardTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    weak var delegate: DashboardTableViewCellProtocol?
    var investmentProgramId: String = ""
    
    // MARK: - Buttons
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var investButton: ActionButton!
    @IBOutlet weak var withdrawButton: ActionButton!
    
    // MARK: - Views
    @IBOutlet var managerAvatarImageView: UIImageView! {
        didSet {
            managerAvatarImageView.roundCorners()
            managerAvatarImageView.addBorder(withBorderWidth: 2.0)
        }
    }
    
    @IBOutlet var programLogoImageView: ProfileImageView! {
        didSet {
            programLogoImageView.profilePhotoImageView.addBorder(withBorderWidth: 2.0)
        }
    }
    
    // MARK: - Labels
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tokensCountLabel: UILabel!
    @IBOutlet var profitLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var periodLeftValueLabel: UILabel!
    @IBOutlet var periodLeftTitleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        contentView.backgroundColor = UIColor.Background.main
    }
    
    // MARK: - Actions
    @IBAction func investButtonAction(_ sender: Any) {
        delegate?.investProgramDidPress(with: investmentProgramId)
    }
    
    @IBAction func withdrawButtonAction(_ sender: Any) {
        delegate?.withdrawProgramDidPress(with: investmentProgramId)
    }
}
