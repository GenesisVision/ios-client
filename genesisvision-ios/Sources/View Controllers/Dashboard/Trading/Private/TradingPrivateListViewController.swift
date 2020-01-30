//
//  TradingPrivateListViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingPrivateListViewController: ListViewController {
    typealias ViewModel = TradingPrivateListViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    
    private var addNewBarButtonItem: UIBarButtonItem!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showProgressHUD()
        viewModel.fetch()
    }
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.refresh()
    }
    // MARK: - Methods
    private func setup() {
        addNewBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_add_photo_icon"), style: .done, target: self, action: #selector(addNewButtonAction))
        navigationItem.rightBarButtonItems = [addNewBarButtonItem]
        
        isEnableInfiniteIndicator = true
        tableView.configure(with: .defaultConfiguration)

        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
    }
    
    private func createAccount() {
        guard let vc = CreateAccountViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Create account"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    private func attachAccount() {
        guard let vc = AttachAccountViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Attach external account"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    private func makeProgram() {
        guard let vc = MakeProgramViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Make program"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    private func makeSignal() {
        guard let vc = MakeSignalViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Make signal"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func addNewButtonAction() {
        showActionSheet(with: nil,
                        message: nil,
                        firstActionTitle: "Create account",
                        firstHandler: { [weak self] in
                            self?.createAccount()
            },
                        secondActionTitle: "Attach external account",
                        secondHandler: { [weak self] in
                            self?.attachAccount()
            },
                        cancelTitle: "Cancel",
                        cancelHandler: nil)
    }
    
    func showAccount(_ tradingAsset: DashboardTradingAsset) {
        if let router = viewModel.router, let assetId = tradingAsset.id?.uuidString {
            let viewController = AccountViewController()
            let accountRouter = AccountRouter(parentRouter: router)
            accountRouter.accountViewController = viewController
            viewController.viewModel = AccountTabmanViewModel(withRouter: accountRouter, assetId: assetId)
            navigationController?.pushViewController(viewController, animated: true)
       }
    }
}

extension TradingPrivateListViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        switch type {
        case .tradingPrivateList:
            if let cellViewModel = cellViewModel as? TradingTableViewCellViewModel {
                showAccount(cellViewModel.asset)
            }
        default:
            break
        }
    }
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value)
    }
}

class TradingPrivateListViewModel: ListViewModelWithPaging {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [TradingTableViewCellViewModel.self]
    }
    
    var canFetchMoreResults: Bool = true
    var totalCount: Int = 0
    var skip: Int = 0
    
    lazy var currency = getPlatformCurrencyType()
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    
    var router: Router?
    weak var delegate: BaseTableViewProtocol?
    init(_ router: Router?, delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
        self.router = router
    }
    
    func fetch(_ refresh: Bool = false) {
        if refresh {
            skip = 0
        }
        var models = [TradingTableViewCellViewModel]()
        DashboardDataProvider.getPrivateTrading(currency: currency, status: .all, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.items?.forEach({ (asset) in
                let viewModel = TradingTableViewCellViewModel(asset: asset, filterProtocol: nil)//FIXIT:
                models.append(viewModel)
            })
            self?.updateViewModels(models, refresh: refresh, total: model.total)
            }, errorCompletion: errorCompletion)
    }
    
    func updateViewModels(_ models: [CellViewAnyModel], refresh: Bool, total: Int?) {
        totalCount = total ?? 0
        skip += take()
        viewModels = refresh ? models : viewModels + models
        delegate?.didReload()
    }
    
    func cellAnimations() -> Bool {
        return true
    }
    
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.tradingPrivateList, cellViewModel: model(for: indexPath))
    }
    
    @available(iOS 13.0, *)
    func getMenu(_ indexPath: IndexPath) -> UIMenu? {
        guard let model = model(for: indexPath) as? TradingTableViewCellViewModel,
            let assetType = model.asset.assetType,
            let actions = model.asset.actions else { return nil }
        
        var children = [UIAction]()
        
        if let name = model.asset.publicInfo?.url {
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] action in
                let url = getRoute(assetType, name: name)
                self?.router?.share(url)
            }
            children.append(share)
        }
        
        if let canMakeProgramFromPrivateTradingAccount = actions.canMakeProgramFromPrivateTradingAccount, canMakeProgramFromPrivateTradingAccount {
            let makeProgram = UIAction(title: "Make program", image: nil) { [weak self] action in
                self?.delegate?.didSelect(.makeProgram, cellViewModel: model)
            }
            children.append(makeProgram)
        }
        
        if let canMakeSignalProviderFromPrivateTradingAccount = actions.canMakeSignalProviderFromPrivateTradingAccount, canMakeSignalProviderFromPrivateTradingAccount {
            let makeSignal = UIAction(title: "Make signal", image: nil) { [weak self] action in
                self?.delegate?.didSelect(.makeSignal, cellViewModel: model)
            }
            children.append(makeSignal)
        }
        
        if let canChangePassword = actions.canChangePassword, canChangePassword {
            let changePassword = UIAction(title: "Change password", image: nil) { [weak self] action in
                self?.delegate?.didSelect(.changePassword, cellViewModel: model)
            }
            children.append(changePassword)
        }
        
        guard !children.isEmpty else { return nil }
        
        return UIMenu(title: "", children: children)
    }
}
