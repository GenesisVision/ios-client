//
//  UICollectionView+CellViewModel.swift
//  genesisvision-ios
//
//  Created by George on 09/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UICollectionView

extension UICollectionView {
    func dequeueReusableCell(withModel model: CellViewAnyModel, for indexPath: IndexPath) -> UICollectionViewCell {
        let indetifier = String(describing: type(of: model).cellAnyType)
        let cell = dequeueReusableCell(withReuseIdentifier: indetifier, for: indexPath)
        
        model.setupDefault(on: cell)
        
        return cell
    }
}


