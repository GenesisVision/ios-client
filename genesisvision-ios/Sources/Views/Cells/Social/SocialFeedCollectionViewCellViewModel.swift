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
}

struct SocialFeedCollectionViewCellViewModel {
    let post: Post
    
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
        
        if let logo = post.author?.logoUrl, let fileUrl = getFileURL(fileName: logo), isPictureURL(url: fileUrl.absoluteString) {
            cell.userImageView.kf.indicatorType = .activity
            cell.userImageView.kf.setImage(with: fileUrl)
        } else {
            cell.userImageView.image = UIImage.profilePlaceholder
        }
        
        if let userName = post.author?.username {
            cell.userNameLabel.text = userName
        }
        
        if let date = post.date {
            cell.dateLabel.text = date.dateForSocialPost
        }
        
        if let image = post.images?.first, let logo = image.resizes?.last?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            cell.postImageView.isHidden = false
            cell.postImageView.kf.indicatorType = .activity
            cell.postImageView.kf.setImage(with: fileUrl)
        } else {
            cell.postImageView.isHidden = true
        }
        
        if let text = post.text {
            cell.textView.text = text
        }
        
        if let likes = post.likesCount {
            cell.socialActivitiesView.likesLabel.text = String(likes)
        }
        
        if let commetsCount = post.comments?.count {
            cell.socialActivitiesView.commentsLabel.text = String(commetsCount)
        }
        
        if let views = post.impressionsCount {
            cell.socialActivitiesView.viewsLabel.text = String(views)
        }
        
        if let repostsCount = post.rePostsCount {
            cell.socialActivitiesView.sharesLabel.text = String(repostsCount)
        }
    }
}


class SocialFeedCollectionViewCell: UICollectionViewCell {
    
    //MARK: First Layer
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: Top Layer
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
        label.font = UIFont.getFont(.semibold, size: 16.0)
        return label
    }()
    
    let dateLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont.getFont(.regular, size: 13.0)
        return label
    }()
    
    private let postActionsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont.getFont(.regular, size: 16)
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
            
        let paddng = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -paddng, bottom: 0, right: -paddng)
        textView.isScrollEnabled = true
        textView.dataDetectorTypes = UIDataDetectorTypes.all
        return textView
    }()
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.maskToBounds = true
        return imageView
    }()
    
    let socialActivitiesView: SocialActivitiesView = {
        let view = SocialActivitiesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var postId: UUID?
    
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
        userImageView.image = UIImage.profilePlaceholder
    }
    
    private func setup() {
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.Common.darkCell
        
        overlayContentView()
        overlayTopView()
        overlayMiddleView()
        overlayThirdLayerOnBottomView()
    }
    
    private func overlayContentView() {
        contentView.addSubview(topView)
        contentView.addSubview(middleView)
        contentView.addSubview(bottomView)
        
        topView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 70))
        
        middleView.anchor(top: topView.bottomAnchor, leading: contentView.leadingAnchor, bottom: bottomView.topAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        bottomView.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10), size: CGSize(width: 0, height: 50))

    }
    
    private func overlayTopView() {
        topView.addSubview(userImageView)
        topView.addSubview(userNameLabel)
        topView.addSubview(dateLabel)
        topView.addSubview(postActionsButton)
        
        userImageView.anchor(top: nil, leading: topView.leadingAnchor, bottom: nil, trailing: nil)
        userImageView.anchorCenter(centerY: topView.centerYAnchor, centerX: nil)
        userImageView.anchorSize(size: CGSize(width: 50, height: 50))
        userImageView.roundCorners(with: 25)
        
        userNameLabel.anchor(top: topView.topAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: postActionsButton.leadingAnchor, padding: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 0))
        userNameLabel.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.4).isActive = true

        dateLabel.anchor(top: userNameLabel.bottomAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: postActionsButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 0))
        dateLabel.anchorSize(size: CGSize(width: 0, height: 17))

        postActionsButton.anchor(top: nil, leading: nil, bottom: nil, trailing: topView.trailingAnchor)
        postActionsButton.anchorCenter(centerY: topView.centerYAnchor, centerX: nil)
        postActionsButton.anchorSize(size: CGSize(width: 60, height: 60))
    }
    
    private func overlayMiddleView() {
        middleView.addSubview(textView)
        middleView.addSubview(postImageView)

        textView.anchor(top: middleView.topAnchor, leading: middleView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        textView.heightAnchor.constraint(equalTo: middleView.heightAnchor, multiplier: 0.5).isActive = true

        postImageView.anchor(top: textView.bottomAnchor, leading: middleView.leadingAnchor, bottom: middleView.bottomAnchor, trailing: middleView.trailingAnchor)
        postImageView.anchorSize(size: CGSize(width: 0, height: 200))
    }
    
    private func overlayThirdLayerOnBottomView() {
        bottomView.addSubview(socialActivitiesView)
        socialActivitiesView.delegate = self
        socialActivitiesView.fillSuperview()
    }
}

extension SocialFeedCollectionViewCell: SocialActivitiesViewDelegateProtocol {
    func likeTouched() {
        print("like")
    }
    
    func commentTouched() {
        print("comment")
    }
    
    func shareTouched() {
        print("share")
    }
}
