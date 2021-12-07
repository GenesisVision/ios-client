//
//  SocialFeedDeletedPostCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 26.12.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialFeedDeletedPostCollectionViewCellDelegate: AnyObject {
    func undoButtonPressed(postId: UUID)
}

struct SocialFeedDeletedPostCollectionViewCellViewModel {
    let post: Post
    weak var delegate: SocialFeedDeletedPostCollectionViewCellDelegate?
}

extension SocialFeedDeletedPostCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialFeedDeletedPostCollectionViewCell) {
        cell.delegate = delegate
        cell.postId = post._id
        cell.titleLabel.text = "The post is deleted"
    }
}


class SocialFeedDeletedPostCollectionViewCell: UICollectionViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: TitleLabel = {
        let label = TitleLabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let undoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = UIFont.getFont(.semibold, size: 13.0)
        button.setTitleColor(UIColor.primary, for: .normal)
        return button
    }()
    
    var postId: UUID?
    weak var delegate: SocialFeedDeletedPostCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.Common.darkCell
        undoButton.addTarget(self, action: #selector(undoButtonPressed), for: .touchUpInside)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    private func setupUI() {
        contentView.addSubview(mainView)
        
        mainView.fillSuperview(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(undoButton)
        
        titleLabel.anchor(top: mainView.topAnchor,
                          leading: mainView.leadingAnchor,
                          bottom: mainView.bottomAnchor,
                          trailing: undoButton.leadingAnchor)
        
        undoButton.anchor(top: mainView.topAnchor,
                          leading: titleLabel.trailingAnchor,
                          bottom: mainView.bottomAnchor,
                          trailing: mainView.trailingAnchor, size: CGSize(width: 50, height: 30))
    }
    
    @objc private func undoButtonPressed() {
        guard let postId = postId else { return }
        delegate?.undoButtonPressed(postId: postId)
    }
}
