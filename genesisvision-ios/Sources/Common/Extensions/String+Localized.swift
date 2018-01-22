//
//  String+Localized.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 18.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation.NSString

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
