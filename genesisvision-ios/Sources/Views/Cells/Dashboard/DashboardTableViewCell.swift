//
//  DashboardTableViewCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 27.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol DashboardTableViewCellProtocol: class {
    func investProgramDidPress()
    func withdrawProgramDidPress()
}

class DashboardTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    weak var delegate: DashboardTableViewCellProtocol?
    
    // MARK: - Buttons
    @IBOutlet weak var investButton: ActionButton!
    @IBOutlet weak var withdrawButton: ActionButton!
    
    // MARK: - Views
    @IBOutlet var managerAvatarImageView: UIImageView!
    @IBOutlet var programLogoImageView: ProfileImageView!
    
    // MARK: - Labels
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var tokensCountLabel: UILabel!
    @IBOutlet var profitLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.Background.main
        contentView.backgroundColor = UIColor.Background.main
    }
    
    // MARK: - Actions
    @IBAction func investButtonAction(_ sender: Any) {
        delegate?.investProgramDidPress()
    }
    
    @IBAction func withdrawButtonAction(_ sender: Any) {
        delegate?.withdrawProgramDidPress()
    }
}
