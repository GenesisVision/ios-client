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
    let eventViewHeight: CGFloat
    let fullTextViewHeight : CGFloat
    var isExpanded = false
    var allHeight: CGFloat {
        return textViewHeight + imageViewHeight + tagViewHeight + eventViewHeight
    }
}
//MARK: - DetailView cell ViewModel
protocol SocialFeedCollectionViewCellDelegate: AnyObject {
    func likeTouched(postId: UUID)
    func shareTouched(postId: UUID)
    func commentTouched(postId: UUID)
    func tagPressed(tag: PostTag)
    func userOwnerPressed(postId: UUID)
    func postActionsPressed(postId: UUID, postActions: [SocialPostAction]?, postLink: String?)
    func undoDeletion(postId: UUID)
    func imagePressed(postId: UUID, index: Int, image: ImagesGalleryCollectionViewCellViewModel)
    func touchExpandButton(postId: UUID)
    func isExpandedPost(postId: UUID) -> Bool
    func openPost(postId: UUID)
}

struct SocialFeedCollectionViewCellViewModel {
    let post: Post
    var sharedPost : Post?
    weak var cellDelegate: SocialFeedCollectionViewCellDelegate?
    
    init(post: Post, cellDelegate: SocialFeedCollectionViewCellDelegate?) {
        self.post = post
        self.cellDelegate = cellDelegate
        self.setupSharedPost(post : post)
    }
    
    mutating func setupSharedPost(post : Post) {
        guard let tags = post.tags, !tags.isEmpty else { return }
        for tag in tags {
            if tag.type == .post {
                sharedPost = tag.post
            }
        }
    }
    
    func cellSize(spacing: CGFloat, frame: CGRect, isExpanded : Bool = false) -> CGSize {
        let width = frame.width - spacing
        let defaultHeight: CGFloat = 180
        let socialPostViewSizes = postViewSizes(isExpanded: isExpanded)
        let sharedPostViewSizes = sharedPostViewSizes(isExpanded: false)
        
        let cellHeight: CGFloat
        if sharedPost == nil {
            cellHeight = socialPostViewSizes.allHeight + defaultHeight
        } else {
            cellHeight = socialPostViewSizes.allHeight + sharedPostViewSizes.allHeight + (defaultHeight * 1.5)
        }
        return CGSize(width: width, height: cellHeight)
    }
    
    
    func postViewSizes(isExpanded : Bool) -> SocialPostViewSizes {
        var textHeight: CGFloat = 0
        var imageHeight: CGFloat = 0
        var tagsViewHeight: CGFloat = 0
        var fullTextViewHeight : CGFloat = 0
        
        if let tags = post.tags, !tags.isEmpty {
            if (tags.count == 1 && tags.first?.type == .url) || tags.allSatisfy({ $0.type == .url }) || (tags.count == 1 && tags.first?.type == .post) {
                tagsViewHeight = 0
            } else {
                tagsViewHeight = 90
            }
        }
        
        if let tags = post.tags, !tags.isEmpty, tags.contains(where: { $0.type == .event }) {
            return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight, eventViewHeight: 50, fullTextViewHeight: fullTextViewHeight)
        }
        
        if let isEmpty = post.images?.isEmpty, !isEmpty {
            imageHeight = 250
        }
        
        if let text = post.text, !text.isEmpty {
            let textHeightValue = text.height(forConstrainedWidth: UIScreen.main.bounds.width - 20, font: UIFont.getFont(.regular, size: 18))
            let expandButton = CGFloat(20)
            
            if textHeightValue < 25 && textHeightValue != 0 {
                textHeight = 25
            } else if textHeightValue > 25 && textHeightValue < 250 {
                textHeight = textHeightValue
            } else if textHeightValue > 250 {
                textHeight = 250 + expandButton
            }
            
            fullTextViewHeight = textHeightValue - expandButton
        }
        
