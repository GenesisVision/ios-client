//
//  SocialFeedCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 27.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

struct SocialPostViewSizes {
    let textViewHeight: CGFloat
    let imageViewHeight: CGFloat
    let tagViewHeight: CGFloat
    var allHeight: CGFloat {
        return textViewHeight + imageViewHeight + tagViewHeight
    }
}

protocol SocialFeedCollectionViewCellDelegate: class {
    func likeTouched(postId: UUID)
    func shareTouched(postId: UUID)
    func commentTouched(postId: UUID)
    func tagPressed(tag: PostTag)
    func userOwnerPressed(postId: UUID)
    func postActionsPressed(postId: UUID)
}

struct SocialFeedCollectionViewCellViewModel {
    let post: Post
    weak var cellDelegate: SocialFeedCollectionViewCellDelegate?
    
    func cellSize(spacing: CGFloat, frame: CGRect) -> CGSize {
        let width = frame.width - spacing
        let defaultHeight: CGFloat = 180
        let socialPostViewSizes = postViewSizes()
        
        let cellHeight = socialPostViewSizes.allHeight + defaultHeight
        
        return CGSize(width: width, height: cellHeight)
    }
    
    func postViewSizes() -> SocialPostViewSizes {
        var textHeight: CGFloat = 0
        var imageHeight: CGFloat = 0
        var tagsViewHeight: CGFloat = 0
        
        if let tags = post.tags, !tags.isEmpty {
            tagsViewHeight = 110
            if tags.contains(where: { $0.type == .event }) {
                tagsViewHeight += 60
                return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight)
            }
        }
        
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
        

        
        return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight)
    }
}

extension SocialFeedCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialFeedCollectionViewCell) {
        
        var eventPost: Bool = false
        
        if let postId = post._id {
            cell.postId = postId
        }
        
        if let tags = post.tags, !tags.isEmpty {
            cell.postView.tagsView.isHidden = false
            cell.postView.postTags = tags
            eventPost = tags.contains(where: { $0.type == .event })
            cell.postView.eventView.isHidden = !eventPost
        } else {
            cell.postView.tagsView.isHidden = true
            cell.postView.eventView.isHidden = true
        }
        
        cell.delegate = cellDelegate
        
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
        
        if let image = post.images?.first, let logo = image.resizes?.last?.logoUrl, let fileUrl = getFileURL(fileName: logo), !eventPost {
            cell.postView.postImageView.isHidden = false
            cell.postView.postImageView.kf.indicatorType = .activity
            cell.postView.postImageView.kf.setImage(with: fileUrl)
        } else {
            cell.postView.postImageView.isHidden = true
        }
        
        if let text = post.text, !text.isEmpty, !eventPost {
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
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let socialActivitiesView: SocialActivitiesView = {
        let view = SocialActivitiesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var postId: UUID?
    weak var delegate: SocialFeedCollectionViewCellDelegate?
    
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
        postView.tagsView.viewModels = []
    }
    
    private func setup() {
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.Common.darkCell
        
        overlayContentView()
        overlayThirdLayerOnBottomView()
    }
    
    private func overlayContentView() {
        contentView.addSubview(postView)
        contentView.addSubview(bottomView)
        
        postView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: bottomView.topAnchor, trailing: contentView.trailingAnchor)
        postView.delegate = self
        
        bottomView.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 65))
    }
    
    private func overlayThirdLayerOnBottomView() {
        bottomView.addSubview(socialActivitiesView)
        socialActivitiesView.delegate = self
        socialActivitiesView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 0, bottom: 15, right: 0))
        
        let borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.backgroundColor = UIColor.Common.darkTextSecondary
        socialActivitiesView.addSubview(borderLine)
        
        borderLine.anchor(top: socialActivitiesView.topAnchor, leading: socialActivitiesView.leadingAnchor, bottom: nil, trailing: socialActivitiesView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
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

extension SocialFeedCollectionViewCell: SocialPostViewDelegate {
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
