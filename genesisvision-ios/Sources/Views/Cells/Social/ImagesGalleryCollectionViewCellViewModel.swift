//
//  ImagesGalleryCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 01.12.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol ImagesGalleryCollectionViewCellDelegate: AnyObject {
    func removeImage(imageUrl: String)
}

struct ImagesGalleryCollectionViewCellViewModel {
    let imageUrl: String
    let resize: PostImageResize?
    let image: UIImage?
    let showRemoveButton: Bool
    weak var delegate: ImagesGalleryCollectionViewCellDelegate?
}

extension ImagesGalleryCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: ImagesGalleryCollectionViewCell) {
        
        if let image = image {
            cell.imageView.image = image
        } else if let logoUrl = URL(string: imageUrl) {
            cell.imageView.kf.setImage(with: logoUrl)
        }
        
        cell.removeButton.isHidden = !showRemoveButton
        cell.imageUrl = imageUrl
        cell.delegate = delegate
        cell.clipsToBounds = true
    }
}

class ImagesGalleryCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "img_cancel")
        button.tintColor = UIColor.primary
        button.setImage(image, for: .normal)
        return button
    }()
    
    var imageUrl: String?
    weak var delegate: ImagesGalleryCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        removeButton.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
        addSubview(imageView)
        addSubview(removeButton)
        
        imageView.fillSuperview(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        removeButton.anchor(top: topAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: trailingAnchor,
                            size: CGSize(width: 10, height: 10))
    }
    
    @objc private func removeButtonPressed() {
        guard let imageUrl = imageUrl else { return }
        delegate?.removeImage(imageUrl: imageUrl)
    }
}