        if isExpanded {
            return SocialPostViewSizes(textViewHeight: fullTextViewHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight, eventViewHeight: 0, fullTextViewHeight: fullTextViewHeight, isExpanded : isExpanded)
        } else {
            return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight, eventViewHeight: 0, fullTextViewHeight: fullTextViewHeight)
        }
    }
    
    func sharedPostViewSizes(isExpanded : Bool) -> SocialPostViewSizes {
        var textHeight: CGFloat = 0
        var imageHeight: CGFloat = 0
        var tagsViewHeight: CGFloat = 0
        var fullTextViewHeight : CGFloat = 0
        guard let post = sharedPost else {
            return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight, eventViewHeight: 0, fullTextViewHeight: fullTextViewHeight)
        }
        
        if let tags = post.tags, !tags.isEmpty {
            if (tags.count == 1 && tags.first?.type == .url) || tags.allSatisfy({ $0.type == .url }) {
                tagsViewHeight = 0
            } else {
                tagsViewHeight = 90
            }
        }
        
        if let tags = post.tags, !tags.isEmpty, tags.contains(where: { $0.type == .event }) {
            return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight, eventViewHeight: 50, fullTextViewHeight: fullTextViewHeight)
        }
        
        if let isEmpty = post.images?.isEmpty, !isEmpty {
            imageHeight = 250
        }
        
        if let text = post.text, !text.isEmpty {
            let textHeightValue = text.height(forConstrainedWidth: UIScreen.main.bounds.width - 20, font: UIFont.getFont(.regular, size: 18))
            let expandButton = CGFloat(20)
            
            if textHeightValue < 25 && textHeightValue != 0 {
                textHeight = 25
            } else if textHeightValue > 25 && textHeightValue < 250 {
                textHeight = textHeightValue
            } else if textHeightValue > 250 {
                textHeight = 250 + expandButton
            }
            
            fullTextViewHeight = textHeightValue - expandButton
        }
        
        if isExpanded {
            return SocialPostViewSizes(textViewHeight: fullTextViewHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight, eventViewHeight: 0, fullTextViewHeight: fullTextViewHeight, isExpanded : isExpanded)
        } else {
            return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight, eventViewHeight: 0, fullTextViewHeight: fullTextViewHeight)
        }
    }
}

