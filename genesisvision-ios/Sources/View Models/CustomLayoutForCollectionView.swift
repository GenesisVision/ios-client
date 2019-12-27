//
//  CustomLayoutForCollectionView.swift
//  genesisvision-ios
//
//  Created by George on 17.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class CustomLayout {
    static func defaultLayout(_ hCount: Int = 2, pagging: Bool = true, vCount: Int = 1) -> UICollectionViewLayout {
        var fractionalWidth: CGFloat = 0.8
        switch hCount {
        case 1:
            fractionalWidth = 0.8
        case 2:
            fractionalWidth = 0.5
        case 3:
            fractionalWidth = 0.35
        default:
            break
        }
        
        var layout: UICollectionViewLayout!
        if #available(iOS 13.0, *) {
            layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWidth), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                let itemInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0.0, leading: Constants.SystemSizes.Cell.horizontalMarginValue / 2, bottom: Constants.SystemSizes.Cell.verticalMarginValues, trailing: Constants.SystemSizes.Cell.horizontalMarginValue / 2)
                let sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0.0, leading: Constants.SystemSizes.Cell.horizontalMarginValue, bottom: Constants.SystemSizes.Cell.verticalMarginValues, trailing: Constants.SystemSizes.Cell.horizontalMarginValue)
                
                item.contentInsets = itemInset
                let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitem: item, count: vCount)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = sectionInset
                section.orthogonalScrollingBehavior = pagging ? .groupPaging : .continuous
                return section
//                let sectionInset: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: Constants.SystemSizes.Cell.verticalMarginValues, trailing: 0.0)
            }
        } else {
            // Fallback on earlier versions
        }
        return layout
    }
}
