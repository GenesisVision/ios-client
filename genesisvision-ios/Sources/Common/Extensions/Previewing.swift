//
//  Previewing.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

extension UIViewControllerPreviewingDelegate where Self: UIViewController {
    @discardableResult
    func registerForPreviewing() -> Bool {
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
            return true
        } else {
            return false
        }
    }
}
