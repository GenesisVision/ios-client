//
//  SocialMediaPostCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 13.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct SocialMediaPostCollectionViewCellViewModel {
    let post: MediaPost
}

extension SocialMediaPostCollectionViewCellViewModel: CellViewModel {
    
    func setup(on cell: SocialMediaPostCollectionViewCell) {
        
        if let postTitle = post.title {
            cell.titleLabel.text = postTitle
        }
        
        if let logo = post.authorLogoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            cell.userImageView.kf.indicatorType = .activity
            cell.userImageView.kf.setImage(with: fileUrl)
        } else {
            cell.userImageView.image = UIImage.profilePlaceholder
        }
        
        if let userName = post.author {
            cell.userNameLabel.text = userName
        }
        
        if let date = post.date {
            cell.dateLabel.text = date.dateForSocialPost
        }
        
        if let image = post.image?.resizes?.last?.logoUrl, let fileUrl = getFileURL(fileName: image) {
            cell.postImageView.isHidden = false
            cell.postImageView.kf.indicatorType = .activity
            cell.postImageView.kf.setImage(with: fileUrl)
        } else {
            cell.postImageView.isHidden = true
        }
        
    }
}

class SocialMediaPostCollectionViewCell: UICollectionViewCell {
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Common.darkCell
        return view
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let middleView: UIView = {
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
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.profilePlaceholder
        return imageView
    }()
    
    let userNameLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont.getFont(.semibold, size: 15.0)
        return label
    }()
    
    let dateLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont.getFont(.regular, size: 12.0)
        return label
    }()
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.maskToBounds = true
        return imageView
    }()
    
    let titleLabel: LargeTitleLabel = {
        let label = LargeTitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.getFont(.semibold, size: 16.0)
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
        
        contentView.addSubview(mainView)
        mainView.fillSuperview()
        overlayFirstLayer()
        overlayBottomView()
        overlayTopMiddleview()
    }
    
    private func overlayFirstLayer() {
        mainView.addSubview(topView)
        mainView.addSubview(middleView)
        mainView.addSubview(bottomView)
        
        
        topView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: mainView.trailingAnchor)
        topView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.4).isActive = true
        
        middleView.anchor(top: topView.bottomAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: mainView.trailingAnchor)
        middleView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.4).isActive = true
        
        
        bottomView.anchor(top: middleView.bottomAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor)
    }
    
    private func overlayBottomView() {
        bottomView.addSubview(userImageView)
        bottomView.addSubview(userNameLabel)
        bottomView.addSubview(dateLabel)
        
        userImageView.anchor(top: nil, leading: bottomView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        userImageView.anchorCenter(centerY: bottomView.centerYAnchor, centerX: nil)
        userImageView.anchorSize(size: CGSize(width: 30, height: 30))
        userImageView.roundCorners(with: 15)
        
        userNameLabel.anchor(top: bottomView.topAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: bottomView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0))
        userNameLabel.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.4).isActive = true

        dateLabel.anchor(top: userNameLabel.bottomAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: bottomView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        dateLabel.anchorSize(size: CGSize(width: 0, height: 17))
    }
    
    private func overlayTopMiddleview() {
        topView.addSubview(postImageView)
        postImageView.fillSuperview()
        
        middleView.addSubview(titleLabel)
        titleLabel.fillSuperview()
    }
}
