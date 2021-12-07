//
//  ManagerSocialTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 03.03.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol ManagerSocialTableViewCellDelegate: AnyObject {
    func followersTapped()
    func followingTapped()
}

class ManagerSocialTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var followrsTitleLabel: SubtitleLabel! {
        didSet {
            followrsTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var followrsCountLabel: TitleLabel! {
        didSet {
            followrsCountLabel.text = "0"
        }
    }
    
    @IBOutlet weak var followingTitleLabel: SubtitleLabel! {
        didSet {
            followingTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var followingCountLabel: TitleLabel! {
        didSet {
            followingCountLabel.text = "0"
        }
    }
    
    weak var delegate: ManagerSocialTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func followersButtonAction(_ sender: Any) {
        delegate?.followersTapped()
    }
    
    @IBAction func followingButtonAction(_ sender: Any) {
        delegate?.followingTapped()
    }
}
