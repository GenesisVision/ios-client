//
//  InfoViewModel.swift
//  genesisvision-ios
//
//  Created by George on 02/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIImage

protocol InfoViewModel {

    var iconImage: UIImage { get }
    var text: String { get }
    
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var tintColor: UIColor { get }
    var textFont: UIFont { get }
    
    var router: Router! { get }
    
    func goBack()
}
