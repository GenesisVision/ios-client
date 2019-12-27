//
//  NewDashboardViewController.swift
//  genesisvision-ios
//
//  Created by George on 14.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class NewDashboardViewController: ListViewController {
    typealias ViewModel = NewDashboardViewModel
    
    // MARK: - Veriables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    var titleLabel = UILabel() {
        didSet {
            titleLabel.textColor = .white
            titleLabel.font = UIFont.getFont(.regular, size: 17.0)
        }
    }
    private var notificationsBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        showProgressHUD()
        viewModel.fetch()
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.fetch()
    }
    
    private func setup() {
        setupPullToRefresh(scrollView: tableView)
        tableView.configure(with: .defaultConfiguration)

        dataSource = TableViewDataSource(viewModel)
        dataSource.delegate = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
        
        titleLabel.text = viewModel.getTotalValue()
        let titleView = UIStackView()
        titleView.addArrangedSubview(titleLabel)
        navigationItem.titleView = titleView
        titleLabel.alpha = 0.0
        
        notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
        navigationItem.leftBarButtonItems = [notificationsBarButtonItem]
    }
    
    @objc func notificationsButtonAction() {
        viewModel.showNotificationList()
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationsBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
        navigationItem.leftBarButtonItems = [notificationsBarButtonItem]
    }
}

extension NewDashboardViewController: DelegateManagerProtocol {
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
}

extension NewDashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 40.0 {
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.alpha = 0.0
            }
        } else if scrollView.contentOffset.y > 40.0 {
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.alpha = 1.0
            }
        }
    }
}

