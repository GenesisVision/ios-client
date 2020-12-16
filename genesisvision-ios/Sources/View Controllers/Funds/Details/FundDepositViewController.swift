//
//  FundDepositViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 14.10.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

class FundDepositViewController: BaseViewController {
    var viewModel: FundDepositViewModel!
    
    @IBOutlet weak var depositStackView: DepositStackView!
    
    @IBOutlet weak var createFundButton: ActionButton! {
        didSet {
            createFundButton.setEnabled(false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    private func setup() {
        viewModel.fetch()
        
        depositStackView.amountView.maxButton.addTarget(self, action: #selector(copyMaxValueButtonAction), for: .touchUpInside)
        
        depositStackView.amountView.textField.designableTextFieldDelegate = self
        depositStackView.amountView.textField.delegate = self
        depositStackView.amountView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
    }
    
    private func updateUI() {
        depositStackView.depositTitle.text = "Deposit details"
        
        depositStackView.fromView.titleLabel.text = "From"
        depositStackView.fromView.textLabel.text = viewModel.getSelectedWallet()
        depositStackView.fromView.subtitleLabel.text = "Available in the wallet"
        depositStackView.fromView.subtitleValueLabel.text = viewModel.getAvailable()
        depositStackView.fromView.selectButton.isEnabled = true
        
        depositStackView.amountView.titleLabel.text = "Enter correct amount"
        depositStackView.amountView.textField.text = ""
        depositStackView.amountView.approxLabel.text = ""
        depositStackView.amountView.currencyLabel.text = viewModel.getSelectedWalletCurrency()
        depositStackView.amountView.subtitleLabel.text = "min. deposit"
        depositStackView.amountView.subtitleValueLabel.text = viewModel.getMinDeposit()
    }
    
    @objc func checkActionButton() {
        var isEnable = false
        
        viewModel.request.title = viewModel.createViewModel?.title
        viewModel.request._description = viewModel.createViewModel?.description
        viewModel.request.exitFee = viewModel.createViewModel?.exitFee
        viewModel.request.entryFee = viewModel.createViewModel?.entryFee
        

        if let value = depositStackView.amountView.textField.text?.doubleValue {
            viewModel?.request.depositAmount = value
            depositStackView.amountView.approxLabel.text = viewModel?.getApproxString(value)
        } else {
            depositStackView.amountView.approxLabel.text = ""
        }
        
        if
            let value = depositStackView.amountView.textField.text?.doubleValue,
            let minDeposit = viewModel?.getMinDepositValue(),
            let exchangedValue = viewModel?.exchangeValueInCurrency(value),
            exchangedValue >= minDeposit {
            isEnable = true
        }
        
        createFundButton.setEnabled(isEnable)
    }
    
    @IBAction func createFundButtonAction(_ sender: Any) {
        viewModel.createFund { [weak self] (result) in
            switch result {
            case .success:
                self?.showSuccessHUD(title: "", subtitle: "", completion: { _ in
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            case .failure(errorType: _):
                break
            }
        }
    }
    
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        if let wallet = viewModel?.fromListViewModel?.selected(), let currency = wallet.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let availableInWalletFromValue = wallet.available {
            
            depositStackView.amountView.textField.text = availableInWalletFromValue.rounded(with: currencyType).toString(withoutFormatter: true)
        }
    }
    
    @IBAction func selectWalletCurrencyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel?.fromListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none
            
            if let cellModelsForRegistration = viewModel?.fromListViewModel.cellModelsForRegistration {
                tableView.registerNibs(for: cellModelsForRegistration)
            }
            tableView.delegate = viewModel?.fromListDataSource
            tableView.dataSource = viewModel?.fromListDataSource
//            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
}

extension FundDepositViewController: BaseTableViewProtocol {
    func didSelect(_ type: DidSelectType, index: Int) {
        self.view.endEditing(true)
        bottomSheetController.dismiss()
        
        switch type {
        case .walletFrom:
            viewModel?.updateWallet(index)
        default:
            break
        }
        
        updateUI()
    }
    
    func didReload() {
        hideAll()
        updateUI()
    }
}

extension FundDepositViewController: UITextFieldDelegate, DesignableUITextFieldDelegate {
    func textFieldDidClear(_ textField: UITextField) {
        checkActionButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkActionButton()
    }
}


final class FundDepositViewModel {
    var createViewModel: CreateNewFundViewModel? {
        didSet {
            request.title = createViewModel?.title
            request._description = createViewModel?.description
            request.exitFee = createViewModel?.exitFee
            request.entryFee = createViewModel?.entryFee
            request.assets = createViewModel?.fundAssets
        }
    }
    
    var uploadedUuidString: String? {
        didSet {
            request.logo = uploadedUuidString
        }
    }
    
    var walletSummary: WalletSummary? {
        didSet {
            if let wallets = walletSummary?.wallets, !wallets.isEmpty {
                fromListViewModel = FromListViewModel(delegate, items: wallets, selectedIndex: 0)
                fromListDataSource = TableViewDataSource(fromListViewModel)
                request.depositWalletId = fromListViewModel?.selected()?._id
            }
        }
    }
    
    var createFundInfo: FundCreateAssetPlatformInfo?
    lazy var currency = getPlatformCurrencyType()
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    
    var ratesModel: RatesModel?
    
    var fromListViewModel: FromListViewModel!
    var fromListDataSource: TableViewDataSource!
    
    var request = NewFundRequest(title: nil, _description: nil, logo: nil, assets: nil, entryFee: nil, exitFee: nil, depositAmount: nil, depositWalletId: nil)
    
    weak var delegate: BaseTableViewProtocol?
    
    init(_ delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
    }
    
    func fetch() {
        WalletDataProvider.get(with: getPlatformCurrencyType(), completion: { [weak self] (walletSummary) in
            self?.walletSummary = walletSummary
            self?.delegate?.didReload()
        }, errorCompletion: errorCompletion)
        PlatformManager.shared.getPlatformInfo { [weak self] (model) in
            guard let model = model?.assetInfo?.fundInfo?.createFundInfo else { return }
            self?.createFundInfo = model
        }
    }
    
    func createFund(completion: @escaping CompletionBlock) {
        guard let pickedImageUrl = createViewModel?.pickedImageURL else {
            AssetsDataProvider.createFund(request, completion: completion)
            return
        }
        saveImage(pickedImageUrl) { [weak self] (result) in
            switch result {
            case .success:
                AssetsDataProvider.createFund(self?.request, completion: completion)
            case .failure(let errorType):
                print(errorType)
                completion(result)
            }
        }
    }
    
    func updateRates() {
        RateDataProvider.getRates(from: [Currency.gvt.rawValue], to: [Currency.gvt.rawValue, Currency.btc.rawValue, Currency.eth.rawValue, Currency.usdt.rawValue], completion: { [weak self] (ratesModel) in
            self?.ratesModel = ratesModel
        }) { (result) in
            
        }
    }
    
    func getMinDeposit() -> String {
        guard let minDeposit = createFundInfo?.minDeposit else { return "" }
        let currencyType: CurrencyType = .gvt
        return minDeposit.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getMinDepositValue() -> Double? {
        guard let minDeposit = createFundInfo?.minDeposit else { return nil }

        return minDeposit
    }
    
    
    func getSelectedWallet() -> String {
        guard let selected = fromListViewModel.selected(), let title = selected.title, let currency = selected.currency?.rawValue else { return "" }
        
        return "\(currency) | \(title)"
    }
    
    func getSelectedWalletCurrency() -> String {
        guard let currency = fromListViewModel.selected()?.currency?.rawValue else { return "" }
        
        return currency
    }
    
    func updateWallet(_ index: Int) {
        request.depositWalletId = fromListViewModel?.selected()?._id
        updateRates()
    }
    
    func saveImage(_ pickedImageURL: URL, completion: @escaping (CompletionBlock)) {
        BaseDataProvider.uploadImage(imageData: pickedImageURL.dataRepresentation, imageLocation: .fundAsset, completion: { [weak self] (uploadResult) in
            guard let uploadResult = uploadResult, let uuidString = uploadResult._id?.uuidString else { return completion(.failure(errorType: .apiError(message: nil))) }
            
            self?.uploadedUuidString = uuidString
            completion(.success)
        }, errorCompletion: completion)
    }
    
    func getAvailable() -> String {
        guard let selected = fromListViewModel?.selected(), let currency = selected.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let available = fromListViewModel?.selected()?.available else { return "" }
        return available.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getRate() -> Double? {
        guard let rates = ratesModel?.rates, let fromCurrency = fromListViewModel.selected()?.currency, fromCurrency != Currency.gvt else { return nil }
        
        let rate = rates[Currency.gvt.rawValue]?.first(where: { $0.currency == fromCurrency.rawValue })?.rate
        
        return rate != 0 ? rate : nil
    }
    
    func exchangeValueInCurrency(_ value: Double) -> Double? {
        guard let rate = getRate() else { return value }
        return value / rate
    }
    
    func getApproxString(_ value: Double) -> String {
        let currency = CurrencyType.gvt
        guard let rate = getRate() else { return "" }
        
        
        let text = "≈" + (value / rate).rounded(with: currency).toString() + " " + currency.rawValue
        return text
    }
}