extension SocialFeedCollectionViewCellViewModel: CellViewModel {
     func setup(on cell: SocialFeedCollectionViewCell) {
        
        var eventPost: Bool = false
        var isExpanded = false
        
        if let postId = post._id {
            cell.postId = postId
        }
        
        cell.delegate = cellDelegate
        //MARK: - Инициализация размеров
         if let expanded = cellDelegate?.isExpandedPost(postId: cell.postId ?? UUID()) {
             isExpanded = expanded
         }
        cell.postView.socialPostViewSizes = postViewSizes(isExpanded: isExpanded)
        cell.postView.updateMiddleViewConstraints()
         
         if let logo = post.author?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
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
        
        if let postImages = post.images, !postImages.isEmpty {
            cell.postView.galleryView.isHidden = false
            lazy var images = [ImagesGalleryCollectionViewCellViewModel]()
            
            for postImage in postImages {
                if let resizes = postImage.resizes,
                   resizes.count > 1 {
                    let original = resizes.filter({ $0.quality == .original })
                    let hight = resizes.filter({ $0.quality == .high })
                    let medium = resizes.filter({ $0.quality == .medium })
                    let low = resizes.filter({ $0.quality == .low })
                    
                    if let logoUrl = original.first?.logoUrl {
                        images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                               resize: original.first,
                                                                               image: nil,
                                                                               showRemoveButton: false,
                                                                               delegate: nil))
                        continue
                    } else if let logoUrl = hight.first?.logoUrl {
                        images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                               resize: hight.first,
                                                                               image: nil,
                                                                               showRemoveButton: false,
                                                                               delegate: nil))
                        continue
                    } else if let logoUrl = medium.first?.logoUrl {
                        images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                               resize: medium.first,
                                                                               image: nil,
                                                                               showRemoveButton: false,
                                                                               delegate: nil))
                        continue
                    } else if let logoUrl = low.first?.logoUrl {
                        images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                               resize: low.first,
                                                                               image: nil,
                                                                               showRemoveButton: false,
                                                                               delegate: nil))
                    }
                } else if let logoUrl = postImage.resizes?.first?.logoUrl {
                    images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                           resize: postImage.resizes?.first,
                                                                           image: nil,
                                                                           showRemoveButton: false,
                                                                           delegate: nil))
                }
            }
            cell.postView.galleryView.viewModels = images
        } else {
            cell.postView.galleryView.isHidden = true
        }
        
        if let text = post.text, !text.isEmpty, !eventPost {
            cell.postView.textView.isHidden = false
            let muttableText = NSMutableAttributedString(string: text,
                                                         attributes: [NSAttributedString.Key.font: cell.postView.textView.font!, NSAttributedString.Key.foregroundColor: UIColor.white])
            cell.postView.textView.attributedText = muttableText
        } else {
            cell.postView.textView.isHidden = true
        }
        
        if let tags = post.tags, !tags.isEmpty {
            if (tags.count == 1 && tags.first?.type == .url) || tags.allSatisfy({ $0.type == .url }) {
                cell.postView.tagsView.isHidden = true
                cell.postView.eventView.isHidden = true
            } else {
                cell.postView.tagsView.isHidden = false
                eventPost = tags.contains(where: { $0.type == .event })
                cell.postView.eventView.isHidden = !eventPost
            }
            var tagsWithoutReposts = tags
            tagsWithoutReposts.removeAll(where: {$0.type == .post})
            cell.postView.postTags = tagsWithoutReposts
            cell.postView.textView.replaceTagsInText(tags: tagsWithoutReposts)
        } else {
            cell.postView.tagsView.isHidden = true
            cell.postView.eventView.isHidden = true
        }

        
        if let isLiked = post.personalDetails?.isLiked, isLiked {
            cell.socialActivitiesView.isLiked = isLiked
        }
        
        if let isPinned = post.isPinned, isPinned {
            cell.postView.pinSymbolImageView.isHidden = false
        } else {
            cell.postView.pinSymbolImageView.isHidden = true
        }
        
        if let likes = post.likesCount {
            cell.socialActivitiesView.likeCount = likes
        } else {
            cell.socialActivitiesView.likeCount = 0
        }
        
        if let commetsCount = post.comments?.count, commetsCount > 0 {
            cell.socialActivitiesView.commentsLabel.text = String(commetsCount)
        } else {
            cell.socialActivitiesView.commentsLabel.text = ""
        }
        
        if let views = post.impressionsCount, views > 0 {
            cell.socialActivitiesView.viewsLabel.text = String(views)
        } else {
            cell.socialActivitiesView.viewsLabel.text = ""
        }
        
        if let repostsCount = post.rePostsCount, repostsCount > 0 {
            cell.socialActivitiesView.sharesLabel.text = String(repostsCount)
        } else {
            cell.socialActivitiesView.sharesLabel.text = ""
        }
        
        cell.postView.sizeToFit()
        cell.postView.textView.setupGesturerecognizer()
         
         
         //MARK: - Repost setup
         
         cell.sharedPostView.isHidden = true
         guard let sharedPost = sharedPost else {
             cell.setupContentView()
             return
         }
         cell.sharedPostView.isHidden = false
         cell.sharedPostView.socialPostViewSizes = sharedPostViewSizes(isExpanded: false)
         cell.sharedPostView.updateMiddleViewConstraints()
         if let sizes = cell.sharedPostView.socialPostViewSizes {
             let defaultHeight: CGFloat = 100
             cell.sharedPostmainViewHeight = sizes.allHeight + defaultHeight
         }

         if let fullTextViewHeight = cell.sharedPostView.socialPostViewSizes?.fullTextViewHeight, fullTextViewHeight > 250 {
             cell.sharedPostView.socialPostViewSizes?.isExpanded = false
         }

         if let logo = sharedPost.author?.logoUrl, let fileUrl = getFileURL(fileName: logo) {
             cell.sharedPostView.userImageView.kf.indicatorType = .activity
             cell.sharedPostView.userImageView.kf.setImage(with: fileUrl)
         } else {
             cell.sharedPostView.userImageView.image = UIImage.profilePlaceholder
         }

         if let userName = sharedPost.author?.username {
             cell.sharedPostView.userNameLabel.text = userName
         }

         if let date = sharedPost.date {
             cell.sharedPostView.dateLabel.text = date.dateForSocialPost
         }

         if let postImages = sharedPost.images, !postImages.isEmpty {
             cell.sharedPostView.galleryView.isHidden = false
             lazy var images = [ImagesGalleryCollectionViewCellViewModel]()

             for postImage in postImages {
                 if let resizes = postImage.resizes,
                    resizes.count > 1 {
                     let original = resizes.filter({ $0.quality == .original })
                     let hight = resizes.filter({ $0.quality == .high })
                     let medium = resizes.filter({ $0.quality == .medium })
                     let low = resizes.filter({ $0.quality == .low })

                     if let logoUrl = original.first?.logoUrl {
                         images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                                resize: original.first,
                                                                                image: nil,
                                                                                showRemoveButton: false,
                                                                                delegate: nil))
                         continue
                     } else if let logoUrl = hight.first?.logoUrl {
                         images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                                resize: hight.first,
                                                                                image: nil,
                                                                                showRemoveButton: false,
                                                                                delegate: nil))
                         continue
                     } else if let logoUrl = medium.first?.logoUrl {
                         images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                                resize: medium.first,
                                                                                image: nil,
                                                                                showRemoveButton: false,
                                                                                delegate: nil))
                         continue
                     } else if let logoUrl = low.first?.logoUrl {
                         images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                                resize: low.first,
                                                                                image: nil,
                                                                                showRemoveButton: false,
                                                                                delegate: nil))
                     }
                 } else if let logoUrl = postImage.resizes?.first?.logoUrl {
                     images.append(ImagesGalleryCollectionViewCellViewModel(imageUrl: logoUrl,
                                                                            resize: postImage.resizes?.first,
                                                                            image: nil,
                                                                            showRemoveButton: false,
                                                                            delegate: nil))
                 }
             }
             cell.sharedPostView.galleryView.viewModels = images
         } else {
             cell.sharedPostView.galleryView.isHidden = true
         }

         if let text = sharedPost.text {
             cell.sharedPostView.textView.text = text
         }

         var eventSharedPost: Bool = false
         if let tags = sharedPost.tags, !tags.isEmpty {
             if (tags.count == 1 && tags.first?.type == .url) || tags.allSatisfy({ $0.type == .url }) {
                 cell.sharedPostView.tagsView.isHidden = true
                 cell.sharedPostView.eventView.isHidden = true
             } else {
                 cell.sharedPostView.tagsView.isHidden = false
                 eventSharedPost = tags.contains(where: { $0.type == .event })
                 cell.sharedPostView.eventView.isHidden = !eventSharedPost
             }
             cell.sharedPostView.postTags = tags
             cell.sharedPostView.textView.replaceTagsInText(tags: tags)
         } else {
             cell.sharedPostView.tagsView.isHidden = true
             cell.sharedPostView.eventView.isHidden = true
         }
         cell.setupContentView()
         cell.sharedPostView.sizeToFit()
    }
}


