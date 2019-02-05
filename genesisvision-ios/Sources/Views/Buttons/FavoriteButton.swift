//
//  FavoriteButton.swift
//  genesisvision-ios
//
//  Created by George on 27/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIButton

class FavoriteButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
        tintColor = UIColor.Common.primary
        
        setImage(#imageLiteral(resourceName: "img_favorite_icon"), for: .normal)
        setImage(#imageLiteral(resourceName: "img_favorite_icon_selected"), for: .selected)
    }
}

