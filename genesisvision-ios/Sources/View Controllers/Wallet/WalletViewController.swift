//
//  WalletViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 22.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//


import UIKit
import Tabman

class WalletViewController: BaseTabmanViewController<WalletTabmanViewModel> {
    // MARK: - Variables
    private var moreBarButtonItem: UIBarButtonItem!
    
    var bottomSheetController: BottomSheetController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        
        if viewModel.walletType == .all {
            moreBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_more_icon"), style: .done, target: self, action: #selector(moreBarButtonAction))
            navigationItem.rightBarButtonItem = moreBarButtonItem
        }
    }
    
    @objc func moreBarButtonAction() {
        guard let wallet = viewModel.multiWallet else { return }
        
        let walletMoreButtonView = WalletMoreButtonView.viewFromNib()
        walletMoreButtonView.delegate = self
        walletMoreButtonView.configure(wallet)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.lineViewIsHidden = true
        bottomSheetController.initializeHeight = 120
        bottomSheetController.addContentsView(walletMoreButtonView)
        bottomSheetController.present()
    }
}

extension WalletViewController: WalletMoreButtonViewProtocol {
    func feeSwitchDidChange(value: Bool) {
        showProgressHUD()
        WalletDataProvider.feeChange(value) { [weak self] (result) in
            self?.hideHUD()
            self?.bottomSheetController.dismiss()
            
            switch result {
            case .success:
                self?.viewModel.multiWallet?.payFeesWithGvt = value
            case .failure(let errorType):
                print(errorType)
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    func aboutFeesButtonDidTapped() {
        bottomSheetController.dismiss()
        
        viewModel.showAboutFees()
    }
}

extension WalletViewController: WalletProtocol {
    func didUpdateData() {
        viewModel.reloadDetails()
    }
}
