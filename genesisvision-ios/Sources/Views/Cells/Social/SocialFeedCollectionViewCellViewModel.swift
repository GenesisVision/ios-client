//
//  SocialFeedTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 27.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

protocol SocialFeedCollectionViewCellDelegateProtocol: class {
    func likeTouched(postId: UUID)
    func shareTouched(postId: UUID)
    func commentTouched(postId: UUID)
}

struct SocialFeedCollectionViewCellViewModel {
    let post: Post
    weak var cellDelegate: SocialFeedCollectionViewCellDelegateProtocol?
    
    func cellSize(spacing: CGFloat, frame: CGRect) -> CGSize {
        let width = frame.width - spacing
        var height: CGFloat = 300
        
        if let image = post.images?.first, let imageHeight = image.resizes?.first?.height {
            height += CGFloat(imageHeight)
        }
        
        return CGSize(width: width, height: height)
    }
}

extension SocialFeedCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialFeedCollectionViewCell) {
        
        if let postId = post._id {
            cell.postId = postId
        }
        
        cell.delegate = cellDelegate
        
        if let logo = post.author?.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            cell.postView.userImageView.kf.indicatorType = .activity
            cell.postView.userImageView.kf.setImage(with: fileUrl)
        } else {
            cell.postView.userImageView.image = UIImage.profilePlaceholder
        }
        
        if let userName = post.author?.username {
            cell.postView.userNameLabel.text = userName
        }
        
        if let date = post.date {
            cell.postView.dateLabel.text = date.dateForSocialPost
        }
        
        if let image = post.images?.first, let logo = image.resizes?.last?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            cell.postView.postImageView.isHidden = false
            cell.postView.postImageView.kf.indicatorType = .activity
            cell.postView.postImageView.kf.setImage(with: fileUrl)
        } else {
            cell.postView.postImageView.isHidden = true
        }
        
        if let text = post.text {
            cell.postView.textView.text = text
        }
        
        if let isLiked = post.personalDetails?.isLiked {
            cell.socialActivitiesView.isLiked = isLiked
        }
        
        if let likes = post.likesCount, likes > 0 {
            cell.socialActivitiesView.likesLabel.text = String(likes)
        }
        
        if let commetsCount = post.comments?.count, commetsCount > 0 {
            cell.socialActivitiesView.commentsLabel.text = String(commetsCount)
        }
        
        if let views = post.impressionsCount, views > 0 {
            cell.socialActivitiesView.viewsLabel.text = String(views)
        }
        
        if let repostsCount = post.rePostsCount, repostsCount > 0 {
            cell.socialActivitiesView.sharesLabel.text = String(repostsCount)
        }
    }
}


class SocialFeedCollectionViewCell: UICollectionViewCell {
    
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postView: SocialPostView = {
        let view = SocialPostView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let socialActivitiesView: SocialActivitiesView = {
        let view = SocialActivitiesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var postId: UUID?
    weak var delegate: SocialFeedCollectionViewCellDelegateProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postView.userImageView.image = UIImage.profilePlaceholder
    }
    
    private func setup() {
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.Common.darkCell
        
        overlayContentView()
        //overlayTopView()
        //overlayMiddleView()
        overlayThirdLayerOnBottomView()
    }
    
    private func overlayContentView() {
        contentView.addSubview(postView)
        contentView.addSubview(bottomView)
        
        postView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: bottomView.topAnchor, trailing: contentView.trailingAnchor)
        
        bottomView.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10), size: CGSize(width: 0, height: 50))
    }
    
//    private func overlayTopView() {
//        topView.addSubview(userImageView)
//        topView.addSubview(userNameLabel)
//        topView.addSubview(dateLabel)
//        topView.addSubview(postActionsButton)
//
//        userImageView.anchor(top: nil, leading: topView.leadingAnchor, bottom: nil, trailing: nil)
//        userImageView.anchorCenter(centerY: topView.centerYAnchor, centerX: nil)
//        userImageView.anchorSize(size: CGSize(width: 50, height: 50))
//        userImageView.roundCorners(with: 25)
//
//        userNameLabel.anchor(top: topView.topAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: postActionsButton.leadingAnchor, padding: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 0))
//        userNameLabel.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.4).isActive = true
//
//        dateLabel.anchor(top: userNameLabel.bottomAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: postActionsButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 0))
//        dateLabel.anchorSize(size: CGSize(width: 0, height: 17))
//
//        postActionsButton.anchor(top: nil, leading: nil, bottom: nil, trailing: topView.trailingAnchor)
//        postActionsButton.anchorCenter(centerY: topView.centerYAnchor, centerX: nil)
//        postActionsButton.anchorSize(size: CGSize(width: 60, height: 60))
//    }
    
//    private func overlayMiddleView() {
//        middleView.addSubview(textView)
//        middleView.addSubview(postImageView)
//
//        textView.anchor(top: middleView.topAnchor, leading: middleView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
//        textView.heightAnchor.constraint(equalTo: middleView.heightAnchor, multiplier: 0.5).isActive = true
//
//        postImageView.anchor(top: textView.bottomAnchor, leading: middleView.leadingAnchor, bottom: middleView.bottomAnchor, trailing: middleView.trailingAnchor)
//        postImageView.anchorSize(size: CGSize(width: 0, height: 200))
//    }
    
    private func overlayThirdLayerOnBottomView() {
        bottomView.addSubview(socialActivitiesView)
        socialActivitiesView.delegate = self
        socialActivitiesView.fillSuperview()
    }
}

extension SocialFeedCollectionViewCell: SocialActivitiesViewDelegateProtocol {
    func likeTouched() {
        guard let postId = postId else { return }
        delegate?.likeTouched(postId: postId)
    }
    
    func commentTouched() {
        guard let postId = postId else { return }
        delegate?.commentTouched(postId: postId)
    }
    
    func shareTouched() {
        guard let postId = postId else { return }
        delegate?.shareTouched(postId: postId)
    }
}
