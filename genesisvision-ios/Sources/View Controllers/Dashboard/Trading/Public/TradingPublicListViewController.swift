//
//  TradingPublicListViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingPublicListViewController: ListViewController {
    typealias ViewModel = TradingPublicListViewModel
    
    // MARK: - Variables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    
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
        
//        viewModel = ViewModel(self, router: <#Router?#>)
        isEnableInfiniteIndicator = true
        tableView.configure(with: .defaultConfiguration)

        dataSource = TableViewDataSource(viewModel)
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    @objc private func addNewButtonAction() {
        guard let vc = CreateFundViewController.storyboardInstance(.dashboard) else { return }
        vc.title = "Create Fund"
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func showAsset(_ asset: AssetCollectionViewCellViewModel) {
        var assetId = ""
        let type = asset.type
        
        switch type {
        case .program:
            if let program = asset.asset.program {
                assetId = program.id?.uuidString ?? ""
            } else if let tradingAsset = asset.asset.tradingAsset, tradingAsset.assetType == type {
                assetId = tradingAsset.id?.uuidString ?? ""
            }
        case .fund:
            if let fund = asset.asset.fund {
                assetId = fund.id?.uuidString ?? ""
            } else if let tradingAsset = asset.asset.tradingAsset, tradingAsset.assetType == type {
                assetId = tradingAsset.id?.uuidString ?? ""
            }
        case .follow:
            if let follow = asset.asset.follow {
                assetId = follow.id?.uuidString ?? ""
            } else if let tradingAsset = asset.asset.tradingAsset, tradingAsset.assetType == type {
                assetId = tradingAsset.id?.uuidString ?? ""
            }
        case ._none:
            break
        }
        
        if !assetId.isEmpty {
            viewModel.router?.showAssetDetails(with: assetId, assetType: type)
        }
    }
}

extension TradingPublicListViewController: BaseTableViewProtocol {
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value)
    }
    
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        switch type {
        case .tradingPublicList:
            if let cellViewModel = cellViewModel as? AssetCollectionViewCellViewModel {
                showAsset(cellViewModel)
            }
        default:
            break
        }
    }
}

class TradingPublicListViewModel: ListViewModelWithPaging {
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FundTableViewCellViewModel.self]
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
        DashboardDataProvider.getPublicTrading(currency: currency, status: .active, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.items?.forEach({ (asset) in
                let viewModel = TradingTableViewCellViewModel(asset: asset, delegate: nil)
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
        delegate?.didSelect(.tradingPublicList, cellViewModel: model(for: indexPath))
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
        
        if let assetType = model.asset.assetType, assetType == .program {
            let closePriod = UIAction(title: "Close period", image: nil) { [weak self] action in
                //TODO: Make signal action
            }
            children.append(closePriod)
        }
        
        if let canMakeProgramFromSignalProvider = actions.canMakeProgramFromSignalProvider, canMakeProgramFromSignalProvider {
            let makeProgram = UIAction(title: "Make program", image: nil) { [weak self] action in
                //TODO: Make signal action
            }
            children.append(makeProgram)
        }
        
        if let canMakeSignalProviderFromProgram = actions.canMakeSignalProviderFromProgram, canMakeSignalProviderFromProgram {
            let makeSignal = UIAction(title: "Make a signal provider", image: nil) { [weak self] action in
                //TODO: Make signal action
            }
            children.append(makeSignal)
        }
        
        if let canChangePassword = actions.canChangePassword, canChangePassword {
            let changePassword = UIAction(title: "Change password", image: nil) { [weak self] action in
                //TODO: Make signal action
            }
            children.append(changePassword)
        }
        
        let settings = UIAction(title: "Settings", image: nil) { [weak self] action in
            //TODO: Make signal action
        }
        children.append(settings)
        
        guard !children.isEmpty else { return nil }
        
        return UIMenu(title: "", children: children)
    }
}
