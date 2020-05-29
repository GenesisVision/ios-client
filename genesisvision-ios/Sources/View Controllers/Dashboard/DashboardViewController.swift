//
//  DashboardViewController.swift
//  genesisvision-ios
//
//  Created by George on 14.11.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

class DashboardViewController: ListViewController {
    typealias ViewModel = DashboardViewModel
    
    // MARK: - Veriables
    var viewModel: ViewModel!
    var titleView = TitleView()
    
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
        navigationItem.title = ""
        
        setupPullToRefresh(scrollView: tableView)
        tableView.configure(with: .defaultConfiguration)

        viewModel.dataSource.delegate = self
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
        tableView.backgroundColor = UIColor.Cell.headerBg
        
        titleView.titleLabel.text = "Dashboard"
        titleView.balanceLabel.text = viewModel.getTotalValue()
        
        navigationItem.titleView = titleView
        
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

extension DashboardViewController: DelegateManagerProtocol {
    func delegateManagerScrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollViewDidScroll(scrollView)
    }
}

extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        titleView.animate(scrollView.contentOffset.y, value: 40.0)
    }
}

extension DashboardViewController: BaseTableViewProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        print("select cell \(type)")
        
        switch type {
        case .dashboardTrading, .dashboardInvesting:
            if let viewModel = cellViewModel as? EventCollectionViewCellViewModel {
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
            vc.title = ""
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .dashboardInvesting:
            let vc = InvestingViewController()
            viewModel.router?.investingViewController = vc
            vc.viewModel = InvestingViewModel(viewModel.router)
            vc.title = ""
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func didReload(_ indexPath: IndexPath) {
        titleView.balanceLabel.text = viewModel.getTotalValue()
        hideHUD()
        tableView.reloadSections([indexPath.section], with: .fade)
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
        let assetId = asset.getAssetId()
        let type = asset.type
        viewModel.router?.showAssetDetails(with: assetId, assetType: type)
    }
}

extension DashboardViewController: EventDetailsViewProtocol {
    func closeButtonDidPress() {
        bottomSheetController.dismiss()
    }

    func showAssetButtonDidPress(_ assetId: String, assetType: AssetType) {
        bottomSheetController.dismiss()
        viewModel.router?.showAssetDetails(with: assetId, assetType: assetType)
    }
}

class DashboardViewModel: ViewModelWithListProtocol {
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    enum SectionType {
        case overview
        case trading
        case investing
        case portfolio
        case assets
        case recommendations
    }
    
    private var sections: [SectionType] = [.overview, .investing, .trading, .portfolio, .assets, .recommendations]
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true
    //Models
    var overview: DashboardSummary? {
           didSet {
            let viewModel = DashboardOverviewTableViewCellViewModel(data: DashboardOverviewData(overview, currency: currencyType), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.overview)
        }
    }
    var tradingDetails: DashboardTradingDetails? {
        didSet {
            let viewModel = DashboardTradingCellViewModel(TradingCollectionViewModel(tradingDetails, delegate: delegate), data: TradingHeaderData(title: "Trading", details: tradingDetails, currency: currencyType), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.trading)
        }
    }
    var investingDetails: DashboardInvestingDetails? {
        didSet {
            let viewModel = DashboardInvestingCellViewModel(InvestingCollectionViewModel(investingDetails, delegate: delegate), data: InvestingHeaderData(title: "Investing", details: investingDetails, currency: currencyType), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.investing)
        }
    }
    private var portfolio: DashboardPortfolio? {
        didSet {
            let viewModel = DashboardPortfolioChartTableViewCellViewModel(data: DashboardPortfolioData(portfolio), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.portfolio)
        }
    }
    private var assets: DashboardAssets? {
        didSet {
            let viewModel = DashboardAssetsChartTableViewCellViewModel(data: DashboardAssetsData(assets, currency: currencyType), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.assets)
        }
    }
    private var recommendations: CommonPublicAssetsViewModel? {
        didSet {
            let viewModel = CellWithCollectionViewModel(DashboardRecommendationsViewModel(recommendations, delegate: delegate), delegate: delegate)
            viewModels.append(viewModel)
            reloadSection(.recommendations)
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
    private func reloadSection(_ section: SectionType) {
        let reloadSection = sections.firstIndex(of: section) ?? 0
        delegate?.didReload(IndexPath(row: 0, section: reloadSection))
    }
    
    func getTotalValue() -> String {
        if let total = overview?.total {
            return total.toString() + " " + currencyType.rawValue
        }
        
        return ""
    }
    
    func fetch() {
        viewModels = [CellViewAnyModel]()
        
        // MARK: WILL NOT WORK
        
//        DashboardDataProvider.getSummary(currencyType, completion: { [weak self] (model) in
//            self?.overview = model
//        }, errorCompletion: errorCompletion)
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
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
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
    
    func headerHeight(for section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func showNotificationList() {
        router?.showNotificationList()
    }
    
    func didSelect(at indexPath: IndexPath) {
        let type = sections[indexPath.section]
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
