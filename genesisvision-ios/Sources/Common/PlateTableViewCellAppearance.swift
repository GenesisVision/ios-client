//
//  PlateTableViewCellAppearance.swift
//  genesisvision-ios
//
//  Created by George on 27/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

@objc
class PlateTableViewCellAppearance: NSObject {
    let cornerRadius: CGFloat
    let horizontalMarginValue: CGFloat
    let verticalMarginValues: CGFloat
    let backgroundColor: UIColor
    let selectedBackgroundColor: UIColor

    init(cornerRadius: CGFloat,
        horizontalMarginValue: CGFloat,
        verticalMarginValues: CGFloat,
        backgroundColor: UIColor,
        selectedBackgroundColor: UIColor) {
        self.cornerRadius = cornerRadius
        self.horizontalMarginValue = horizontalMarginValue
        self.verticalMarginValues = verticalMarginValues
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
    }
}
