//
//  BaseNavigationController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 16.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    var shadowView: ShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationBar.barTintColor = UIColor.NavBar.colorScheme().backgroundColor
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.NavBar.colorScheme().tintColor
        
        shadowView = ShadowView()
//        view.insertSubview(shadowView, belowSubview: navigationBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.frame = navigationBar.frame
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppearanceController.theme == .dark ? .lightContent : .default
    }
}
