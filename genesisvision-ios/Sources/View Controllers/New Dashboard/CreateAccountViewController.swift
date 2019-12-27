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
        
        stackView.amountView.maxButton.addTarget(self, action: #selector(copyMaxValueButtonAction), for: .touchUpInside)
        stackView.amountView.textField.designableTextFieldDelegate = self
        stackView.amountView.textField.delegate = self
        stackView.amountView.textField.addTarget(self, action: #selector(checkActionButton), for: .editingChanged)
        
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
        
        brokerDetailsView.configure(viewModel.brokerCollectionViewModel.get(index), delegate: self)
        bottomSheetController.addContentsView(brokerDetailsView)
        bottomSheetController.bottomSheetControllerProtocol = brokerDetailsView

        present(bottomSheetController, animated: true, completion: nil)
    }
    
    func showBrokerTerms(_ url: String) {
        guard let url = URL(string: url) else { return }
        let vc = getSafariVC(with: url)
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true, completion: nil)
    }
    @objc func checkActionButton() {
        guard let amount = stackView.amountView.textField.text else { return }
        
        let value = !amount.isEmpty
        
        stackView.actionButton.setEnabled(value)
    }
    // MARK: - Actions
    @IBAction func createAccountButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let depositAmount = stackView.amountView.textField.text?.doubleValue {
            viewModel.request.depositAmount = depositAmount
        }
        
        showProgressHUD()
        viewModel.createAccount { [weak self] (result) in
            self?.hideAll()
            
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .failure(let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self)
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
            tableView.reloadData()
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
            tableView.reloadData()
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
            tableView.reloadData()
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
            tableView.reloadData()
        }

        present(bottomSheetController, animated: true, completion: nil)
    }
    @IBAction func copyMaxValueButtonAction(_ sender: UIButton) {
        if let wallet = viewModel.fromListViewModel?.selected(), let currency = wallet.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let availableInWalletFromValue = wallet.available {
            
            stackView.amountView.textField.text = availableInWalletFromValue.rounded(with: currencyType).toString(withoutFormatter: true)
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
        
        if type == .showBrokerDetails {
            showBrokerDetails(index)
            return
        }
        
        bottomSheetController.dismiss()
    
        switch type {
        case .accountType:
            viewModel.updateAccountType(index)
        case .currency:
            viewModel.updateCurrency(index)
        case .leverage:
            viewModel.updateLeverage(index)
        case .walletFrom:
            viewModel.updateWalletFrom(index)
        case .selectBroker:
            viewModel.updateBroker()
        default:
            break
        }
        
        updateUI()
    }
}

class CreateAccountViewModel {
    // MARK: - Variables
    var accountTypeListViewModel: AccountTypeListViewModel!
    var accountTypeListDataSource: TableViewDataSource<AccountTypeListViewModel>!
    
    var currencyListViewModel: CurrencyListViewModel!
    var currencyListDataSource: TableViewDataSource<CurrencyListViewModel>!
    
    var leverageListViewModel: LeverageListViewModel!
    var leverageListDataSource: TableViewDataSource<LeverageListViewModel>!
    
    var fromListViewModel: FromListViewModel!
    var fromListDataSource: TableViewDataSource<FromListViewModel>!
    
    var brokerCollectionViewModel: BrokerCollectionViewModel!
    var brokerCollectionDataSource: CollectionViewDataSource<BrokerCollectionViewModel>!
    
    var brokersInfo: BrokersInfo? {
        didSet {
            brokerCollectionViewModel = BrokerCollectionViewModel(delegate, items: brokersInfo?.brokers)
            brokerCollectionDataSource = CollectionViewDataSource(brokerCollectionViewModel)
            
            if let broker = brokersInfo?.brokers?.first {
                let accountTypes = broker.accountTypes
                accountTypeListViewModel = AccountTypeListViewModel(delegate, items: accountTypes ?? [], selectedIndex: 0)
                accountTypeListDataSource = TableViewDataSource(accountTypeListViewModel)
                
                let accountType = accountTypes?.first
                
                let currencies = accountType?.currencies
                currencyListViewModel = CurrencyListViewModel(delegate, items: currencies ?? [], selectedIndex: 0)
                currencyListDataSource = TableViewDataSource(currencyListViewModel)
                
                updateWalletFrom()
                
                let leverages = accountType?.leverages
                leverageListViewModel = LeverageListViewModel(delegate, items: leverages ?? [], selectedIndex: 0)
                leverageListDataSource = TableViewDataSource(leverageListViewModel)
            }
        }
    }
    
