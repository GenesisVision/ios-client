//
//  UITableView+Registration.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    func registerNibs(for types: [UITableViewCell.Type]) {
        types.forEach { (type) in
            registerNib(for: type)
        }
    }
    
    func registerNibs(for types: [CellViewAnyModel.Type]) {
        types.forEach { (type) in
            if let tableCellClass = type.cellAnyType as? UITableViewCell.Type {
                registerNib(for: tableCellClass)
            }
        }
    }
    
    func registerNib(for cellClass: UITableViewCell.Type) {
        register(cellClass.nib, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func registerHeaderNib(for headerClass: [UITableViewHeaderFooterView.Type]) {
        headerClass.forEach { (headerType) in
            registerHeaderNib(for: headerType)
        }
    }
    
    func registerHeaderNib(for headerClass: UITableViewHeaderFooterView.Type) {
        register(headerClass.nib, forHeaderFooterViewReuseIdentifier: headerClass.identifier)
    }
    
    func registerClass(for cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
}

