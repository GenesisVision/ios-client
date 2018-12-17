//
//  TableViewCell.swift
//  genesisvision-ios
//
//  Created by George on 11/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//


import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel?.font = UIFont.getFont(.regular, size: 14.0)
        textLabel?.textColor = UIColor.Cell.title
        textLabel?.backgroundColor = .clear
        
        detailTextLabel?.font = UIFont.getFont(.regular, size: 12.0)
        detailTextLabel?.textColor = UIColor.Cell.subtitle
        detailTextLabel?.backgroundColor = .clear
        
        contentView.backgroundColor = UIColor.BaseView.bg
        backgroundColor = UIColor.BaseView.bg
        tintColor = UIColor.Cell.title
        accessoryView?.backgroundColor = UIColor.BaseView.bg
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.BaseView.bg
        contentView.backgroundColor = UIColor.BaseView.bg
    }
}

