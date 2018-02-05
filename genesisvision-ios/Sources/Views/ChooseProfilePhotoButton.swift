//
//  ChooseProfilePhotoButton.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class ChooseProfilePhotoButton: UIButton {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet private var addImageView: UIImageView!
    
    var borderColor: UIColor!
    private var borderTappedColor: UIColor {
        return UIColor.Button.darkBorder
    }
    private var borderWidth: CGFloat {
        return photoImageView.bounds.height * Constants.SystemSizes.imageViewBorderWidthPercentage
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return self.loadFromNibIfEmbeddedInDifferentNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        (isHighlighted || isSelected) ? buttonTappedState() : buttonDefaultState()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderColor = .white
    }
    
    private func buttonTappedState() {
        photoImageView.roundWithBorder(borderWidth, color: borderTappedColor)
        addImageView.roundWithBorder(borderWidth, color: borderTappedColor)
        photoImageView.backgroundColor = borderTappedColor
        addImageView.backgroundColor = borderTappedColor
    }
    
    private func buttonDefaultState() {
        photoImageView.roundWithBorder(borderWidth, color: borderColor)
        addImageView.roundWithBorder(borderWidth, color: borderColor)
        photoImageView.backgroundColor = .clear
        addImageView.backgroundColor = borderColor
    }
    
}

