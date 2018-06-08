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
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var topTitleLabel: UILabel!
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var sharedKeyLabel: UILabel!
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
        sharedKeyLabel.textColor = UIColor.TwoFactor.codeTitle
        
        qrImageView.image = viewModel.getQRImage()
        
        topTitleLabel.text = viewModel.topTitleText
        topTitleLabel.textColor = UIColor.TwoFactor.title
        
        bottomTitleLabel.text = viewModel.bottomTitleText
        bottomTitleLabel.textColor = UIColor.TwoFactor.title
    }
    
    // MARK: - Actions
    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.nextStep()
    }
}
