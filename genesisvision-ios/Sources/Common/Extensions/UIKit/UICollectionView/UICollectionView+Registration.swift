//
//  UICollectionView+Registration.swift
//  genesisvision-ios
//
//  Created by George on 09/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UICollectionView

extension UICollectionView {
    func registerNibs(for types: [UICollectionViewCell.Type]) {
        types.forEach { (type) in
            registerNib(for: type)
        }
    }
    
    func registerNibs(for types: [CellViewAnyModel.Type]) {
        types.forEach { (type) in
            if let collectionCellClass = type.cellAnyType as? UICollectionViewCell.Type {
                registerNib(for: collectionCellClass)
            }
        }
    }
    
    func registerNib(for cellClass: UICollectionViewCell.Type) {
        register(cellClass.nib, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func registerClass(for cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
}


