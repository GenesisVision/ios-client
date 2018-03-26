//
//  UITableViewCellExtension.swift
//  genesisvision-ios
//
//  Created by George on 22/03/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UITableViewCell

extension UITableViewCell {
    func addDashedBottomLine() {
        addLine(to: self, start: CGPoint(x: 16, y: 0), end: CGPoint(x: frame.size.width - 16, y: 0), style: .dashed, color: UIColor.Cell.separator)
    }
    
    func addSolidBottomLine() {
        addLine(to: self, start: CGPoint(x: 0, y: 0), end: CGPoint(x: frame.size.width, y: 0), style: .solid, color: UIColor.Cell.separator)
    }
}