class SocialFeedCollectionViewCell: UICollectionViewCell {
    
    let bottomView: UIView = {
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
    
    let sharedPostView: SocialPostView = {
        let sharedPost = SocialPostView()
        sharedPost.translatesAutoresizingMaskIntoConstraints = false
        sharedPost.isHidden = true
        let width = UIScreen.main.bounds.width - 40
        let size = CGSize(width: width, height: 250)
        sharedPost.galleryView.changeSizeforCollectionview(size: size)
        sharedPost.postActionsButton.isHidden = true
        return sharedPost
    }()
    
    var sharedPostmainViewHeight : CGFloat = 0
    
    let socialActivitiesView: SocialActivitiesView = {
        let view = SocialActivitiesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let deletedPostView: UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.isHidden = true
        return stackView
    }()
    
    let deletedPostLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont.getFont(.semibold, size: 16.0)
        return label
    }()
    
    let undoDeletionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Undo".localized, for: .normal)
        button.setTitleColor(UIColor.primary, for: .normal)
        return button
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
        sharedPostView.userImageView.image = UIImage.profilePlaceholder
        sharedPostView.tagsView.viewModels = []
    }
    
    private func setup() {
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.Common.darkCell
        undoDeletionButton.addTarget(self, action: #selector(undoDeletion), for: .touchUpInside)
        overlayThirdLayerOnBottomView()
    }
    
    private func overlayContentView() {
        if sharedPostView.isHidden {
            contentView.addSubview(postView)
            contentView.addSubview(bottomView)
            contentView.addSubview(deletedPostView)
            deletedPostView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

            postView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: bottomView.topAnchor, trailing: contentView.trailingAnchor)
            postView.delegate = self

            bottomView.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 65))

            deletedPostView.addArrangedSubview(deletedPostLabel)
            deletedPostView.addArrangedSubview(undoDeletionButton)
        } else {
            contentView.addSubview(postView)
            contentView.addSubview(bottomView)
            contentView.addSubview(deletedPostView)
            contentView.addSubview(sharedPostView)
            deletedPostView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))


            postView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor)
            if let socialPostViewSizes = postView.socialPostViewSizes {
                let postHeight = socialPostViewSizes.allHeight + 100
                postView.height = postHeight
            } else {
                postView.bottomAnchor.constraint(equalTo: sharedPostView.topAnchor).isActive = true
            }
            postView.delegate = self
            
            sharedPostView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
            sharedPostView.height = sharedPostmainViewHeight
            sharedPostView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
            sharedPostView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            sharedPostView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            sharedPostView.delegate = self

            let borderLine = UIView()
            borderLine.translatesAutoresizingMaskIntoConstraints = false
            borderLine.backgroundColor = UIColor.Common.darkTextSecondary
            contentView.addSubview(borderLine)
            borderLine.anchor(top: sharedPostView.topAnchor, leading: contentView.leadingAnchor, bottom: sharedPostView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0), size: CGSize(width: 1, height: sharedPostView.height - 20))


            bottomView.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 65))

            deletedPostView.addArrangedSubview(deletedPostLabel)
            deletedPostView.addArrangedSubview(undoDeletionButton)
        }
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
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(commentLabelTouched(_:)))
        socialActivitiesView.commentsLabel.addGestureRecognizer(recognizer)
    }
    
    func setupContentView() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        overlayContentView()
    }
    
    @objc private func undoDeletion() {
        guard let postId = postId else { return }
        delegate?.undoDeletion(postId: postId)
    }
    
    @objc private func commentLabelTouched(_ sender: Any) {
        commentTouched()
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
    func imagePressed(index: Int, image: ImagesGalleryCollectionViewCellViewModel) {
        guard let postId = postId else { return }
        delegate?.imagePressed(postId: postId, index: index, image: image)
    }
    
    func postActionsPressed() {
        guard let postId = postId else { return }
        delegate?.postActionsPressed(postId: postId,postActions: nil, postLink: nil)
    }
    
    func userOwnerPressed() {
        guard let postId = postId else { return }
        delegate?.userOwnerPressed(postId: postId)
    }
    
    func tagPressed(tag: PostTag) {
        delegate?.tagPressed(tag: tag)
    }
    func touchExpandButton() {
        guard let postId = postId else { return }
        delegate?.touchExpandButton(postId: postId)
    }
    
    func openPost() {
        guard let postId = postId else { return }
        delegate?.openPost(postId: postId)
    }
}