    var rateModel: RateModel?
    var walletSummary: WalletSummary? {
        didSet {
            if let wallets = walletSummary?.wallets, !wallets.isEmpty {
                fromListViewModel = FromListViewModel(delegate, items: wallets, selectedIndex: 0)
                fromListDataSource = TableViewDataSource(fromListViewModel)
            }
        }
    }
    var minAmounts: [TradingAccountMinCreateAmount]?
    var twoFactorStatus: TwoFactorStatus?
    lazy var currency = getPlatformCurrencyType()
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    var request = NewTradingAccountRequest(depositAmount: nil, depositWalletId: nil, currency: nil, leverage: nil, brokerAccountTypeId: nil)
    var createResultModel: TradingAccountCreateResult?
    
    weak var delegate: BaseTableViewProtocol?
    init(_ delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
    }
    private func fetchBrokers(_ walletSummary: WalletSummary?) {
        BrokersDataProvider.getBrokers(completion: { [weak self] (model) in
            self?.brokersInfo = model
            self?.walletSummary = walletSummary
            self?.delegate?.didReload()
        }, errorCompletion: self.errorCompletion)
    }
    func fetch() {
        WalletDataProvider.get(with: currency, completion: { [weak self] (walletSummary) in
            self?.fetchBrokers(walletSummary)
        }, errorCompletion: errorCompletion)
        
        PlatformManager.shared.getPlatformInfo { [weak self] (model) in
            guard let model = model?.assetInfo?.tradingAccountInfo?.minAmounts else { return }
            self?.minAmounts = model
        }
    }
    
    func createAccount(completion: @escaping CompletionBlock) {
        AssetsDataProvider.createTradingAccount(request, completion: { [weak self] (model) in
            self?.createResultModel = model
            completion(.success)
        }, errorCompletion: completion)
    }
    func updateBroker() {
        if let broker = brokerCollectionViewModel.getSelected() {
            accountTypeListViewModel = AccountTypeListViewModel(delegate, items: broker.accountTypes ?? [], selectedIndex: 0)
            accountTypeListDataSource = TableViewDataSource(accountTypeListViewModel)
            
            updateAccountType(0)
        }
    }
    func updateWalletFrom() {
        if let fromListViewModel = fromListViewModel, let currencyListViewModel = currencyListViewModel {
            fromListViewModel.selectedIndex = fromListViewModel.items.firstIndex(where: { $0.currency?.rawValue == currencyListViewModel.selected() }) ?? 0
        }
    }
    
    func updateWalletFrom(_ index: Int) {
        fromListViewModel.selectedIndex = index
        request.depositWalletId = fromListViewModel.selected()?.id
    }
    
    func updateAccountType(_ index: Int) {
        accountTypeListViewModel.selectedIndex = index
        
        guard let accountType = accountTypeListViewModel.selected() else { return }
        request.brokerAccountTypeId = accountType.id

        currencyListViewModel = CurrencyListViewModel(delegate, items: accountType.currencies ?? [], selectedIndex: 0)
        currencyListDataSource = TableViewDataSource(currencyListViewModel)
        
        updateWalletFrom()
        
        leverageListViewModel = LeverageListViewModel(delegate, items: accountType.leverages ?? [], selectedIndex: 0)
        leverageListDataSource = TableViewDataSource(leverageListViewModel)
    }
    func updateCurrency(_ index: Int) {
        currencyListViewModel.selectedIndex = index
        if let currency = currencyListViewModel.selected() {
            request.currency = Currency(rawValue: currency)
        }
    }
    func updateLeverage(_ index: Int) {
        leverageListViewModel.selectedIndex = index
        if let selected = leverageListViewModel.selected() {
            request.leverage = selected
        }
    }
    func getMinDeposit() -> String {
        guard let currency = currencyListViewModel.selected(), let accountType = accountTypeListViewModel.selected(), let minDeposits = accountType.minimumDepositsAmount, let minDeposit = minDeposits[currency], let currencyType = CurrencyType(rawValue: currency) else { return "" }
        
        return minDeposit.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    func getSelectedWallet() -> String {
        guard let fromListViewModel = fromListViewModel, let selected = fromListViewModel.selected(), let title = selected.title, let currency = selected.currency?.rawValue else { return "" }
        
        return "\(currency) | \(title)"
    }
    func getAvailable() -> String {
        guard let selected = fromListViewModel?.selected(), let currency = selected.currency?.rawValue, let currencyType = CurrencyType(rawValue: currency), let available = fromListViewModel?.selected()?.available else { return "" }
        return available.rounded(with: currencyType).toString() + " " + currencyType.rawValue
    }
    func getLeverage() -> String {
        guard let selected = leverageListViewModel.selected() else { return "" }
        return selected.toString()
    }
    func isEnableLeverageSelector() -> Bool {
        guard let count = leverageListViewModel?.items.count else { return false }
        return count > 1
    }
    func getAccountType() -> String {
        guard let selected = accountTypeListViewModel.selected()?.name else { return "" }
        return selected
    }
    func isEnableAccountTypeSelector() -> Bool {
        guard let count = accountTypeListViewModel?.items.count else { return false }
        return count > 1
    }
    func getCurrency() -> String {
        guard let selected = currencyListViewModel?.selected() else { return "" }
        return selected
    }
    func isEnableCurrencySelector() -> Bool {
        guard let count = currencyListViewModel?.items.count else { return false }
        return count > 1
    }
}
class ExchangeListViewModel: SelectableListViewModel<Broker> {
    var title = "Choose exchange"
    
