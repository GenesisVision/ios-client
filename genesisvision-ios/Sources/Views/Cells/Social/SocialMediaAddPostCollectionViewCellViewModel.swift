//
//  SocialMediaAddPostCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 12.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialMediaAddPostCollectionViewCellProtocol: class {
    func shareIdeasButtonPressed()
}

struct SocialMediaAddPostCollectionViewCellViewModel {
    let imageUrl: String
    weak var delegate: SocialMediaAddPostCollectionViewCellProtocol?
}

extension SocialMediaAddPostCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialMediaAddPostCollectionViewCell) {
        cell.delegate = delegate
        
        if let fileUrl = getFileURL(fileName: imageUrl), isPictureURL(url: fileUrl.absoluteString) {
            cell.userImageView.kf.indicatorType = .activity
            cell.userImageView.kf.setImage(with: fileUrl)
        } else {
            cell.userImageView.image = UIImage.profilePlaceholder
        }
    }
}

class SocialMediaAddPostCollectionViewCell: UICollectionViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Common.darkCell
        return view
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.profilePlaceholder
        return imageView
    }()
    
    private let buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Share your ideas", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor.Common.darkTextPlaceholder, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    weak var delegate: SocialMediaAddPostCollectionViewCellProtocol?
    
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
        
        overlayZeroLayer()
        overlayFirstLayer()
        overlaySecondLayer()
    }
    
    private func overlayZeroLayer() {
        contentView.addSubview(mainView)
        mainView.fillSuperview()
        mainView.roundCorners(with: 25)
    }
    
    private func overlayFirstLayer() {
        mainView.addSubview(userImageView)
        mainView.addSubview(buttonView)
        
        userImageView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: nil, size: CGSize(width: 50, height: 50))
        
        userImageView.roundCorners(with: 25)
        
        buttonView.anchor(top: mainView.topAnchor, leading: userImageView.trailingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30))
    }
    
    private func overlaySecondLayer() {
        buttonView.addSubview(button)
        
        button.fillSuperview(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        print("Button Pressed")
        delegate?.shareIdeasButtonPressed()
    }
}
