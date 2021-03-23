//
//  SocialFollowListTableViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 03.03.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialFollowListTableViewCellDelegate: class {
    func followPressed(userId: UUID, followed: Bool)
}

struct SocialFollowListTableViewCellViewModel {
    let follow: ProfilePublicShort
    weak var delegate: SocialFollowListTableViewCellDelegate?
}

extension SocialFollowListTableViewCellViewModel: CellViewModel {
    func setup(on cell: SocialFollowListTableViewCell) {
        cell.delegate = delegate
        
        if let userId = follow._id {
            cell.userId = userId
        }
        
        if let logo = follow.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            cell.userImageView.kf.indicatorType = .activity
            cell.userImageView.kf.setImage(with: fileUrl)
        } else {
            cell.userImageView.image = UIImage.profilePlaceholder
        }
        
        if let userName = follow.username {
            cell.usernameLabel.text = userName
        }
        
        if let followed = follow.personalDetails?.isFollow, followed {
            cell.followButton.setTitle("Unfollow", for: .normal)
            cell.followButton.configure(with: .darkClear)
        }
        
        cell.followed = follow.personalDetails?.isFollow
    }
}

class SocialFollowListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.backgroundColor = .clear
            userImageView.contentMode = .scaleAspectFill
            userImageView.image = UIImage.profilePlaceholder
            userImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var usernameLabel: TitleLabel!
    
    @IBOutlet weak var followButton: ActionButton!
    
    weak var delegate: SocialFollowListTableViewCellDelegate?
    var userId: UUID?
    var followed: Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        tintColor = .clear
        accessoryView?.backgroundColor = .clear
        
        selectionStyle = .none
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