    var tableView: UITableView!
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()

        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }

        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)

        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)
        
        delegate?.didSelect(.exchange, index: indexPath.row)
    }
}
class AccountTypeListViewModel: SelectableListViewModel<BrokerAccountType> {
    var title = "Choose account type"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)

        delegate?.didSelect(.accountType, index: indexPath.row)
    }
}
class CurrencyListViewModel: SelectableListViewModel<String> {
    var title = "Choose currency"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)

        delegate?.didSelect(.currency, index: indexPath.row)
    }
}
class LeverageListViewModel: SelectableListViewModel<Int> {
    var title = "Choose broker's leverage"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()

        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }

        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)

        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)
        
        delegate?.didSelect(.leverage, index: indexPath.row)
    }
}
class FromListViewModel: SelectableListViewModel<WalletData> {
    var title = "Choose wallet"
    
    override func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let model = SelectableTableViewCellViewModel()
        
        guard let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as? SelectableTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        let isSelected = indexPath.row == selectedIndex
        cell.configure(item, selected: isSelected)
        
        return cell
    }
    
    override func didSelect(at indexPath: IndexPath) {
        super.didSelect(at: indexPath)
        
        delegate?.didSelect(.walletFrom, index: indexPath.row)
    }
    
    func updateSelected(_ currency: CurrencyType) {
        self.selectedIndex = items.firstIndex(where: { $0.currency?.rawValue == currency.rawValue }) ?? 0
    }
}
class BrokerCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    private var selectedIndex: Int = 0
    private var items: [Broker]?
    
    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [BrokerCollectionViewCellViewModel.self]
    }

    weak var delegate: BaseTableViewProtocol?
    init(_ delegate: BaseTableViewProtocol?, items: [Broker]?) {
        self.delegate = delegate
        self.title = "Select broker"
        self.type = .createAccount
        self.items = items
        
        viewModels = items?.map { BrokerCollectionViewCellViewModel(brokerModel: $0, delegate: self) } ?? []
    }
    
    func getSelected() -> Broker? {
        return items?[selectedIndex]
    }
    
    func get(_ index: Int) -> Broker? {
        return items?[index]
    }
    
    func didSelect(at indexPath: IndexPath) {
        selectedIndex = indexPath.row
        delegate?.didSelect(.selectBroker, index: indexPath.row)
    }
    
    
}

extension BrokerCollectionViewModel: BrokerCollectionViewCellViewModelProtocol {
    func showDetails(_ broker: Broker) {
        guard let index = items?.firstIndex(where: { $0.name == broker.name }) else { return }
        
        delegate?.didSelect(.showBrokerDetails, index: index)
    }
    
    func isSelected(_ broker: Broker) -> Bool {
        guard let index = items?.firstIndex(where: { $0.name == broker.name }) else { return false }
        
        return selectedIndex == index
    }
}
extension BrokerCollectionViewModel {
    func getCollectionViewHeight() -> CGFloat {
        return 200.0
    }
    
    func makeLayout() -> UICollectionViewLayout {
        return CustomLayout.defaultLayout(2)
    }
}


