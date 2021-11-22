//
//  SocialActivitiesView.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 18.12.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialActivitiesViewDelegateProtocol: AnyObject {
    func likeTouched()
    func commentTouched()
    func shareTouched()
}

final class SocialActivitiesView: UIView {
    
    let likesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sharesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // fouth layer on bottomView
    
    let likesImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "like")
        return view
    }()
    
    let commentsImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "comment")
        return view
    }()
    
    let sharesImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "share")
        return view
    }()
    
    let viewsImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "eye")
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
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let sharesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let viewsLabel: UILabel = {
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
    
    weak var delegate: SocialActivitiesViewDelegateProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        overlaySubviews()
        setupGestRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        overlaySubviews()
        setupGestRecognizers()
    }
    
    private func setup() {
        addSubview(likesView)
        addSubview(commentsView)
        addSubview(sharesView)
        addSubview(viewsView)
        
        // likesView constraints
        likesView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: 80, height: 44))
        
        sharesView.anchor(top: topAnchor,
                            leading: likesView.trailingAnchor,
                            bottom: nil,
                            trailing: nil,
                            size: CGSize(width: 80, height: 44))
        
        commentsView.anchor(top: topAnchor,
                            leading: sharesView.trailingAnchor,
                            bottom: nil,
                            trailing: nil,
                            size: CGSize(width: 80, height: 44))
        
        viewsView.anchor(top: topAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: trailingAnchor,
                          size: CGSize(width: 80, height: 44))
        
    }
    
    private func setupGestRecognizers() {
        let likesGest = UITapGestureRecognizer(target: self, action: #selector(likesViewTouched))
        likesImage.addGestureRecognizer(likesGest)
        
        let commentsGest = UITapGestureRecognizer(target: self, action: #selector(commentsViewTouched))
        commentsImage.addGestureRecognizer(commentsGest)
        
        let sharesGest = UITapGestureRecognizer(target: self, action: #selector(sharesViewTouched))
        sharesImage.addGestureRecognizer(sharesGest)
    }
    
    private func overlaySubviews() {
        likesView.addSubview(likesImage)
        likesView.addSubview(likesLabel)
        
        commentsView.addSubview(commentsImage)
        commentsView.addSubview(commentsLabel)
        
        sharesView.addSubview(sharesImage)
        sharesView.addSubview(sharesLabel)
        
        viewsView.addSubview(viewsImage)
        viewsView.addSubview(viewsLabel)
        
        helpInForLayer(view: likesView, imageView: likesImage, label: likesLabel)
        helpInForLayer(view: commentsView, imageView: commentsImage, label: commentsLabel)
        helpInForLayer(view: sharesView, imageView: sharesImage, label: sharesLabel)
        helpInForLayer(view: viewsView, imageView: viewsImage, label: viewsLabel)
    }
    
    private func helpInForLayer(view: UIView, imageView: UIImageView, label: UILabel) {
        
        // imageView constraint
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        //label constrants
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc private func likesViewTouched() {
        likeCount = isLiked ? likeCount - 1 : likeCount + 1
        isLiked = !isLiked
        delegate?.likeTouched()
    }
    
    @objc private func commentsViewTouched() {
        delegate?.commentTouched()
    }
    
    @objc private func sharesViewTouched() {
        delegate?.shareTouched()
    }
}
