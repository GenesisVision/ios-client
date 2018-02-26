//
//  WalletDepositViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletDepositViewController: BaseViewController {
    
    // MARK: - Variables
    private var copyButton: UIButton?
    
    // MARK: - View Model
    var viewModel: WalletDepositViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = viewModel.title
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        addressLabel.text = viewModel.getAddress()
        qrImageView.image = viewModel.getQRImage()
    }
    
    // MARK: - Actions
    @IBAction func copyButtonAction(_ sender: UIButton) {
        hideKeyboard()
        showProgressHUD(withNetworkActivity: false)
        
        viewModel.copy { [weak self] (result) in
            self?.showSuccessHUD()
        }
    }
}
