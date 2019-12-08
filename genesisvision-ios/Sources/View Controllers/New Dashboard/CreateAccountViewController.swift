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

        viewModel = CreateAccountViewModel(self)
        stackView.configure(viewModel)
        
        showProgressHUD()
        viewModel.brokerCollectionViewModel.fetch()
    }
    
    // MARK: - Actions
    @IBAction func createAccountButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectExchangeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 275.0

        bottomSheetController.addNavigationBar(viewModel.exchangeListViewModel.title)

        bottomSheetController.addTableView { tableView in
            viewModel.exchangeListViewModel.tableView = tableView
            tableView.separatorStyle = .none

            tableView.registerNibs(for: viewModel.exchangeListViewModel.cellModelsForRegistration)
            tableView.delegate = viewModel.exchangeListDataSource
            tableView.dataSource = viewModel.exchangeListDataSource
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
    
    func showBrokerDetails(_ index: Int) {
        self.view.endEditing(true)
        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = 500.0
        
        let brokerDetailsView = BrokerDetailsView.viewFromNib()
        let model = BrokerDetailsModel(title: "Genesis Market",
                                       about: "Huobi is a Singapore-based cryptocurrency exchange. Founded in China, the company now has offices in Hong Kong, Korea, Japan and the United States. It is currently one of the largest crypto exchanges in the world, judging by 24-hour period volume.",
                                       accountType: "BTC, ETH, USDT",
                                       tradingPlatform: "MetaTrader5",
                                       terms: "https://genesismarkets.io/page/tradingconditions",
                                       leverage: "1:1",
                                       assets: "More than 400 various crypto assets")
        
        brokerDetailsView.configure(model, delegate: self)
        bottomSheetController.addContentsView(brokerDetailsView)
        bottomSheetController.bottomSheetControllerProtocol = brokerDetailsView

        present(bottomSheetController, animated: true, completion: nil)
    }
    
    func selectBroker(_ index: Int) {
        self.view.endEditing(true)
        viewModel.brokerCollectionViewModel.selectedIndex = index
        showProgressHUD()
        viewModel.brokerCollectionViewModel.fetch()
        stackView.configure(viewModel)
    }
    
    func showBrokerTerms(_ url: String) {
        self.view.endEditing(true)
        guard let url = URL(string: url) else { return }
        let vc = getSafariVC(with: url)
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true, completion: nil)
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

extension CreateAccountViewController: BaseCellProtocol {
    func didReload() {
        hideAll()
        stackView.selectBrokerView.collectionView.reloadData()
    }
    
    func didSelect(_ type: DidSelectType, index: Int) {
        switch type {
        case .exchange:
            stackView.accountTypeView.textLabel.text = viewModel.exchangeListViewModel.selected
        case .currency:
            stackView.currencyView.textLabel.text = viewModel.currencyListViewModel.selected?.currency?.rawValue
        case .leverage:
            stackView.leverageView.textLabel.text = viewModel.leverageListViewModel.selected?.toString()
        case .depositFrom:
            stackView.fromView.textLabel.text = viewModel.fromListViewModel.selected?.currency?.rawValue
        case .showBrokerDetails:
            showBrokerDetails(index)
        case .selectBroker:
            selectBroker(index)
        default:
            break
        }
        
        bottomSheetController.dismiss()
    }
    
}

class CreateAccountViewModel {
    // MARK: - Variables
    var exchangeListViewModel: ExchangeListViewModel!
    var exchangeListDataSource: TableViewDataSource<ExchangeListViewModel>!
    
    var currencyListViewModel: FromListViewModel!
    var currencyListDataSource: TableViewDataSource<FromListViewModel>!
    
    var leverageListViewModel: LeverageListViewModel!
    var leverageListDataSource: TableViewDataSource<LeverageListViewModel>!
    
    var fromListViewModel: FromListViewModel!
    var fromListDataSource: TableViewDataSource<FromListViewModel>!
    
    var brokerCollectionViewModel: BrokerCollectionViewModel!
    var brokerCollectionDataSource: CollectionViewDataSource<BrokerCollectionViewModel>!
    
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
        
        let exchanges = ["Binance"]
        exchangeListViewModel = ExchangeListViewModel(delegate, items: exchanges, selected: nil)
        exchangeListDataSource = TableViewDataSource(exchangeListViewModel)
        
        let wallets: [WalletWithdrawalInfo] = []
        currencyListViewModel = FromListViewModel(delegate, items: wallets, selected: nil)
        currencyListDataSource = TableViewDataSource(currencyListViewModel)
        
        let leverages = [1,3,5]
        leverageListViewModel = LeverageListViewModel(delegate, items: leverages, selected: nil)
        leverageListDataSource = TableViewDataSource(leverageListViewModel)
        
        fromListViewModel = FromListViewModel(delegate, items: wallets, selected: nil)
        fromListDataSource = TableViewDataSource(fromListViewModel)
        
        brokerCollectionViewModel = BrokerCollectionViewModel(delegate)
        brokerCollectionDataSource = CollectionViewDataSource(brokerCollectionViewModel)
    }
}
class ExchangeListViewModel: SelectableListViewModel<String> {
    var title = "Choose exchange"
    
    var tableView: UITableView!
    
    override func updateSelectedIndex() {
        self.selectedIndex = items.firstIndex{ $0 == self.selected } ?? 0
    }
    
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
class LeverageListViewModel: SelectableListViewModel<Int> {
    var title = "Choose broker's leverage"
    
    override func updateSelectedIndex() {
        self.selectedIndex = items.firstIndex{ $0 == self.selected } ?? 0
    }
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

class FromListViewModel: SelectableListViewModel<WalletWithdrawalInfo> {
    var title = "Choose wallet"
    
    override func updateSelectedIndex() {
        self.selectedIndex = items.firstIndex(where: { return $0.currency == self.selected?.currency } ) ?? 0
    }
    
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
        
        delegate?.didSelect(.depositFrom, index: indexPath.row)
    }
}

class BrokerCollectionViewModel: ViewModelWithCollection {
    var title: String
    var showActionsView: Bool
    var type: CellActionType
    
    var selectedIndex: Int = 0

    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [BrokerCollectionViewCellViewModel.self]
    }

    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
        self.title = "Select broker"
        self.showActionsView = false
        self.type = .createAccount
    }
    
    func fetch() {
        viewModels = [CellViewAnyModel]()
        viewModels.append(BrokerCollectionViewCellViewModel(brokerModel: BrokerModel(tags: ["Signal", "Forex"], logo: nil), isSelected: selectedIndex == 0, delegate: delegate, index: 0))
        viewModels.append(BrokerCollectionViewCellViewModel(brokerModel: BrokerModel(tags: ["Forex"], logo: nil), isSelected: selectedIndex == 1, delegate: delegate, index: 1))
        viewModels.append(BrokerCollectionViewCellViewModel(brokerModel: BrokerModel(tags: ["Binance 2"], logo: nil), isSelected: selectedIndex == 2, delegate: delegate, index: 2))
        viewModels.append(BrokerCollectionViewCellViewModel(brokerModel: BrokerModel(tags: ["Binance 3"], logo: nil), isSelected: selectedIndex == 3, delegate: delegate, index: 3))
        viewModels.append(BrokerCollectionViewCellViewModel(brokerModel: BrokerModel(tags: ["Binance 4"], logo: nil), isSelected: selectedIndex == 4, delegate: delegate, index: 4))
        
        delegate?.didReload()
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.selectBroker, index: indexPath.row)
    }
    
    func getActions() -> [UIButton] {
        return []
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 200.0
    }
}
