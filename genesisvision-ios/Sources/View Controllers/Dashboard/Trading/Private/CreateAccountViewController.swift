//
//  CreateAccountViewController.swift
//  genesisvision-ios
//
//  Created by George on 02.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit
import SafariServices

class CreateAccountViewController: BaseModalViewController {
    typealias ViewModel = CreateAccountViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: CreateAccountStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.BaseView.bg
        
        setup()
    }
    
    func setup() {
        viewModel = CreateAccountViewModel(self)
        
        stackView.depositView.amountView.maxButton.addTarget(self, action: #selector(copyMaxValueButtonAction), for: .touchUpInside)
        stackView.depositView.amountView.textField.designableTextFieldDelegate = self
        stackView.depositView.amountView.textField.delegate = self
        stackView.depositView.amountView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        
        showProgressHUD()
        viewModel.fetch()
    }
    
    func updateUI() {
        stackView.configure(viewModel)
        stackView.selectBrokerView.collectionView.reloadData()
    }
    
    func showBrokerDetails(_ index: Int) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 500.0
        
        let brokerDetailsView = BrokerDetailsView.viewFromNib()
        
        brokerDetailsView.configure(viewModel.brokerCollectionViewModel.getBroker(index), delegate: self)
        bottomSheetController.addContentsView(brokerDetailsView)
        bottomSheetController.bottomSheetControllerProtocol = brokerDetailsView

        present(bottomSheetController, animated: true, completion: nil)
    }
    
    func showExchangerDetails(_ index: Int) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 500.0
        
        let brokerDetailsView = BrokerDetailsView.viewFromNib()
        
        brokerDetailsView.configure(viewModel.brokerCollectionViewModel.getExchanger(index), delegate: self)
        bottomSheetController.addContentsView(brokerDetailsView)
        bottomSheetController.bottomSheetControllerProtocol = brokerDetailsView

        present(bottomSheetController, animated: true, completion: nil)
    }
    
    func showBrokerTerms(_ url: String) {
        guard let url = URL(string: url), let safariViewController = getSafariVC(with: url) else { return }
        
        safariViewController.modalPresentationStyle = .formSheet
        present(safariViewController, animated: true, completion: nil)
    }
    @objc func checkActionButton() {
        var isEnable = false
        
        if let value = stackView.depositView.amountView.textField.text?.doubleValue {
            viewModel?.request.depositAmount = value
            stackView.depositView.amountView.approxLabel.text = viewModel?.getApproxString(value)
        } else {
            stackView.depositView.amountView.approxLabel.text = ""
        }
        
        if let value = stackView.depositView.amountView.textField.text?.doubleValue,
            let minDeposit = viewModel?.getMinDepositValue(),
            let exchangedValue = viewModel?.exchangeValueInCurrency(value),
            let available = viewModel.fromListViewModel.selected()?.available,
            exchangedValue >= minDeposit, value <= available {
            isEnable = true
        }
        
        stackView.actionButton.setEnabled(isEnable)
    }
    // MARK: - Actions
    @IBAction func createAccountButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        showProgressHUD()
        viewModel.createAccount { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    @IBAction func selectExchangeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.accountTypeListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.accountTypeListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.accountTypeListDataSource
            tableView.dataSource = viewModel.accountTypeListDataSource
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    @IBAction func selectCurrencyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.currencyListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.currencyListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.currencyListDataSource
            tableView.dataSource = viewModel.currencyListDataSource
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    @IBAction func selectLeverageButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.leverageListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.leverageListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.leverageListDataSource
            tableView.dataSource = viewModel.leverageListDataSource
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    @IBAction func selectWalletCurrencyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.fromListViewModel.title)

        bottomSheetController.addTableView { tableView in
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.fromListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.fromListDataSource
            tableView.dataSource = viewModel.fromListDataSource
            tableView.reloadDataSmoothly()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        if let wallet = viewModel.fromListViewModel?.selected(), let currency = wallet.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let availableInWalletFromValue = wallet.available {
            stackView.depositView.amountView.textField.text = availableInWalletFromValue.rounded(with: currencyType).toString(withoutFormatter: true)
            checkActionButton()
        }
    }
}

