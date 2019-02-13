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
    
    var currencyDelegateManager: CurrencyDelegateManager?
    
    var navigationTitleView: NavigationTitleView?
    var bottomSheetController: BottomSheetController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCurrencyButtonTitle()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupUI()
        
        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        bar.items = viewModel.items
        
        navigationTitleView?.currencyTitleButton.addTarget(target, action: action, for: .touchUpInside)
        self.currencyDelegateManager = CurrencyDelegateManager()
        self.currencyDelegateManager?.currencyDelegate = self
        
        navigationItem.titleView = navigationTitleView
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        
        if viewModel.wallet == nil {
            moreBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_more_icon"), style: .done, target: self, action: #selector(moreBarButtonAction))
            navigationItem.rightBarButtonItem = moreBarButtonItem
        }
    }
    
    @objc func moreBarButtonAction() {
        guard let wallet = viewModel.dataSource.wallet else { return }
        
        let walletMoreButtonView = WalletMoreButtonView.viewFromNib()
        walletMoreButtonView.delegate = self
        walletMoreButtonView.configure(wallet)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.lineViewIsHidden = true
        bottomSheetController.initializeHeight = 200
        bottomSheetController.addContentsView(walletMoreButtonView)
        bottomSheetController.present()
    }
    
    func updateCurrencyButtonTitle() {
        let selectedCurrency = getSelectedCurrency()
        navigationTitleView?.currencyTitleButton.setTitle(selectedCurrency, for: .normal)
        navigationTitleView?.currencyTitleButton.sizeToFit()
    }
}

extension WalletViewController: WalletMoreButtonViewProtocol {
    func feeSwitchDidChange(value: Bool) {
        showProgressHUD()
        WalletDataProvider.feeChange(value) { [weak self] (result) in
            self?.hideHUD()
            self?.bottomSheetController.dismiss()
        }
    }
}
    
extension WalletViewController: CurrencyDelegateManagerProtocol {
    func didSelectCurrency(at indexPath: IndexPath) {
        updateCurrencyButtonTitle()
        bottomSheetController.dismiss()
    }
}

extension WalletViewController: CurrencyTitleButtonProtocol {
    var target: Any? {
        return self
    }
    
    var action: Selector! {
        return #selector(moreBarButtonAction)
    }
}
