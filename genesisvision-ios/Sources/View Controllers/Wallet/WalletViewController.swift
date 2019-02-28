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
        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        bar.items = viewModel.items
        
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        
        if viewModel.wallet == nil {
            moreBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_more_icon"), style: .done, target: self, action: #selector(moreBarButtonAction))
            navigationItem.rightBarButtonItem = moreBarButtonItem
            
            navigationTitleView = NavigationTitleView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
            
            addCurrencyTitleButton(CurrencyDelegateManager())
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
    
    @objc private func currencyButtonAction() {
        currencyDelegateManager?.updateSelectedIndex()
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 250.0
        
        bottomSheetController.addNavigationBar("Preferred currency")
        
        bottomSheetController.addTableView { [weak self] tableView in
            currencyDelegateManager?.tableView = tableView
            tableView.separatorStyle = .none
            
            guard let currencyDelegateManager = self?.currencyDelegateManager else { return }
            currencyDelegateManager.loadCurrencies()
            tableView.registerNibs(for: currencyDelegateManager.cellModelsForRegistration)
            tableView.delegate = currencyDelegateManager
            tableView.dataSource = currencyDelegateManager
        }
        
        bottomSheetController.present()
    }
}

//Currency button
extension WalletViewController {
    private func addCurrencyTitleButton(_ currencyDelegateManager: CurrencyDelegateManager?) {
        navigationTitleView?.currencyTitleButton.addTarget(self, action: #selector(currencyButtonAction), for: .touchUpInside)
        self.currencyDelegateManager = currencyDelegateManager
        currencyDelegateManager?.currencyDelegate = self
        
        navigationItem.titleView = navigationTitleView
    }
    
    private func updateCurrencyButtonTitle() {
        let selectedCurrency = getSelectedCurrency()
        navigationTitleView?.currencyTitleButton.setTitle(selectedCurrency, for: .normal)
        navigationTitleView?.currencyTitleButton.sizeToFit()
    }
}

extension WalletViewController: CurrencyDelegateManagerProtocol {
    func didSelectCurrency(at indexPath: IndexPath) {
        updateCurrencyButtonTitle()
        viewModel.reloadDetails()
        
        bottomSheetController.dismiss()
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
}

extension WalletViewController: WalletProtocol {
    func didUpdateData() {
        viewModel.reloadDetails()
    }
}
