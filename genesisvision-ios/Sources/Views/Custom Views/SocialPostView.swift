//
//  SocialPostView.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 13.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

enum SocialCellHeightConstraintType {
    case tagsView
    case eventView
    case textView
    case postImageView
    case postImagesGallery
}

protocol SocialPostViewDelegate: AnyObject {
    func tagPressed(tag: PostTag)
    func userOwnerPressed()
    func postActionsPressed()
    func imagePressed(index: Int, image: ImagesGalleryCollectionViewCellViewModel)
    func touchExpandButton()
    func openPost()
}
//MARK: - Post custom view
final class SocialPostView: UIView {
    //MARK: First Layer
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let middleView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.axis = .vertical
        view.spacing = 5
        view.distribution = .equalSpacing
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
    
     let postActionsButton: UIButton = {
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
    
    let pinSymbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.image = #imageLiteral(resourceName: "social_pin_icon")
        imageView.isHidden = true
        return imageView
    }()
    
    let openUserButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    
    let textView: SocialTextView = {
        let textView = SocialTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont.getFont(.regular, size: 16)
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        textView.isScrollEnabled = false
        textView.textColor = UIColor.white
        textView.isSelectable = true
//        textView.dataDetectorTypes = .link
        return textView
    }()
    //MARK: - Изменил тип вью
    let galleryView: PostImagesGalleryView = {
        let imageView = PostImagesGalleryView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let eventView: SocialEventView = {
        let view = SocialEventView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    let tagsView: SocialPostTagsView = {
        let socialPostTagsView = SocialPostTagsView()
        socialPostTagsView.translatesAutoresizingMaskIntoConstraints = false
        socialPostTagsView.backgroundColor = .clear
        socialPostTagsView.isHidden = true
        return socialPostTagsView
    }()
    
    let expandButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.getFont(.regular, size: 16)
        let color = UIColor(red: 81, green: 180, blue: 169)
        button.setTitleColor(color, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Expand...", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var postTags: [PostTag]  = [] {
        didSet {
            if let postTag = postTags.first(where: { $0.type == .event }), let eventModel = postTag.event, let assetDetails = postTag.assetDetails {
                eventView.configure(event: eventModel, assetDetails: assetDetails)
            }
            tagsView.viewModels = postTags.filter({ $0.type != .event }).filter({ $0.type != .url })
        }
    }
    
    var socialPostViewSizes: SocialPostViewSizes?
    weak var delegate: SocialPostViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        tagsView.delegate = self
        textView.wordRecognizerDelegate = self
        galleryView.delegate = self
        overlayZeroLayer()
        overlayTopView()
        overlayMiddleView()
    }
    
    private func overlayZeroLayer() {
        addSubview(topView)
        addSubview(middleView)
        topView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 70))
        
        middleView.anchor(top: topView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    private func overlayTopView() {
        topView.addSubview(userImageView)
        topView.addSubview(userNameLabel)
        topView.addSubview(dateLabel)
        topView.addSubview(postActionsButton)
        topView.addSubview(pinSymbolImageView)
        topView.addSubview(openUserButton)
        
        userImageView.anchor(top: nil, leading: topView.leadingAnchor, bottom: nil, trailing: nil)
        userImageView.anchorCenter(centerY: topView.centerYAnchor, centerX: nil)
        userImageView.anchorSize(size: CGSize(width: 50, height: 50))
        userImageView.roundCorners(with: 25)
        
        userNameLabel.anchor(top: topView.topAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: pinSymbolImageView.leadingAnchor, padding: UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 0))
        userNameLabel.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.4).isActive = true

