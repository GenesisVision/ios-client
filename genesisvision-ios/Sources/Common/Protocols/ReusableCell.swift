//
//  ReusableCell.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UINib

protocol ReusableCell {
    static var identifier: String { get }
    static var nib: UINib { get }
}
