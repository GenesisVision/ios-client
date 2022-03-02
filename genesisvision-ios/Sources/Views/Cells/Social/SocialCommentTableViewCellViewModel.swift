//
//  SocialCommentTableViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 20.11.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialCommentTableViewCellDelegate: AnyObject {
    func replyButtonPressed(postId: UUID)
    func commentTagPressed(tag: PostTag)
    func likeTouched(postId: UUID)
    func commentActionsPressed(postId: UUID)
}

struct SocialCommentTableViewCellViewModel {
    let post: Post
    weak var delegate: SocialCommentTableViewCellDelegate?
}

extension SocialCommentTableViewCellViewModel: CellViewModel {
    func setup(on cell: SocialCommentTableViewCell) {
        cell.postId = post._id
        cell.delegate = delegate
        
        cell.userNameLabel.text = post.author?.username
        
        if let logo = post.author?.logoUrl,
           let fileUrl = getFileURL(fileName: logo),
           isPictureURL(url: fileUrl.absoluteString) {
            cell.userImageView.kf.indicatorType = .activity
            cell.userImageView.kf.setImage(with: fileUrl)
        } else {
            cell.userImageView.image = UIImage.profilePlaceholder
        }
        
        cell.userImageView.layoutIfNeeded()
        
        if let isLiked = post.personalDetails?.isLiked {
            cell.isLiked = isLiked
        }
        
        if let likes = post.likesCount {
            cell.likeCount = likes
        } else {
            cell.likeCount = 0
        }
        
        if let text = post.text, !text.isEmpty {
            cell.textView.isHidden = false
            let muttableText = NSMutableAttributedString(string: text,
                                                         attributes: [NSAttributedString.Key.font: cell.textView.font!, NSAttributedString.Key.foregroundColor: UIColor.white])
            cell.textView.attributedText = muttableText
        } else {
            cell.textView.isHidden = true
        }
        
        if let tags = post.tags, !tags.isEmpty {
            if (tags.count == 1 && tags.first?.type == .url) || tags.allSatisfy({ $0.type == .url }) {
                cell.tagsView.isHidden = true
            } else {
                cell.tagsView.isHidden = false
            }
            cell.postTags = tags
            cell.textView.replaceTagsInText(tags: tags)
        } else {
            cell.tagsView.isHidden = true
        }
        
        if let date = post.date {
            cell.dateLabel.text = date.dateForSocialPost
        }
        
        if let postImages = post.images, !postImages.isEmpty {
            cell.galleryView.isHidden = false
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
            cell.galleryView.viewModels = images
        } else {
            cell.galleryView.isHidden = true
        }
    }
    
    func cellSize(spacing: CGFloat, frame: CGRect) -> CGSize {
        let width = frame.width - spacing
        let defaultHeight: CGFloat = 100
        let socialPostViewSizes = postViewSizes()
        
        let cellHeight = socialPostViewSizes.allHeight + defaultHeight
        
        return CGSize(width: width, height: cellHeight)
    }
    
    func postViewSizes() -> SocialPostViewSizes {
        var textHeight: CGFloat = 0
        var imageHeight: CGFloat = 0
        var tagsViewHeight: CGFloat = 0
        var fullTextViewHeight: CGFloat = 0
        
        if let tags = post.tags, !tags.isEmpty {
            if (tags.count == 1 && tags.first?.type == .url) || tags.allSatisfy({ $0.type == .url }) {
                tagsViewHeight = 0
            } else {
                tagsViewHeight = 90
            }
        }
        
        if let isEmpty = post.images?.isEmpty, !isEmpty {
            imageHeight = 150
        }
        
        if let text = post.text, !text.isEmpty {
            let textHeightValue = text.height(forConstrainedWidth: UIScreen.main.bounds.width - 20, font: UIFont.getFont(.regular, size: 18))
            
            if textHeightValue < 25 && textHeightValue != 0 {
                textHeight = 25
            } else if textHeightValue > 25 && textHeightValue < 250 {
                textHeight = textHeightValue
            } else if textHeightValue > 250 {
                textHeight = 250
            }
        }
        
        return SocialPostViewSizes(textViewHeight: textHeight, imageViewHeight: imageHeight, tagViewHeight: tagsViewHeight, eventViewHeight: 0, fullTextViewHeight: fullTextViewHeight)
    }
}