        dateLabel.anchor(top: userNameLabel.bottomAnchor, leading: userImageView.trailingAnchor, bottom: nil, trailing: pinSymbolImageView.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 0))
        dateLabel.anchorSize(size: CGSize(width: 0, height: 17))
        
        pinSymbolImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: postActionsButton.leadingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 20), size: CGSize(width: 15, height: 15))
        pinSymbolImageView.anchorCenter(centerY: postActionsButton.centerYAnchor, centerX: nil)
        
        postActionsButton.addTarget(self, action: #selector(touchPostActionsButton), for: .touchUpInside)
        postActionsButton.anchor(top: topView.topAnchor, leading: nil, bottom: nil, trailing: topView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 5))
        postActionsButton.anchorSize(size: CGSize(width: 20, height: 50))
        
        openUserButton.addTarget(self, action: #selector(touchUserView), for: .touchUpInside)
        openUserButton.anchor(top: topView.topAnchor, leading: topView.leadingAnchor, bottom: topView.bottomAnchor, trailing: nil)
        openUserButton.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.8).isActive = true
        topView.bringSubviewToFront(openUserButton)
    }
    
    private func overlayMiddleView() {
        
        var isPostExpanded = false
        if let expanded = socialPostViewSizes?.isExpanded {
            if expanded {
                isPostExpanded = expanded
            }
        }
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(openPost))
        textView.addGestureRecognizer(labelTap)
                        
        middleView.addArrangedSubview(textView)
        middleView.addArrangedSubview(expandButton)
        middleView.addArrangedSubview(galleryView)
        middleView.addArrangedSubview(eventView)
        middleView.addArrangedSubview(tagsView)

        galleryView.anchorSize(size: CGSize(width: 0, height: socialPostViewSizes?.imageViewHeight ?? 0))
        tagsView.anchorSize(size: CGSize(width: 0, height: socialPostViewSizes?.tagViewHeight ?? 0))
        eventView.anchorSize(size: CGSize(width: 0, height: 50))
        textView.anchor(top: middleView.topAnchor, leading: middleView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor)
        
        if Int((socialPostViewSizes?.fullTextViewHeight ?? 0)) > 250 && !isPostExpanded {
            expandButton.isHidden = false
            textView.bottomAnchor.constraint(equalTo: middleView.topAnchor, constant: 250).isActive = true
            expandButton.addTarget(self, action: #selector(touchExpandButton), for: .touchUpInside)
            expandButton.anchor(top: textView.bottomAnchor, leading: textView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor)
            expandButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20).isActive = true
        } else if isPostExpanded {
            middleView.removeArrangedSubviewCompletely(expandButton)
            expandButton.isHidden = true
            textView.bottomAnchor.constraint(equalTo: middleView.topAnchor, constant: (socialPostViewSizes?.fullTextViewHeight ?? 250)).isActive = true
        } else {
            middleView.removeArrangedSubviewCompletely(expandButton)
            expandButton.isHidden = true
            textView.bottomAnchor.constraint(equalTo: middleView.topAnchor, constant: socialPostViewSizes?.textViewHeight ?? 0).isActive = true
        }
    }
    
    func updateMiddleViewConstraints() {
        middleView.removeAllArrangedSubviewsCompletely()
        overlayMiddleView()
    }
    
    @objc private func touchUserView() {
        delegate?.userOwnerPressed()
    }
    
    @objc private func touchPostActionsButton() {
        delegate?.postActionsPressed()
    }
    
    @objc private func touchExpandButton() {
        delegate?.touchExpandButton()
    }
    
    @objc private func openPost() {
        delegate?.openPost()
    }
}

extension SocialPostView: SocialTextViewDelegate {
    func wordRecognized(word: String) {
        guard let tag = postTags.first(where: { $0.title == word }) else {
            delegate?.openPost()
            return }
        delegate?.tagPressed(tag: tag)
    }
}

extension SocialPostView: SocialPostTagsViewDelegate {
    func tagPressed(tag: PostTag) {
        delegate?.tagPressed(tag: tag)
    }
}

extension SocialPostView: ImagesGalleryViewDelegate {
    func imagePressed(index: Int, image: ImagesGalleryCollectionViewCellViewModel) {
        delegate?.imagePressed(index: index, image: image)
    }
}
