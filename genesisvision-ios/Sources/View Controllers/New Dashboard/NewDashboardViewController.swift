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
    
    // MARK: - Variables
    var viewModel: ViewModel!
    var dataSource: TableViewDataSource<ViewModel>!
    
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
        
        viewModel = ViewModel(self)
        tableView.configure(with: .defaultConfiguration)

        dataSource = TableViewDataSource(viewModel)
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}

extension NewDashboardViewController: BaseCellProtocol {
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        print("show all \(type)")
        
        switch type {
        case .dashboardTrading:
            guard let vc = CreateFundViewController.storyboardInstance(.dashboard) else { return }
            vc.title = "Modal"
            let nav = BaseNavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
//            let vc = BaseViewController()
//            vc.title = "Event"
//            navigationController?.pushViewController(vc, animated: true)
        case .dashboardInvesting:
            let vc = BaseViewController()
            vc.title = "Event"
            navigationController?.pushViewController(vc, animated: true)
        case .dashboardRecommendation:
            let vc = BaseViewController()
            vc.title = "Asset"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func action(_ type: CellActionType, actionType: ActionType) {
        print("show all \(type)")
        
        switch type {
        case .dashboardTrading:
            let vc = TradingViewController()
            vc.title = "Trading"
            navigationController?.pushViewController(vc, animated: true)
        case .dashboardInvesting:
            let vc = InvestingViewController()
            vc.title = "Investing"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

class NewDashboardViewModel: ListVMProtocol {
    var viewModels = [CellViewAnyModel]()
    
    var canPullToRefresh: Bool = true
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [DashboardOverviewTableViewCellViewModel.self,
                DashboardTradingCellViewModel<TradingCollectionViewModel>.self,
                DashboardInvestingCellViewModel<InvestingCollectionViewModel>.self,
                DashboardPortfolioChartTableViewCellViewModel.self,
                CellWithCollectionViewModel<DashboardRecommendationsViewModel>.self]
    }
    weak var delegate: BaseCellProtocol?
    init(_ delegate: BaseCellProtocol?) {
        self.delegate = delegate
    }
    
    func fetch() {
        viewModels.append(DashboardOverviewTableViewCellViewModel(data: DashboardOverviewData(), delegate: delegate))

        viewModels.append(DashboardTradingCellViewModel(TradingCollectionViewModel(delegate), data: TradingHeaderData(title: "Trading", showActionsView: true), delegate: delegate))
        viewModels.append(DashboardInvestingCellViewModel(InvestingCollectionViewModel(delegate), data: InvestingHeaderData(title: "Investing", showActionsView: true), delegate: delegate))
        
        viewModels.append(DashboardPortfolioChartTableViewCellViewModel(data: DashboardPortfolioData(), delegate: delegate))
        viewModels.append(CellWithCollectionViewModel(DashboardRecommendationsViewModel(delegate), delegate: delegate))
        
        delegate?.didReload()
    }
}
