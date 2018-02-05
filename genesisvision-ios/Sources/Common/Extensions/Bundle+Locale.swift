//
//  Bundle+Locale.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

extension Bundle {
    var locale: Locale {
        let language = self.preferredLocalizations[0]
        let locale = Locale(identifier: language)
        return locale
    }
}
