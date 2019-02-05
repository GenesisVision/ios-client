//
//  AuthTwoFactorCreateViewController.swift
//  genesisvision-ios
//
//  Created by George on 30/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class AuthTwoFactorCreateViewController: BaseViewController {
    // MARK: - View Model
    var viewModel: AuthTwoFactorCreateViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var topTitleLabel: SubtitleLabel! {
        didSet {
            topTitleLabel.textColor = UIColor.Cell.subtitle
            topTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    
    @IBOutlet weak var bottomTitleLabel: SubtitleLabel! {
        didSet {
            bottomTitleLabel.textColor = UIColor.Cell.subtitle
            bottomTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
   
    @IBOutlet weak var qrImageView: UIImageView! {
        didSet {
            qrImageView.backgroundColor = UIColor.BaseView.bg
        }
    }
    @IBOutlet weak var sharedKeyLabel: TitleLabel! {
        didSet {
            sharedKeyLabel.textColor = UIColor.Cell.title
            sharedKeyLabel.font = UIFont.getFont(.medium, size: 16.0)
        }
    }
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        showProgressHUD()
        viewModel.fetch(completion: { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.setupUI()
                }
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }) { (result) in
            switch result {
            case .success:
                break
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
            }
        }
    }
    
    private func setupUI() {
        sharedKeyLabel.text = viewModel.sharedKey
        qrImageView.image = viewModel.getQRImage()
        topTitleLabel.text = viewModel.topTitleText
        bottomTitleLabel.text = viewModel.bottomTitleText
    }
    
    // MARK: - Actions
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.nextStep()
    }
}
