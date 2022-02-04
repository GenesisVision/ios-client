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
        cell.imageView.clipsToBounds = true
    }
}

extension ImagesGalleryCollectionViewCellViewModel {
    func setupMoreImageButton(on cell: ImagesGalleryCollectionViewCell, remainImagesCount: Int) {
        setup(on: cell)
        
        cell.imageView.subviews.forEach({ $0.removeFromSuperview() })
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: cell.imageView.width, height: cell.imageView.height)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        cell.imageView.addSubview(blurEffectView)
        
        let countLabel : UILabel = {
            let label = UILabel()
            label.text = "+\(remainImagesCount)"
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 24)
            return label
        }()
        countLabel.frame = CGRect(x: cell.imageView.center.x / 2, y: cell.imageView.center.y / 2, width: 50, height: 50)
        blurEffectView.contentView.addSubview(countLabel)
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
        
//        imageView.fillSuperview(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        imageView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
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
