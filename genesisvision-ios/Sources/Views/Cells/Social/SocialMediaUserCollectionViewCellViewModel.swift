//
//  SocialMediaUserCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 14.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct SocialMediaUserCollectionViewCellViewModel {
    let user: UserDetailsList
}

extension SocialMediaUserCollectionViewCellViewModel: CellViewModel {
    
    func setup(on cell: SocialMediaUserCollectionViewCell) {
        
        if let logo = user.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            cell.userImageView.kf.indicatorType = .activity
            cell.userImageView.kf.setImage(with: fileUrl)
        } else {
            cell.userImageView.image = UIImage.profilePlaceholder
        }
        
        if let userName = user.username {
            cell.userNameLabel.text = userName
        }
        
        if let followersCount = user.followersCount {
            cell.userNameFollowersLabel.text = String(followersCount) + " followers"
        }
        
        if let investorsCount = user.investorsCount {
            cell.userNameInvestorsLabel.text = String(investorsCount) + " investors"
        }
    }
}



class SocialMediaUserCollectionViewCell: UICollectionViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.roundCorners()
        return view
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.profilePlaceholder
        return imageView
    }()
    
    let userNameLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.getFont(.semibold, size: 14.0)
        return label
    }()
    
    let userNameFollowersLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.getFont(.regular, size: 14.0)
        label.textColor = UIColor.Common.white
        return label
    }()
    
    let userNameInvestorsLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.getFont(.regular, size: 14.0)
        label.textColor = UIColor.Common.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
                
        overlayZeroLayer()
        overlayFirstLayer()
        overlayTopView()
        overlayBottomView()
    }
    
    private func overlayZeroLayer() {
        contentView.addSubview(mainView)
        mainView.roundCorners(with: 10, borderWidth: 2.0, borderColor: UIColor.Common.darkCell)
        mainView.fillSuperview()
    }
    
    private func overlayFirstLayer() {
        mainView.addSubview(topView)
        mainView.addSubview(bottomView)
        
        topView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
        
        bottomView.anchor(top: topView.bottomAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10))
    }
    
    private func overlayTopView() {
        topView.addSubview(userImageView)
        topView.addSubview(userNameLabel)
        
        userImageView.anchor(top: nil, leading: topView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        userImageView.anchorCenter(centerY: topView.centerYAnchor, centerX: nil)
        userImageView.anchorSize(size: CGSize(width: 30, height: 30))
        userImageView.roundCorners(with: 15)
        
        userNameLabel.anchor(top: topView.topAnchor, leading: userImageView.trailingAnchor, bottom: topView.bottomAnchor, trailing: topView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 2))
    }
    
    private func overlayBottomView() {
        bottomView.addSubview(userNameFollowersLabel)
        bottomView.addSubview(userNameInvestorsLabel)
        
        userNameFollowersLabel.anchor(top: bottomView.topAnchor, leading: bottomView.leadingAnchor, bottom: nil, trailing: bottomView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5))
        
        userNameFollowersLabel.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.4).isActive = true
        
        userNameInvestorsLabel.anchor(top: userNameFollowersLabel.bottomAnchor, leading: bottomView.leadingAnchor, bottom: bottomView.bottomAnchor, trailing: bottomView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5))
        
    }
}
