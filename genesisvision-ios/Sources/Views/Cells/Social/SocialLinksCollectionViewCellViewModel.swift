//
//  SocialLinksCollectionViewCell.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 19.11.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

struct SocialLinksCollectionViewCellViewModel {
    let logoUrl: String
}

extension SocialLinksCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: SocialLinksCollectionViewCell) {
        if let fileUrl = getFileURL(fileName: logoUrl) {
            cell.imageView.isHidden = false
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: fileUrl)
        } else {
            cell.imageView.image = UIImage.profilePlaceholder
        }
        
        cell.imageView.roundCorners()
    }
}

class SocialLinksCollectionViewCell: UICollectionViewCell {
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.roundCorners()
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
        
        contentView.addSubview(imageView)
        
        imageView.fillSuperview()
    }
}