extension CreateAccountViewController: BrokerDetailsViewProtocol {
    func viewHeight(_ height: CGFloat) {
        
    }
    
    func closeButtonDidPress() {
        bottomSheetController.dismiss()
    }
    
    func showTermsButtonDidPress(_ url: String?) {
        guard let url = url else { return }
        
        bottomSheetController.dismiss()
        showBrokerTerms(url)
    }
}

extension CreateAccountViewController: UITextFieldDelegate, DesignableUITextFieldDelegate {
    func textFieldDidClear(_ textField: UITextField) {
        checkActionButton()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkActionButton()
    }
}

extension CreateAccountViewController: BaseTableViewProtocol {
    func didReload() {
        hideAll()
        updateUI()
    }
    
    func didSelect(_ type: DidSelectType, index: Int) {
        self.view.endEditing(true)
        
        switch type {
        case .showBrokerDetails:
            showBrokerDetails(index)
            return
        case .showExchangerDetails:
            showExchangerDetails(index)
        case .accountType:
            viewModel.updateAccountType(index)
            bottomSheetController.dismiss()
        case .currency:
            viewModel.updateCurrency(index)
            bottomSheetController.dismiss()
        case .leverage:
            viewModel.updateLeverage(index)
            bottomSheetController.dismiss()
        case .walletFrom:
            viewModel.updateWalletFrom(index)
            bottomSheetController.dismiss()
        case .selectBroker:
            viewModel.updateBroker()
            if !viewModel.isDepositRequired() {
                stackView.actionButton.setEnabled(true)
            }
        case .selectExchanger:
            viewModel.updateExchanger()
            if !viewModel.isDepositRequired() {
                stackView.actionButton.setEnabled(true)
            }
        default:
            break
        }
        
        updateUI()
    }
}

class CreateAccountViewModel {
    // MARK: - Variables
    var accountTypeListViewModel: AccountTypeListViewModel!
    var accountTypeListDataSource: TableViewDataSource!
    
    var currencyListViewModel: CurrencyListViewModel!
    var currencyListDataSource: TableViewDataSource!
    
    var leverageListViewModel: LeverageListViewModel!
    var leverageListDataSource: TableViewDataSource!
    
    var fromListViewModel: FromListViewModel!
    var fromListDataSource: TableViewDataSource!
    
    var brokerCollectionViewModel: BrokerCollectionViewModel!
    var brokerCollectionDataSource: CollectionViewDataSource!
    
    var exchangesInfo: ExchangeInfoItemsViewModel? {
        didSet {
//
//            guard let exchangeBroker = exchangesInfo?.items?.first else { return }
//
//            let brokerFromExchange = Broker(name: exchangeBroker.name, _description: exchangeBroker._description, logoUrl: exchangeBroker.logoUrl, terms: exchangeBroker.terms, assets: exchangeBroker.assets, fee: exchangeBroker.fee, leverageMin: nil, leverageMax: nil, isKycRequired: exchangeBroker.isKycRequired, accountTypes: exchangeBroker.accountTypes, tags: exchangeBroker.tags)
        }
    }
    
    var brokersInfo: BrokersInfo? {
        didSet {
            brokerCollectionViewModel = BrokerCollectionViewModel(delegate, brokers: brokersInfo?.brokers, exchangers: exchangesInfo?.items)
            brokerCollectionDataSource = CollectionViewDataSource(brokerCollectionViewModel)
            
            if let broker = brokersInfo?.brokers?.first {
                let accountTypes = broker.accountTypes
                accountTypeListViewModel = AccountTypeListViewModel(delegate, items: accountTypes ?? [], selectedIndex: 0)
                accountTypeListDataSource = TableViewDataSource(accountTypeListViewModel)
                updateAccountType(0)
                let accountType = accountTypes?.first
                
                let currencies = accountType?.currencies
                currencyListViewModel = CurrencyListViewModel(delegate, items: currencies ?? [], selectedIndex: 0)
                currencyListDataSource = TableViewDataSource(currencyListViewModel)
                updateCurrency(0)
                updateWalletFrom()
                
                let leverages = accountType?.leverages
                leverageListViewModel = LeverageListViewModel(delegate, items: leverages ?? [], selectedIndex: 0)
                leverageListDataSource = TableViewDataSource(leverageListViewModel)
                updateLeverage(0)
            }
        }
    }
    
