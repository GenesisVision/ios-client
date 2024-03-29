//
//  WalletDepositViewController.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class WalletDepositViewController: BaseViewController {
    
    // MARK: - View Model
    var viewModel: WalletDepositViewModel!
    
    // MARK: - Variables
    var amountToDepositValue: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    var oldBrightness: CGFloat = 0.0
    
    // MARK: - Outlets
    @IBOutlet weak var amountToDepositTitleLabel: SubtitleLabel! {
        didSet {
            amountToDepositTitleLabel.text = "You will send"
        }
    }
    @IBOutlet weak var amountToDepositValueLabel: TitleLabel! {
        didSet {
            amountToDepositValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var amountToDepositCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToDepositCurrencyLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var amountToDepositGVTTitleLabel: SubtitleLabel! {
        didSet {
            amountToDepositGVTTitleLabel.text = "You will get"
            amountToDepositGVTTitleLabel.font = UIFont.getFont(.regular, size: 14.0)
        }
    }
    @IBOutlet weak var amountToDepositGVTValueLabel: TitleLabel!
    
    @IBOutlet weak var selectedWalletCurrencyButton: UIButton!
    @IBOutlet weak var selectedWalletCurrencyTitleLabel: SubtitleLabel! {
        didSet {
            selectedWalletCurrencyTitleLabel.text = "Select a wallet currency"
        }
    }
    @IBOutlet weak var selectedWalletCurrencyValueLabel: TitleLabel! {
        didSet {
            selectedWalletCurrencyValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet weak var disclaimerLabel: SubtitleLabel! {
        didSet {
            disclaimerLabel.isHidden = true
            disclaimerLabel.font = UIFont.getFont(.regular, size: 10.0)
            
            disclaimerLabel.setLineSpacing(lineSpacing: 3.0)
            disclaimerLabel.textAlignment = .center
        }
    }
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var addressLabel: TitleLabel!
    
    @IBOutlet weak var copyButton: UIButton! {
        didSet {
            copyButton.setTitleColor(UIColor.Cell.title, for: .normal)
            copyButton.titleLabel?.font = UIFont.getFont(.semibold, size: 12)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        oldBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = CGFloat(1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIScreen.main.brightness = oldBrightness
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
        self.updateUI()
    }
    
    private func updateUI() {
        addressLabel.isHidden = false
        addressLabel.text = viewModel.getAddress()
        qrImageView.image = viewModel.getQRImage()
        
        //FIXME:
//        if let selectedWallet = viewModel.selectedWallet, let currency = selectedWallet.currency, let rateToGVT = selectedWallet.rateToGVT {
//            let currency = CurrencyType(rawValue: currency.rawValue) ?? .gvt
//            
//            amountToDepositCurrencyLabel.text = currency.rawValue
//            
//            amountToDepositGVTValueLabel.text = (amountToDepositValue / rateToGVT).rounded(with: .gvt).toString() + " " + Constants.gvtString
//            
//            if let title = selectedWallet.title {
//                selectedWalletCurrencyValueLabel.text = title + " | " + currency.rawValue
//            }
//        }
        
        if let walletCurrencyDelegateManager = viewModel?.walletCurrencyDelegateManager {
            walletCurrencyDelegateManager.currencyDelegate = self
        }
        
        if let selectedWallet = viewModel.selectedWallet, let title = selectedWallet.title, let currency = selectedWallet.currency {
            selectedWalletCurrencyValueLabel.text = title + " | " + currency.rawValue
        }
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    @IBAction func copyButtonAction(_ sender: UIButton) {
        showProgressHUD()
        viewModel.copy { [weak self] (result) in
            self?.hideAll()
            self?.showBottomSheet(.success, title: self?.viewModel.successText)
        }
    }
    
    @IBAction func selectedWalletCurrencyButtonAction(_ sender: UIButton) {
        viewModel?.walletCurrencyDelegateManager?.updateSelectedIndex()
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0
        
        bottomSheetController.addNavigationBar(selectedWalletCurrencyTitleLabel.text)
        
        bottomSheetController.addTableView { [weak self] tableView in
            self?.viewModel.walletCurrencyDelegateManager?.tableView = tableView
            tableView.separatorStyle = .none
            
            guard let walletCurrencyDelegateManager = self?.viewModel.walletCurrencyDelegateManager else { return }
            tableView.registerNibs(for: walletCurrencyDelegateManager.cellModelsForRegistration)
            tableView.delegate = walletCurrencyDelegateManager
            tableView.dataSource = walletCurrencyDelegateManager
        }
        
        bottomSheetController.present()
    }
}

extension WalletDepositViewController: WalletDelegateManagerProtocol {
    func didSelectWallet(at indexPath: IndexPath, walletId: Int) {
        self.viewModel.updateWalletCurrencyIndex(indexPath.row)
        self.updateUI()
        
        bottomSheetController.dismiss()
    }
}

extension WalletDepositViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
