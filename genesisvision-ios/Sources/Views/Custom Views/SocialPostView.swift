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
}

final class SocialPostView: UIView {
    //MARK: First Layer
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
//    private let middleView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
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
    
    let galleryView: ImagesGalleryView = {
        let imageView = ImagesGalleryView()
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
    
    var postTags: [PostTag]  = [] {
        didSet {
            if let postTag = postTags.first(where: { $0.type == .event }), let eventModel = postTag.event, let assetDetails = postTag.assetDetails {
                eventView.configure(event: eventModel, assetDetails: assetDetails)
            }
            tagsView.viewModels = postTags.filter({ $0.type != .event })
        }
    }
    
    var socialPostHeightConstraints: [SocialCellHeightConstraintType: NSLayoutConstraint] = [:]
    
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
//        middleView.addSubview(textView)
//        middleView.addSubview(postImageView)
//        middleView.addSubview(tagsView)
//        middleView.addSubview(eventView)
        middleView.addArrangedSubview(textView)
        middleView.addArrangedSubview(galleryView)
        
        middleView.addArrangedSubview(eventView)
        middleView.addArrangedSubview(tagsView)
        
        textView.anchorSize(size: CGSize(width: 0, height: socialPostViewSizes?.textViewHeight ?? 0))
        galleryView.anchorSize(size: CGSize(width: 0, height: socialPostViewSizes?.imageViewHeight ?? 0))
        tagsView.anchorSize(size: CGSize(width: 0, height: socialPostViewSizes?.tagViewHeight ?? 0))
        eventView.anchorSize(size: CGSize(width: 0, height: 50))
        
//        textView.anchor(top: nil, leading: middleView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10), size: CGSize(width: 0, height: socialPostViewSizes?.textViewHeight ?? 0))
        
//        postImageView.anchor(top: nil, leading: middleView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: socialPostViewSizes?.imageViewHeight ?? 0))
//
//        tagsView.anchor(top: nil, leading: middleView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: socialPostViewSizes?.tagViewHeight ?? 0))
//
//        eventView.anchor(top: nil, leading: middleView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor, size: CGSize(width: 0, height: 60))

//        textView.anchor(top: middleView.topAnchor, leading: middleView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10), size: CGSize(width: 0, height: socialPostViewSizes?.textViewHeight ?? 0))
//
//        postImageView.anchor(top: textView.bottomAnchor, leading: middleView.leadingAnchor, bottom: nil, trailing: middleView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0), size: CGSize(width: 0, height: socialPostViewSizes?.imageViewHeight ?? 0))
//
//        tagsView.anchor(top: nil, leading: middleView.leadingAnchor, bottom: middleView.bottomAnchor, trailing: middleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: socialPostViewSizes?.tagViewHeight ?? 0))
//
//        eventView.anchor(top: middleView.topAnchor, leading: middleView.leadingAnchor, bottom: tagsView.topAnchor, trailing: middleView.trailingAnchor, size: CGSize(width: 0, height: 60))
    }
    
    func updateMiddleViewConstraints() {
        middleView.removeAllArrangedSubviewsCompletely()
        textView.removeFromSuperview()
        galleryView.removeFromSuperview()
        tagsView.removeFromSuperview()
        overlayMiddleView()
    }
    
    @objc private func touchUserView() {
        delegate?.userOwnerPressed()
    }
    
    @objc private func touchPostActionsButton() {
        delegate?.postActionsPressed()
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
