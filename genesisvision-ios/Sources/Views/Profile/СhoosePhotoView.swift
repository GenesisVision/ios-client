//
//  СhoosePhotoView.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 04.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class СhoosePhotoView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var editImageView: UIImageView!
    
    @IBOutlet weak var choosePhotoButton: UIButton! {
        didSet {
            choosePhotoButton.backgroundColor = .clear
        }
    }
    
    // MARK: - Variables
    var state: EditableState = .edit {
        didSet {
            choosePhotoButton?.isHidden = state == .show
            shadowView?.isHidden = state == .show
            editImageView?.isHidden = state == .show
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editImageView.isHidden = true
        editImageView.tintColor = UIColor.Font.white
        editImageView.image = #imageLiteral(resourceName: "img_add_photo_icon")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        choosePhotoButton?.isHidden = state == .show
        shadowView?.isHidden = state == .show
        editImageView?.isHidden = state == .show
    }
}

