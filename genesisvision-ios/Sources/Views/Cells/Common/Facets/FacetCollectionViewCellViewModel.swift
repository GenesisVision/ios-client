//
//  FacetCollectionViewCellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 19/11/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation
import Kingfisher

struct FacetCollectionViewCellViewModel {
    let facet: AssetFacet?
    let isFavoriteFacet: Bool
}

extension FacetCollectionViewCellViewModel: CellViewModel {
    func setup(on cell: FacetCollectionViewCell) {
        if let title = facet?.title {
            cell.titleLabel.text = title
        }
        
        cell.detailLabel.isHidden = true
        if let description = facet?._description {
            cell.detailLabel.isHidden = false
            cell.detailLabel.text = description
        }
        
        cell.bgImageView.image = nil
        cell.iconImageView.isHidden = true
        
        if isFavoriteFacet {
            cell.iconImageView.isHidden = false
            cell.iconImageView.image = #imageLiteral(resourceName: "img_favorite_icon_selected").withRenderingMode(.alwaysTemplate)
            
            cell.bgImageView.image = #imageLiteral(resourceName: "img_facet_favorites_bg")
        } else if let fileName = facet?.logoUrl, let fileUrl = getFileURL(fileName: fileName) {
            cell.bgImageView.kf.indicatorType = .activity
            cell.bgImageView.kf.setImage(with: fileUrl)
        }
    }
}

