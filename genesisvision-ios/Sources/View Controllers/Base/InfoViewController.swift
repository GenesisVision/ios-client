//
//  InfoViewController.swift
//  genesisvision-ios
//
//  Created by George on 02/04/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class InfoViewController: BaseViewController {
    
    var viewModel: InfoViewModel?
    
    // MARK: - Buttons
    @IBOutlet var okButton: ActionButton!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    private func setupUI() {
        if let iconImage = viewModel?.iconImage {
            iconImageView.image = iconImage
        }
        
        if let text = viewModel?.text {
            textLabel.text = text
        }
        
        if let textFont = viewModel?.textFont {
            textLabel.font = textFont
        }
        
        if let backgroundColor = viewModel?.backgroundColor {
            view.backgroundColor = backgroundColor
            okButton.setTitleColor(backgroundColor, for: .normal)
        }
        
        if let tintColor = viewModel?.tintColor {
            okButton.backgroundColor = tintColor
            iconImageView.tintColor = tintColor
        }
        
        if let textColor = viewModel?.textColor {
            textLabel.textColor = textColor
        }
    }
    
    // MARK: - Actions
    @IBAction func okButtonAction(_ sender: UIButton) {
        viewModel?.goBack()
    }
}
