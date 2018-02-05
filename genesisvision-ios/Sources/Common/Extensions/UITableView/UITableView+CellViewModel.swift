//
//  UITableView+CellViewModel.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    func dequeueReusableCell(withModel model: CellViewAnyModel, for indexPath: IndexPath) -> UITableViewCell {
        let indetifier = String(describing: type(of: model).cellAnyType)
        let cell = dequeueReusableCell(withIdentifier: indetifier, for: indexPath)
        
        model.setupDefault(on: cell)
        
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        let identifier = T.identifier
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T
    }
}