class SocialCommentTableViewCell: UITableViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.profilePlaceholder
        imageView.roundCorners()
        return imageView
    }()
    
    let userNameLabel: TitleLabel = {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont.getFont(.semibold, size: 12.0)
        return label
    }()
    
    private let postActionsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "social_post_menu"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 8, bottom: 15, right: 8)
        return button
    }()
    
    private let middleView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.axis = .vertical
        view.spacing = 10
        view.distribution = .equalSpacing
        return view
    }()
    
    let textView: SocialTextView = {
        let textView = SocialTextView()
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
    
    let galleryView: ImagesGalleryView = {
        let imageView = ImagesGalleryView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let dateLabel: SubtitleLabel = {
        let label = SubtitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont.getFont(.regular, size: 11.0)
        return label
    }()
    
    let replyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.primary, for: .normal)
        button.setTitle("Reply", for: .normal)
        button.titleLabel?.font = UIFont.getFont(.regular, size: 12.0)
        return button
    }()
    
    let likesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let likesImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "like")
        return view
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                likesLabel.textColor = UIColor.Common.primary
                likesImage.tintColor = UIColor.Common.primary
                likesImage.image = likesImage.image?.withRenderingMode(.alwaysTemplate)
            } else {
                likesLabel.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
                likesImage.tintColor = nil
                likesImage.image = likesImage.image?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    var likeCount: Int = 0 {
        didSet {
            likesLabel.text = likeCount == 0 ? "" : String(likeCount)
        }
    }
    
    let tagsView: SocialPostTagsView = {
        let socialPostTagsView = SocialPostTagsView()
        socialPostTagsView.translatesAutoresizingMaskIntoConstraints = false
        socialPostTagsView.backgroundColor = .clear
        socialPostTagsView.isHidden = true
        return socialPostTagsView
    }()
    
    var postTags: [PostTag]  = [] {
        didSet {
            tagsView.viewModels = postTags.filter({ $0.type != .event }).filter({ $0.type != .url })
        }
    }
    
    weak var delegate: SocialCommentTableViewCellDelegate?
    var postId: UUID?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        userImageView.roundCorners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        tagsView.delegate = self
        textView.wordRecognizerDelegate = self
        replyButton.addTarget(self, action: #selector(replyButtonPressed), for: .touchUpInside)
        let likesGest = UITapGestureRecognizer(target: self, action: #selector(likesViewTouched))
        likesView.addGestureRecognizer(likesGest)
        postActionsButton.addTarget(self, action: #selector(touchCommentActionsButton), for: .touchUpInside)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(mainView)
        mainView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        mainView.addSubview(userImageView)
        mainView.addSubview(userNameLabel)
        mainView.addSubview(postActionsButton)
        mainView.addSubview(middleView)
        mainView.addSubview(dateLabel)
        mainView.addSubview(replyButton)
        mainView.addSubview(likesView)
        
        userImageView.anchor(top: mainView.topAnchor,
                             leading: mainView.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             size: CGSize(width: 35, height: 35))
        
        userNameLabel.anchor(top: mainView.topAnchor,
                             leading: userImageView.trailingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0),
                             size: CGSize(width: 0, height: 20))
        
        postActionsButton.anchor(top: mainView.topAnchor,
                                 leading: userNameLabel.trailingAnchor,
                                 bottom: nil,
                                 trailing: mainView.trailingAnchor,
                                 size: CGSize(width: 17, height: 15))
        
        middleView.anchor(top: userNameLabel.bottomAnchor,
                          leading: userNameLabel.leadingAnchor,
                          bottom: dateLabel.topAnchor,
                          trailing: mainView.trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
        
        middleView.addArrangedSubview(textView)
        middleView.addArrangedSubview(galleryView)
        middleView.addArrangedSubview(tagsView)
        
        textView.anchorSize(size: CGSize(width: 0, height: 40))
        galleryView.anchorSize(size: CGSize(width: 0, height: 150))
        tagsView.anchorSize(size: CGSize(width: 0, height: 80))
        
        
        dateLabel.anchor(top: middleView.bottomAnchor,
                         leading: userNameLabel.leadingAnchor,
                         bottom: mainView.bottomAnchor,
                         trailing: nil,
                         padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0),
                         size: CGSize(width: 0, height: 15))
        
        replyButton.anchorCenter(centerY: dateLabel.centerYAnchor, centerX: nil)
        replyButton.anchor(top: nil,
                           leading: dateLabel.trailingAnchor,
                           bottom: nil,
                           trailing: nil,
                           size: CGSize(width: 60, height: 15))
        
        likesView.anchor(top: middleView.bottomAnchor,
                         leading: nil,
                         bottom: mainView.bottomAnchor,
                         trailing: mainView.trailingAnchor,
                         padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0),
                         size: CGSize(width: 50, height: 15))
        
        likesView.addSubview(likesImage)
        likesView.addSubview(likesLabel)
        
        helpInForLayer(view: likesView, imageView: likesImage, label: likesLabel)
    }
    
    private func helpInForLayer(view: UIView, imageView: UIImageView, label: UILabel) {
        
        // imageView constraint
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        //label constrants
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc private func replyButtonPressed() {
        guard let postId = postId else { return }
        delegate?.replyButtonPressed(postId: postId)
    }
    
    @objc private func likesViewTouched() {
        guard let postId = postId else { return }
        likeCount = isLiked ? likeCount - 1 : likeCount + 1
        isLiked = !isLiked
        delegate?.likeTouched(postId: postId)
    }
    
    @objc private func touchCommentActionsButton() {
        guard let postId = postId else { return }
        delegate?.commentActionsPressed(postId: postId)
    }
}

extension SocialCommentTableViewCell: SocialTextViewDelegate {
    func wordRecognized(word: String) {
        guard let tag = postTags.first(where: { $0.title == word }) else { return }
        delegate?.commentTagPressed(tag: tag)
    }
}

extension SocialCommentTableViewCell: SocialPostTagsViewDelegate {
    func tagPressed(tag: PostTag) {
        delegate?.commentTagPressed(tag: tag)
    }
}
