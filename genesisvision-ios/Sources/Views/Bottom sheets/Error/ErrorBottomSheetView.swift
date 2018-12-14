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
    var successCompletionBlock: SuccessCompletionBlock?
    
    // MARK: - IBOutlets
    @IBOutlet var topBackgroundImageView: UIImageView!
    @IBOutlet var iconStackView: UIStackView! {
        didSet {
            iconStackView.isHidden = true
        }
    }
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.isHidden = true
        }
    }
    @IBOutlet var titleLabel: TitleLabel! {
        didSet {
            titleLabel.setLineSpacing(lineSpacing: 3.0)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.getFont(.regular, size: 14.0)
            titleLabel.isHidden = true
        }
    }
    @IBOutlet var subtitleLabel: SubtitleLabel! {
        didSet {
            subtitleLabel.isHidden = true
            subtitleLabel.setLineSpacing(lineSpacing: 3.0)
            subtitleLabel.textAlignment = .center
        }
    }
    
    @IBOutlet var okButton: ActionButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Private methods
    func configure(_ type: ErrorBottomSheetViewType, title: String? = nil, subtitle: String? = nil, completion: SuccessCompletionBlock? = nil) {
        self.successCompletionBlock = completion
        
        switch type {
        case .error:
            iconImageView.image = #imageLiteral(resourceName: "img_error_icon")
            iconImageView.isHidden = false
            iconStackView.isHidden = false
        case .success:
            iconImageView.image = #imageLiteral(resourceName: "img_success_icon")
            iconImageView.isHidden = false
            iconStackView.isHidden = false
        case .warning:
            iconImageView.image = #imageLiteral(resourceName: "img_error_icon")
            iconImageView.isHidden = false
            iconStackView.isHidden = false
        case .text:
            okButton.isHidden = true
            topBackgroundImageView.isHidden = true
        }
        
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false
        }
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
            
            if title != nil {
                titleLabel.font = UIFont.getFont(.semibold, size: 14.0)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func okButtonAction(_ sender: UIButton) {
        bottomSheetController?.dismiss()
        
        if let successCompletionBlock = successCompletionBlock {
            successCompletionBlock(true)
        }
    }
}

extension ErrorBottomSheetView: BottomSheetControllerProtocol {
    func didHide() {
        if let successCompletionBlock = successCompletionBlock {
            successCompletionBlock(true)
        }
    }
}
