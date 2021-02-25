//
//  TradingPublicListViewController.swift
//  genesisvision-ios
//
//  Created by George on 24.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class TradingPublicListViewController: ListViewController, DashboardTradingAcionsProtocol {
    typealias ViewModel = TradingPublicListViewModel
    
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
    
    @objc private func addNewButtonAction() {
        guard let viewController = FundPublicInfoViewController.storyboardInstance(.fund) else { return }
        viewController.title = "Create Fund"
        viewController.viewModel = FundPublicInfoViewModel(mode: .create)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAsset(_ asset: TradingTableViewCellViewModel) {
        guard let assetId = asset.asset._id?.uuidString, let type = asset.asset.assetType else { return }
        viewModel.router?.showAssetDetails(with: assetId, assetType: type)
    }
}

extension TradingPublicListViewController: BaseTableViewProtocol {
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value)
    }
    
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        switch type {
        case .tradingPublicList:
            if let cellViewModel = cellViewModel as? TradingTableViewCellViewModel {
                showAsset(cellViewModel)
            }
        case .makeSignal:
            if let cellViewModel = cellViewModel as? TradingTableViewCellViewModel {
                makeSignal(cellViewModel.asset)
            }
        case .makeProgram:
            if let cellViewModel = cellViewModel as? TradingTableViewCellViewModel {
                makeProgram(cellViewModel.asset)
            }
        case .closePeriod:
            if let cellViewModel = cellViewModel as? TradingTableViewCellViewModel {
                closePeriod(cellViewModel.asset)
            }
        default:
            break
        }
    }
}

class TradingPublicListViewModel: ListViewModelWithPaging {
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
        DashboardDataProvider.getPublicTrading(currency: currency, status: .all, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.items?.forEach({ (asset) in
                //FIXIT: Add filterProtocol
                let viewModel = TradingTableViewCellViewModel(asset: asset, filterProtocol: nil)
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
            let closePeriod = UIAction(title: "Close period", image: nil) { [weak self] action in
                self?.delegate?.didSelect(.closePeriod, cellViewModel: model)
            }
            children.append(closePeriod)
        }
        
        if let canMakeProgramFromSignalProvider = actions.canMakeProgramFromSignalProvider, canMakeProgramFromSignalProvider {
            let makeProgram = UIAction(title: "Make program", image: nil) { [weak self] action in
                self?.delegate?.didSelect(.makeProgram, cellViewModel: model)
            }
            children.append(makeProgram)
        }
        
        if let canMakeSignalProviderFromProgram = actions.canMakeSignalProviderFromProgram, canMakeSignalProviderFromProgram {
            let makeSignal = UIAction(title: "Make a signal provider", image: nil) { [weak self] action in
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
        
        let settings = UIAction(title: "Settings", image: nil) { [weak self] action in
            self?.delegate?.didSelect(.openSettings, cellViewModel: model)
        }
        children.append(settings)
        
        guard !children.isEmpty else { return nil }
        
        return UIMenu(title: "", children: children)
    }
}