    var ratesModel: RatesModel?
    var walletSummary: WalletSummary? {
        didSet {
            if let wallets = walletSummary?.wallets, !wallets.isEmpty {
                fromListViewModel = FromListViewModel(delegate, items: wallets, selectedIndex: 0)
                fromListDataSource = TableViewDataSource(fromListViewModel)
                updateWalletFrom(0)
            }
        }
    }
    var minAmounts: [TradingAccountMinCreateAmount]?
    var twoFactorStatus: TwoFactorStatus?
    lazy var currency = getPlatformCurrencyType()
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
    }
    
    var request = NewTradingAccountRequest(depositAmount: nil, depositWalletId: nil, currency: nil, leverage: nil, brokerAccountTypeId: nil)
    var createResultModel: TradingAccountCreateResult?
    
    weak var delegate: BaseTableViewProtocol?
    var isGenesisMarketsBroker: Bool = false
    
    init(_ delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
    }
    
    private func fetchBrokers(_ walletSummary: WalletSummary?) {
        BrokersDataProvider.getBrokers(completion: { [weak self] (model) in
            self?.brokersInfo = model
            self?.walletSummary = walletSummary
            self?.delegate?.didReload()
        }, errorCompletion: errorCompletion)
    }
    
    private func fetchExchangers(_ walletSummary: WalletSummary?) {
        ExchangeDataProvider.getExchanges(completion: { [weak self] (model) in
            self?.exchangesInfo = model
            self?.fetchBrokers(walletSummary)
        }, errorCompletion: errorCompletion)
    }
    
    func fetch() {
        WalletDataProvider.get(with: currency, completion: { [weak self] (walletSummary) in
            self?.fetchExchangers(walletSummary)
        }, errorCompletion: errorCompletion)
        
        PlatformManager.shared.getPlatformInfo { [weak self] (model) in
            guard let model = model?.assetInfo?.tradingAccountInfo?.minAmounts else { return }
            self?.minAmounts = model
        }
    }
    
    func updateRates() {
        RateDataProvider.getRates(from: [currencyListViewModel.selected() ?? ""], to: Currency.allCases.map({ return $0.rawValue }), completion: { [weak self] (ratesModel) in
            self?.ratesModel = ratesModel
        }) { (result) in
            
        }
    }
    
    func createAccount(completion: @escaping CompletionBlock) {
        if isGenesisMarketsBroker {
            let newRequest = NewExchangeAccountRequest(depositAmount: request.depositAmount, depositWalletId: request.depositWalletId, brokerAccountTypeId: request.brokerAccountTypeId)
            AssetsDataProvider.createExchangeAccount(request: newRequest, completion: { [weak self] (model) in
                self?.createResultModel = model
                completion(.success)
            }, errorCompletion: completion)

        } else {
            AssetsDataProvider.createTradingAccount(request, completion: { [weak self] (model) in
                self?.createResultModel = model
                completion(.success)
            }, errorCompletion: completion)
        }
    }
    
    func updateBroker() {
        if let broker = brokerCollectionViewModel.getSelectedBroker() {
            accountTypeListViewModel = AccountTypeListViewModel(delegate, items: broker.accountTypes ?? [], selectedIndex: 0)
            accountTypeListDataSource = TableViewDataSource(accountTypeListViewModel)
            
            updateAccountType(0)
        }
    }
    
    func updateExchanger() {
        if let exchanger = brokerCollectionViewModel.getSelectedExchanger() {
            let accountTypes = exchanger.accountTypes?.map({ (exchangerAccountType) -> BrokerAccountType in
                return BrokerAccountType(_id: exchangerAccountType._id, name: exchangerAccountType.name, _description: exchangerAccountType._description, type: exchangerAccountType.type, leverages: nil, currencies: exchangerAccountType.currencies, minimumDepositsAmount: exchangerAccountType.minimumDepositsAmount, isKycRequired: exchangerAccountType.isKycRequired, isCountryNotUSRequired: exchangerAccountType.isCountryNotUSRequired, isSignalsAvailable: exchangerAccountType.isSignalsAvailable, isDepositRequired: exchangerAccountType.isDepositRequired)
            })
            accountTypeListViewModel = AccountTypeListViewModel(delegate, items: accountTypes ?? [], selectedIndex: 0)
            accountTypeListDataSource = TableViewDataSource(accountTypeListViewModel)
            
            updateAccountType(0)
        }
    }
    
    func updateWalletFrom() {
        if let fromListViewModel = fromListViewModel, let currencyListViewModel = currencyListViewModel {
            fromListViewModel.selectedIndex = fromListViewModel.items.firstIndex(where: { $0.currency?.rawValue == currencyListViewModel.selected() }) ?? 0
            request.depositWalletId = fromListViewModel.selected()?._id
        }
    }
    
    func updateWalletFrom(_ index: Int) {
        fromListViewModel.selectedIndex = index
        request.depositWalletId = fromListViewModel.selected()?._id
    }
    
    func updateAccountType(_ index: Int) {
        accountTypeListViewModel.selectedIndex = index
        
        guard let accountType = accountTypeListViewModel.selected() else { return }
        request.brokerAccountTypeId = accountType._id

        currencyListViewModel = CurrencyListViewModel(delegate, items: accountType.currencies ?? [], selectedIndex: 0)
        currencyListDataSource = TableViewDataSource(currencyListViewModel)
        updateCurrency(0)
        updateWalletFrom()
        
        if let leverages = accountType.leverages {
            isGenesisMarketsBroker = false
            leverageListViewModel = LeverageListViewModel(delegate, items: leverages, selectedIndex: 0)
            leverageListDataSource = TableViewDataSource(leverageListViewModel)
            updateLeverage(0)
        } else {
            isGenesisMarketsBroker = true
        }
    }
    
    func updateCurrency(_ index: Int) {
        currencyListViewModel.selectedIndex = index
        if let currency = currencyListViewModel.selected() {
            request.currency = Currency(rawValue: currency)
        }
        updateRates()
    }
    
    func updateLeverage(_ index: Int) {
        leverageListViewModel.selectedIndex = index
        if let selected = leverageListViewModel.selected() {
            request.leverage = selected
        }
    }
    
    func isDepositRequired() -> Bool {
        let accountType = accountTypeListViewModel.selected()
        
        return accountType?.isDepositRequired ?? true
    }
    
    func getMinDepositValue() -> Double? {
        guard let currency = currencyListViewModel.selected(), let accountType = accountTypeListViewModel.selected(), let minDeposits = accountType.minimumDepositsAmount, let minDeposit = minDeposits[currency] else { return nil }
        
        return minDeposit
    }
    
    func getMinDeposit() -> String {
        guard let currency = currencyListViewModel.selected(), let accountType = accountTypeListViewModel.selected(), let minDeposits = accountType.minimumDepositsAmount, let minDeposit = minDeposits[currency], let currencyType = CurrencyType(rawValue: currency) else { return "" }
        
        return minDeposit.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getSelectedWallet() -> String {
        guard let fromListViewModel = fromListViewModel, let selected = fromListViewModel.selected(), let title = selected.title, let currency = selected.currency?.rawValue else { return "" }
        
        return "\(currency) | \(title)"
    }
    
    func getSelectedWalletCurrency() -> String {
        guard let currency = fromListViewModel.selected()?.currency?.rawValue else { return "" }
        
        return currency
    }
    
    func getAvailable() -> String {
        guard let selected = fromListViewModel?.selected(), let currency = selected.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let available = fromListViewModel?.selected()?.available else { return "" }
        return available.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    
    func getLeverage() -> String {
        guard !isGenesisMarketsBroker, let selected = leverageListViewModel.selected() else { return "1" }
        return selected.toString()
    }
    
    func isEnableLeverageSelector() -> Bool {
        guard !isGenesisMarketsBroker, let count = leverageListViewModel?.items.count else { return false }
        return count > 1
    }
    
    func getAccountType() -> String {
        guard let selected = accountTypeListViewModel.selected()?.name else { return "" }
        return selected
    }
    
    func isEnableAccountTypeSelector() -> Bool {
        guard !isGenesisMarketsBroker, let count = accountTypeListViewModel?.items.count else { return false }
        return count > 1
    }
    
    func getCurrency() -> String {
        guard let selected = currencyListViewModel?.selected() else { return "" }
        return selected
    }
    
    func isEnableCurrencySelector() -> Bool {
        guard !isGenesisMarketsBroker, let count = currencyListViewModel?.items.count else { return false }
        return count > 1
    }
    
    func getRate() -> Double? {
        guard let rates = ratesModel?.rates, let currency = Currency(rawValue: getCurrency()), let fromCurrency = fromListViewModel.selected()?.currency else { return nil }
        let rate = rates[currency.rawValue]?.first(where: { $0.currency == fromCurrency.rawValue })?.rate
        return rate != 0 ? rate : nil
    }
    
    func getApproxString(_ value: Double) -> String {
        let currencyTypeValue = getCurrency()
        guard let currencyType = CurrencyType(rawValue: currencyTypeValue), let rate = getRate() else { return "" }
        
        let text = "≈" + (value / rate).rounded(with: currencyType).toString() + " " + currencyTypeValue
        return text
    }
    
    func exchangeValueInCurrency(_ value: Double) -> Double? {
        guard let rate = getRate() else { return nil }
        return value / rate
    }
}

class BrokerCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    private var selectedIndex: Int = 0
    private var brokers: [Broker]?
    private var exchangers: [ExchangeInfo]?
    
    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [BrokerCollectionViewCellViewModel.self]
    }

    weak var delegate: BaseTableViewProtocol?
    init(_ delegate: BaseTableViewProtocol?, brokers: [Broker]?, exchangers: [ExchangeInfo]?) {
        self.delegate = delegate
        self.title = "Select broker"
        self.type = .createAccount
        self.brokers = brokers
        self.exchangers = exchangers
        
        viewModels = brokers?.map { BrokerCollectionViewCellViewModel(brokerModel: $0, exchangerModel: nil, delegate: self) } ?? []
        if let exchangers = exchangers {
            viewModels.append(contentsOf: exchangers.map({ BrokerCollectionViewCellViewModel(brokerModel: nil, exchangerModel: $0, delegate: self) }))
        }
    }
    
    func getSelectedBroker() -> Broker? {
        return brokers?[selectedIndex]
    }
    
    func getSelectedExchanger() -> ExchangeInfo? {
        return exchangers?[selectedIndex - (brokers?.count ?? 0)]
    }
    
    func getBroker(_ index: Int) -> Broker? {
        return brokers?[index]
    }
    
    func getExchanger(_ index: Int) -> ExchangeInfo? {
        return exchangers?[index]
    }
    
    func didSelect(at indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if let _ = brokers?[safe: selectedIndex] {
            delegate?.didSelect(.selectBroker, index: indexPath.row)
        } else if let _ = exchangers?[safe: selectedIndex - (brokers?.count ?? 0)] {
            delegate?.didSelect(.selectExchanger, index: selectedIndex - (brokers?.count ?? 0))
        }
    }
}

extension BrokerCollectionViewModel: BrokerCollectionViewCellViewModelProtocol {
    func isSelected(_ broker: Broker?, _ exchanger: ExchangeInfo?) -> Bool {
        if let broker = broker, let index = brokers?.firstIndex(where: { $0.name == broker.name }) {
            return selectedIndex == index
        } else if let exchanger = exchanger, let index = exchangers?.firstIndex(where: { $0.name == exchanger.name }) {
            return selectedIndex - (brokers?.count ?? 0) == index
        }
        return false
    }
    
    func showDetails(_ broker: Broker?, _ exchanger: ExchangeInfo?) {
        if let broker = broker, let index = brokers?.firstIndex(where: { $0.name == broker.name }) {
            delegate?.didSelect(.showBrokerDetails, index: index)
        } else if let exchanger = exchanger, let index = exchangers?.firstIndex(where: { $0.name == exchanger.name }) {
            delegate?.didSelect(.showExchangerDetails, index: index)
        }
    }
}
extension BrokerCollectionViewModel {
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize {
        return CGSize(width: frame.width * 0.5, height: frame.height)
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 160.0
    }
    func insetForSection(for section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    }
}