extension NewDashboardViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        print("select cell \(type)")
        
        switch type {
        case .dashboardTrading, .dashboardInvesting:
            if let viewModel = cellViewModel as? PortfolioEventCollectionViewCellViewModel {
                self.showEvent(viewModel.event)
            }
        case .dashboardRecommendation:
            if let cellViewModel = cellViewModel as? AssetCollectionViewCellViewModel {
                self.showAsset(cellViewModel)
            }
        default:
            break
        }
    }
    
    func action(_ type: CellActionType, actionType: ActionType) {
        print("show all \(type)")
        
        switch type {
        case .dashboardNotifications:
            if let notificationsCount = viewModel.header?.notificationsCount {
                UIApplication.shared.applicationIconBadgeNumber = notificationsCount
                notificationsBarButtonItem = UIBarButtonItem(image: notificationsCount > 0 ? #imageLiteral(resourceName: "img_activeNotifications_icon") : #imageLiteral(resourceName: "img_notifications_icon"), style: .done, target: self, action: #selector(notificationsButtonAction))
                navigationItem.leftBarButtonItems = [notificationsBarButtonItem]
            }
        case .dashboardTrading:
            let vc = TradingViewController()
            viewModel.router?.tradingViewController = vc
            vc.viewModel = TradingViewModel(viewModel.router)
            navigationController?.pushViewController(vc, animated: true)
        case .dashboardInvesting:
            let vc = InvestingViewController()
            viewModel.router?.investingViewController = vc
            vc.viewModel = InvestingViewModel(viewModel.router)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func didReload(_ indexPath: IndexPath) {
        titleLabel.text = viewModel.getTotalValue()
        hideHUD()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showEvent(_ event: InvestmentEventViewModel) {
        var count = 0

        if let extendedInfo = event.extendedInfo, !extendedInfo.isEmpty {
            count += extendedInfo.count
        }

        if let fees = event.feesInfo, !fees.isEmpty {
            count += fees.count + 1
        }

        let height = Double((count + 1) * 40)

        bottomSheetController = BottomSheetController()
        bottomSheetController.initializeHeight = CGFloat(230.0 + height)
        bottomSheetController.lineViewIsHidden = true

        let view = EventDetailsView.viewFromNib()
        view.configure(event)
        view.delegate = self
        bottomSheetController.addContentsView(view)
        bottomSheetController.present()
    }
    
    func showAsset(_ asset: AssetCollectionViewCellViewModel) {
        var assetId = ""
        let type = asset.type
        
        switch type {
        case .program:
            assetId = asset.asset.program?.id?.uuidString ?? ""
        case .fund:
            assetId = asset.asset.fund?.id?.uuidString ?? ""
        case .follow:
            assetId = asset.asset.follow?.id?.uuidString ?? ""
        case ._none:
            break
        }
        
        if !assetId.isEmpty {
            viewModel.router?.showAssetDetails(with: assetId, assetType: type)
        }
    }
}

extension NewDashboardViewController: EventDetailsViewProtocol {
    func closeButtonDidPress() {
        bottomSheetController.dismiss()
    }

    func showAssetButtonDidPress(_ assetId: String, assetType: AssetType) {
        bottomSheetController.dismiss()
        viewModel.router?.showAssetDetails(with: assetId, assetType: assetType)
    }
}

class NewDashboardViewModel: ViewModelWithListProtocol {
    enum RowType {
        case overview
        case trading
        case investing
        case portfolio
        case assets
        case recommendations
    }
    
    private var rows: [RowType] = [.overview, .trading, .investing, .portfolio, .assets, .recommendations]
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true
    //Models
    var overview: DashboardSummary? {
           didSet {
            let viewModel = DashboardOverviewTableViewCellViewModel(data: DashboardOverviewData(overview, currency: currencyType), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.overview)
        }
    }
    var tradingDetails: DashboardTradingDetails? {
        didSet {
            let viewModel = DashboardTradingCellViewModel(TradingCollectionViewModel(tradingDetails, delegate: delegate), data: TradingHeaderData(title: "Trading", details: tradingDetails, currency: currencyType), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.trading)
        }
    }
    var investingDetails: DashboardInvestingDetails? {
        didSet {
            let viewModel = DashboardInvestingCellViewModel(InvestingCollectionViewModel(investingDetails, delegate: delegate), data: InvestingHeaderData(title: "Investing", details: investingDetails, currency: currencyType), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.investing)
        }
    }
    private var portfolio: DashboardPortfolio? {
        didSet {
            let viewModel = DashboardPortfolioChartTableViewCellViewModel(data: DashboardPortfolioData(portfolio), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.portfolio)
        }
    }
    private var assets: DashboardAssets? {
        didSet {
            let viewModel = DashboardAssetsChartTableViewCellViewModel(data: DashboardAssetsData(assets, currency: currencyType), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.assets)
        }
    }
    private var recommendations: CommonPublicAssetsViewModel? {
        didSet {
            let viewModel = CellWithCollectionViewModel(DashboardRecommendationsViewModel(recommendations, delegate: delegate), delegate: delegate)
            viewModels.append(viewModel)
            reloadRow(.recommendations)
        }
    }
    var header: ProfileHeaderViewModel? {
        didSet {
            delegate?.action(.dashboardNotifications, actionType: .updateNotificationsCount)
        }
    }
    var currencyType: CurrencyType {
        return getPlatformCurrencyType()
    }
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardOverviewTableViewCellViewModel.self,
                DashboardTradingCellViewModel<TradingCollectionViewModel>.self,
                DashboardInvestingCellViewModel<InvestingCollectionViewModel>.self,
                DashboardPortfolioChartTableViewCellViewModel.self,
                DashboardAssetsChartTableViewCellViewModel.self,
                CellWithCollectionViewModel<DashboardRecommendationsViewModel>.self]
    }
    var router: DashboardRouter?
    weak var delegate: BaseTableViewProtocol?
    init(_ router: DashboardRouter?) {
        self.delegate = router?.dashboardViewController
        self.router = router
    }
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    private func reloadRow(_ row: RowType) {
        let reloadRow = rows.firstIndex(of: row) ?? 0
        delegate?.didReload(IndexPath(row: reloadRow, section: 0))
    }
    
    func getTotalValue() -> String {
        if let total = overview?.total {
            return total.toString() + " " + currencyType.rawValue
        }
        
        return ""
    }
    
    func fetch() {
        viewModels = [CellViewAnyModel]()
        
        DashboardDataProvider.getSummary(currencyType, completion: { [weak self] (model) in
            self?.overview = model
        }, errorCompletion: errorCompletion)
        DashboardDataProvider.getTrading(currencyType, eventsTake: 12, completion: { [weak self] (model) in
            self?.tradingDetails = model
        }, errorCompletion: errorCompletion)
        DashboardDataProvider.getInvesting(currencyType, eventsTake: 12, completion: { [weak self] (model) in
            self?.investingDetails = model
        }, errorCompletion: errorCompletion)
        DashboardDataProvider.getPortfolio(completion: { [weak self] (model) in
            self?.portfolio = model
        }, errorCompletion: errorCompletion)
        DashboardDataProvider.getHoldings(4, completion: { [weak self] (model) in
            self?.assets = model
        }, errorCompletion: errorCompletion)
        DashboardDataProvider.getRecommendations(currencyType, take: 5, completion: { [weak self] (model) in
            self?.recommendations = model
        }, errorCompletion: errorCompletion)
        
        ProfileDataProvider.getHeader(completion: { [weak self] (viewModel) in
            self?.header = viewModel
        }, errorCompletion: errorCompletion)
        
        delegate?.didReload()
    }
    
    func model(at indexPath: IndexPath) -> CellViewAnyModel? {
        let type = rows[indexPath.row]
        switch type {
        case .overview:
            return viewModels.first{ $0 is DashboardOverviewTableViewCellViewModel }
        case .trading:
            return viewModels.first{ $0 is DashboardTradingCellViewModel<TradingCollectionViewModel> }
        case .investing:
            return viewModels.first{ $0 is DashboardInvestingCellViewModel<InvestingCollectionViewModel> }
        case .portfolio:
            return viewModels.first{ $0 is DashboardPortfolioChartTableViewCellViewModel }
        case .assets:
            return viewModels.first{ $0 is DashboardAssetsChartTableViewCellViewModel }
        case .recommendations:
            return viewModels.first{ $0 is CellWithCollectionViewModel<DashboardRecommendationsViewModel>}
        }
    }
    
    func modelsCount() -> Int {
        return rows.count
    }
    
    func showNotificationList() {
        router?.showNotificationList()
    }
    
    func didSelect(at indexPath: IndexPath) {
        let type = rows[indexPath.row]
        switch type {
        case .trading:
            delegate?.action(.dashboardTrading, actionType: .showAll)
        case .investing:
            delegate?.action(.dashboardInvesting, actionType: .showAll)
        default:
            break
        }
    }
}
