//
//  DetailManagerTableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 10/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol DetailManagerTableViewCellDelegate: AnyObject {
    func followPressed(userId: UUID, followed: Bool)
}

class DetailManagerTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var managerImageView: UIImageView! {
        didSet {
            managerImageView.roundCorners()
            managerImageView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var managerNameLabel: UILabel! {
        didSet {
            managerNameLabel.textColor = UIColor.Cell.title
            managerNameLabel.font = UIFont.getFont(.semibold, size: 14.0)
            managerNameLabel.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = UIColor.Cell.subtitle
            dateLabel.font = UIFont.getFont(.semibold, size: 12.0)
            dateLabel.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var followButton: ActionButton!
    
    var userId: UUID? {
        didSet {
            let profileId = UserDefaults.standard.string(forKey: UserDefaultKeys.profileID)
            if userId?.uuidString == profileId {
                followButton.isEnabled = false
                followButton.isHidden = true
            }
        }
    }
    var followed: Bool?
    weak var delegate: DetailManagerTableViewCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
        isUserInteractionEnabled = true
        //MARK: - Скрыл кнопку подписаться
//        if isAuthor {
//            followButton.isEnabled = false
//            followButton.isHidden = true
//        }
    }
    
    @IBAction func followButtonAction(_ sender: Any) {
        guard let userId = userId, let followed = followed else { return }
        delegate?.followPressed(userId: userId, followed: followed)
        
        if followed {
            followButton.setTitle("Follow", for: .normal)
            followButton.configure(with: .normal)
        } else {
            followButton.setTitle("Unfollow", for: .normal)
            followButton.configure(with: .darkClear)
        }
        
        self.followed = !followed
    }
}

class DetailTradingAccountTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: SubtitleLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
}
