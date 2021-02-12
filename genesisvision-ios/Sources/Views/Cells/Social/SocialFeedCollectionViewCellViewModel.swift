//
//  SocialFeedTableViewCellViewModel.swift
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
    let tagViewHeight: CGFloat = 0
}

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
        let imageHeight: CGFloat = 250
        var textHeight: CGFloat = 0
        var height: CGFloat = 170
        
        if let isEmpty = post.images?.isEmpty, !isEmpty {
            if let postImageHeight = post.images?.first?.resizes?.last?.height {
                height = height + (CGFloat(postImageHeight) < imageHeight ? CGFloat(postImageHeight) : imageHeight)
            } else {
                height += imageHeight
            }
        }
        
        if let text = post.text, !text.isEmpty {
            let textHeightValue = text.height(forConstrainedWidth: 400, font: UIFont.getFont(.regular, size: 16))
            if textHeightValue < 40 {
                textHeight = 40
            } else if textHeightValue > 40 && textHeightValue < 250 {
                textHeight = textHeightValue
            } else if textHeightValue > 250 {
                textHeight = 250
            }
            height += textHeight
        }
        print("CellSize: \(width) || \(height)")
        return CGSize(width: width, height: height)
    }
    
    func postViewSizes() -> SocialPostViewSizes {
        var textHeight: CGFloat = 0
        var imageHeight: CGFloat = 0
        
        if let isEmpty = post.images?.isEmpty, !isEmpty {
            if let postImageHeight = post.images?.first?.resizes?.last?.height {
                imageHeight = CGFloat(postImageHeight) < 250 ? CGFloat(postImageHeight) : 250
            } else {
                imageHeight = 250
            }
        }
        
        if let text = post.text, !text.isEmpty {
            let textHeightValue = text.height(forConstrainedWidth: 400, font: UIFont.getFont(.regular, size: 16))
            
            if textHeightValue < 40 {
                textHeight = 40
            } else if textHeightValue > 40 && textHeightValue < 250 {
                textHeight = textHeightValue
            } else if textHeightValue > 250 {
                textHeight = 250
            }
        }
        
        return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight)
    }
}

extension SocialFeedCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialFeedCollectionViewCell) {
        
        if let postId = post._id {
            cell.postId = postId
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
        
        if let image = post.images?.first, let logo = image.resizes?.last?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
            cell.postView.postImageView.isHidden = false
            cell.postView.postImageView.kf.indicatorType = .activity
            cell.postView.postImageView.kf.setImage(with: fileUrl)
        } else {
            cell.postView.postImageView.isHidden = true
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
        overlayThirdLayerOnBottomView()
    }
    
    private func overlayContentView() {
        contentView.addSubview(postView)
        contentView.addSubview(bottomView)
        
        postView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: bottomView.topAnchor, trailing: contentView.trailingAnchor)
        
        bottomView.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10), size: CGSize(width: 0, height: 60))
    }
    
    private func overlayThirdLayerOnBottomView() {
        bottomView.addSubview(socialActivitiesView)
        socialActivitiesView.delegate = self
        socialActivitiesView.fillSuperview(padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
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
