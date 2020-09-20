//
//  UINavigationBar.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 01.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit


extension UINavigationBar {
    func setNavigationBarFullTransluent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
    }
    
    func resetNavigationBarTransluent() {
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
        isTranslucent = false
    }
}
