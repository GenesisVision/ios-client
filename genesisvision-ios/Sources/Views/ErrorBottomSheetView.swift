//
//  ErrorBottomSheetView.swift
//  genesisvision-ios
//
//  Created by George on 23/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

protocol ErrorBottomSheetViewProtocol: class {
    func okButtonDidPress()
}

enum ErrorBottomSheetViewType {
    case success
    case error
    case warning
    case text
}

class ErrorBottomSheetView: UIView {
    // MARK: - Variables
    weak var delegate: ErrorBottomSheetViewProtocol?
    
    var bottomSheetController: BottomSheetController?
    var errorType: ErrorBottomSheetViewType?
    var completion: ((Bool) -> Void)?
    
    // MARK: - IBOutlets
    @IBOutlet var topBackgroundImageView: UIImageView!
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.isHidden = true
        }
    }
    @IBOutlet var titleLabel: TitleLabel! {
        didSet {
            titleLabel.isHidden = true
        }
    }
    @IBOutlet var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.isHidden = true
        }
    }
    
    @IBOutlet var okButton: ActionButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Private methods
    func configure(type: ErrorBottomSheetViewType, title: String? = nil, subtitle: String? = nil, completion: ((Bool) -> Void)? = nil) {
        self.completion = completion
        
        switch type {
        case .error:
            iconImageView.image = #imageLiteral(resourceName: "img_error_icon")
            iconImageView.isHidden = false
        case .success:
            iconImageView.image = #imageLiteral(resourceName: "img_success_icon")
            iconImageView.isHidden = false
        case .warning:
            iconImageView.image = #imageLiteral(resourceName: "img_error_icon")
            iconImageView.isHidden = false
        case .text:
            break
        }
        
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false
        }
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        }
    }
    
    // MARK: - Actions
    @IBAction func okButtonAction(_ sender: UIButton) {
        bottomSheetController?.dismiss()
        
        if let completion = completion {
            completion(true)
        }
    }
}
