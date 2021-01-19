//
//  SocialUsersListTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 14.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct SocialUsersListTableViewCellViewModel {
    let user: UserDetailsList
}

extension SocialUsersListTableViewCellViewModel: CellViewModel {
    
    func setup(on cell: SocialUsersListTableViewCell) {
        if let logo = user.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            cell.userImageView.kf.indicatorType = .activity
            cell.userImageView.kf.setImage(with: fileUrl)
        } else {
            cell.userImageView.image = UIImage.profilePlaceholder
        }
        
        if let userName = user.username {
            cell.userNameLabel.text = userName
        }
        
        if let userStatus = user.about {
            cell.userStatusLabel.text = userStatus
        }
        
        if let age = user.regDate {
            cell.periodLabel.text = age.dateForSocialUserAge
        }
        
        if let aum = user.totalProfit {
            cell.profitLabel.text = String(aum) + "$"
        }
        
        if let followersCount = user.followersCount {
            cell.followersCountLabel.text = String(followersCount)
        }
        
        if let investorsCount = user.investorsCount {
            cell.investorsCountLabel.text = String(investorsCount)
        }
        
        if let followed = user.personalDetails?.isFollow, followed {
            cell.followButton.setTitle("Unfollow", for: .normal)
        }
    }
}


class SocialUsersListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.backgroundColor = .clear
            userImageView.contentMode = .scaleAspectFill
            userImageView.image = UIImage.profilePlaceholder
            userImageView.roundCorners()
        }
    }
    
    @IBOutlet weak var userNameLabel: TitleLabel! {
        didSet {
            userNameLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    
    @IBOutlet weak var userStatusLabel: SubtitleLabel! {
        didSet {
            userStatusLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var periodLabel: TitleLabel! {
        didSet {
            periodLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    
    @IBOutlet weak var profitLabel: TitleLabel! {
        didSet {
            profitLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    
    @IBOutlet weak var ageLabel: SubtitleLabel! {
        didSet {
            ageLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var aumLabel: SubtitleLabel! {
        didSet {
            aumLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var followersLabel: SubtitleLabel! {
        didSet {
            followersLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var investorsLabel: SubtitleLabel! {
        didSet {
            investorsLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var followersCountLabel: TitleLabel! {
        didSet {
            followersCountLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    
    @IBOutlet weak var investorsCountLabel: TitleLabel! {
        didSet {
            investorsCountLabel.font = UIFont.getFont(.semibold, size: 14.0)
        }
    }
    
    @IBOutlet weak var followButton: ActionButton!
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            let bottomLineView = UIView()
            bottomLineView.backgroundColor = UIColor.Common.darkCell
            bottomLineView.translatesAutoresizingMaskIntoConstraints = false
            bottomView.addSubview(bottomLineView)
            
            bottomLineView.anchor(top: nil, leading: bottomView.leadingAnchor, bottom: bottomView.bottomAnchor, trailing: bottomView.trailingAnchor, size: CGSize(width: 0, height: 1.5))
        }
    }
    
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
    }
}
