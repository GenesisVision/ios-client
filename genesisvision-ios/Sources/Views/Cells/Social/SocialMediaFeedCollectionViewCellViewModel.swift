//
//  SocialMediaLiveCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 13.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

enum SocialMediaFeedCollectionCellType: String {
    case feed = "Feed"
    case hot = "Hot"
    case live = "Live"
}

protocol SocialMediaFeedCollectionViewCellDelegate: class {
    func openSocialFeed(type: SocialMediaFeedCollectionCellType)
    func commentPressed(postId: UUID)
    func sharePressed(postId: UUID)
    func likePressed(postId: UUID)
    func tagPressed(tag: PostTag)
    func userOwnerPressed(postId: UUID)
    func postActionsPressed(postId: UUID)
}

struct SocialMediaFeedCollectionViewCellViewModel {
    let type: SocialMediaFeedCollectionCellType
    let post: Post
    weak var cellDelegate: SocialMediaFeedCollectionViewCellDelegate?
    
    func cellSize(spacing: CGFloat, frame: CGRect) -> CGSize {
        let width = frame.width - spacing
        let defaultHeight: CGFloat = 250
        let socialPostViewSizes = postViewSizes()
        
        let cellHeight = socialPostViewSizes.allHeight + defaultHeight
        
        return CGSize(width: width, height: cellHeight)
    }
    
    func postViewSizes() -> SocialPostViewSizes {
        var textHeight: CGFloat = 0
        var imageHeight: CGFloat = 0
        var tagsViewHeight: CGFloat = 0
        
        if let isEmpty = post.images?.isEmpty, !isEmpty {
            imageHeight = 250
        }
        
        if let text = post.text, !text.isEmpty {
            let textHeightValue = text.height(forConstrainedWidth: 400, font: UIFont.getFont(.regular, size: 16))
            
            if textHeightValue < 25 {
                textHeight = 25
            } else if textHeightValue > 25 && textHeightValue < 250 {
                textHeight = textHeightValue
            } else if textHeightValue > 250 {
                textHeight = 250
            }
        }
        
        if let tags = post.tags, !tags.isEmpty {
            tagsViewHeight = 110
        }
        
        return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight)
    }
}

extension SocialMediaFeedCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialMediaFeedCollectionViewCell) {
        cell.delegate = cellDelegate
        
        cell.type = type
        cell.postId = post._id
        
        cell.topButton.setTitle(type.rawValue, for: .normal)
        
        cell.postView.socialPostViewSizes = postViewSizes()
        cell.postView.updateMiddleViewConstraints()
        
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
        
        if let tags = post.tags, !tags.isEmpty {
            cell.postView.tagsView.isHidden = false
            cell.postView.postTags = tags
        } else {
            cell.postView.tagsView.isHidden = true
        }
        
        if let text = post.text, !text.isEmpty {
            cell.postView.textView.isHidden = false
            cell.postView.textView.text = text
        } else {
            cell.postView.textView.isHidden = true
        }
        
        if let isLiked = post.personalDetails?.isLiked {
            cell.socialActivitiesView.isLiked = isLiked
        }
        
        if let likes = post.likesCount {
            cell.socialActivitiesView.likeCount = likes
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


class SocialMediaFeedCollectionViewCell: UICollectionViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let topButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let centralView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Common.darkCell
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let image = UIImage(named: "img_back_arrow")
        let imageView = UIImageView(image: image)
        imageView.transform = imageView.transform.rotated(by: CGFloat(Double.pi))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let topButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.Common.white, for: .normal)
        button.isUserInteractionEnabled = true
        button.titleLabel?.font = UIFont.getFont(.semibold, size: 17)
        return button
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
    
    var type: SocialMediaFeedCollectionCellType?
    var postId: UUID?
    
    weak var delegate: SocialMediaFeedCollectionViewCellDelegate?
    
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
        
        topButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        overlayZeroLayer()
        overlayFirstLayer()
        overlaySecondLayer()
        overlayThirdLayer()
    }
    
    private func overlayZeroLayer() {
        contentView.addSubview(mainView)
        mainView.fillSuperview()
    }
    
    private func overlayFirstLayer() {
        mainView.addSubview(topButtonView)
        mainView.addSubview(centralView)
        
        topButtonView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: mainView.trailingAnchor, size: CGSize(width: 0, height: 50))
        
        centralView.anchor(top: topButtonView.bottomAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    private func overlaySecondLayer() {
        topButtonView.addSubview(arrowImageView)
        topButtonView.addSubview(topButton)
        
        arrowImageView.anchor(top: topButtonView.topAnchor, leading: nil, bottom: topButtonView.bottomAnchor, trailing: topButtonView.trailingAnchor, padding: UIEdgeInsets(top: 19, left: 0, bottom: 19, right: 10), size: CGSize(width: 6, height: 12))
        
        topButton.anchor(top: topButtonView.topAnchor, leading: topButtonView.leadingAnchor, bottom: topButtonView.bottomAnchor, trailing: arrowImageView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    private func overlayThirdLayer() {
        centralView.addSubview(postView)
        centralView.addSubview(socialActivitiesView)
        
        postView.anchor(top: centralView.topAnchor, leading: centralView.leadingAnchor, bottom: socialActivitiesView.topAnchor, trailing: centralView.trailingAnchor)
        postView.delegate = self
        
        socialActivitiesView.anchor(top: nil, leading: centralView.leadingAnchor, bottom: centralView.bottomAnchor, trailing: centralView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 15, right: 10), size: CGSize(width: 0, height: 45))
        
        let borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.backgroundColor = UIColor.Common.darkTextSecondary
        socialActivitiesView.addSubview(borderLine)
        
        borderLine.anchor(top: socialActivitiesView.topAnchor, leading: socialActivitiesView.leadingAnchor, bottom: nil, trailing: socialActivitiesView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        
        socialActivitiesView.delegate = self
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        guard let type = type else { return }
        delegate?.openSocialFeed(type: type)
    }
}

extension SocialMediaFeedCollectionViewCell: SocialActivitiesViewDelegateProtocol {
    func likeTouched() {
        guard let postId = postId else { return }
        delegate?.likePressed(postId: postId)
    }
    
    func commentTouched() {
        guard let postId = postId else { return }
        delegate?.commentPressed(postId: postId)
    }
    
    func shareTouched() {
        guard let postId = postId else { return }
        delegate?.sharePressed(postId: postId)
    }
}

extension SocialMediaFeedCollectionViewCell: SocialPostViewDelegate {
    func postActionsPressed() {
        guard let postId = postId else { return }
        delegate?.postActionsPressed(postId: postId)
    }
    
    func userOwnerPressed() {
        guard let postId = postId else { return }
        delegate?.userOwnerPressed(postId: postId)
    }
    
    func tagPressed(tag: PostTag) {
        delegate?.tagPressed(tag: tag)
    }
}