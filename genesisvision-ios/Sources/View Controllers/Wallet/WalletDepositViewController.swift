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
    
    // MARK: - Outlets
    @IBOutlet var amountToDepositTitleLabel: SubtitleLabel! {
        didSet {
            amountToDepositTitleLabel.text = "You will send"
        }
    }
    @IBOutlet var amountToDepositValueLabel: TitleLabel! {
        didSet {
            amountToDepositValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet var amountToDepositGVTLabel: SubtitleLabel! {
        didSet {
            amountToDepositGVTLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    @IBOutlet var amountToDepositCurrencyLabel: SubtitleLabel! {
        didSet {
            amountToDepositCurrencyLabel.textColor = UIColor.Cell.title
        }
    }
    
    @IBOutlet var selectedWalletCurrencyButton: UIButton!
    @IBOutlet var selectedWalletCurrencyTitleLabel: SubtitleLabel! {
        didSet {
            selectedWalletCurrencyTitleLabel.text = "Select a wallet currency"
        }
    }
    @IBOutlet var selectedWalletCurrencyValueLabel: TitleLabel! {
        didSet {
            selectedWalletCurrencyValueLabel.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var addressLabel: TitleLabel!
    
    @IBOutlet weak var copyButton: UIButton!
    
    @IBOutlet weak var amountToDepositTextField: UITextField! {
        didSet {
            amountToDepositTextField.font = UIFont.getFont(.regular, size: 18.0)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        navigationItem.title = viewModel.title
        
        showProgressHUD()
        viewModel.fetch(completion: { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.updateUI()
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
    
    private func updateUI() {
        addressLabel.text = viewModel.getAddress()
        qrImageView.image = viewModel.getQRImage()
    }
    
    // MARK: - Actions
    @IBAction func copyButtonAction(_ sender: UIButton) {
        showProgressHUD()
        viewModel.copy { [weak self] (result) in
            self?.showSuccessHUD()
        }
    }
    
    @IBAction func selectedWalletCurrencyButtonAction(_ sender: UIButton) {
        //TODO: show wallets
    }
}
