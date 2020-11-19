//
//  ReferralHistoryViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 28.10.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit

class ReferralHistoryViewController: BaseViewControllerWithTableView {
    var viewModel: ReferralHistoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableViewHeader()
        fetch()
    }
    
    private func setup() {
        bottomViewType = .dateRange
        
        tableView.configure(with: .defaultConfiguration)

        tableView.separatorStyle = .none
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.registerHeaderNib(for: viewModel.viewModelsForRegistration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.reloadDataSmoothly()
        tableView.backgroundColor = UIColor.Cell.headerBg
        setupPullToRefresh(scrollView: tableView)
        isEnableInfiniteIndicator = false
    }
    
    private func setupTableViewHeader() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor.BaseView.bg
        
        headerView.anchorSize(size: CGSize(width: UIScreen.main.bounds.width, height: 60))
        
        let dateTitle = LargeTitleLabel()
        dateTitle.translatesAutoresizingMaskIntoConstraints = false
        dateTitle.text = "Date"
        
        let rewardTitle = LargeTitleLabel()
        rewardTitle.translatesAutoresizingMaskIntoConstraints = false
        rewardTitle.text = "Reward"
        
        headerView.addSubview(dateTitle)
        headerView.addSubview(rewardTitle)
        
        dateTitle.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: rewardTitle.leadingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), size: CGSize(width: 0, height: 40))
        
        rewardTitle.anchor(top: headerView.topAnchor, leading: headerView.centerXAnchor, bottom: headerView.bottomAnchor, trailing: headerView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10), size: CGSize(width: 0, height: 40))
        
        tableView.tableHeaderView = headerView
    }
    
    override func fetch() {
        viewModel.fetch { [weak self] (result) in
            switch result {
            case .success:
                self?.hideAll()
                self?.reloadData()
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        fetch()
    }
    
    override func updateData(from dateFrom: Date?, to dateTo: Date?) {
        viewModel.dateFrom = dateFrom
        viewModel.dateTo = dateTo
        
        showProgressHUD()
        fetch()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

final class ReferralHistoryViewModel: ViewModelWithListProtocol {
    
    var canPullToRefresh: Bool = true
    
    var viewModels: [CellViewAnyModel] = []
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    var skip: Int = 0
    
    var take =  ApiKeys.take
    
    var dateFrom: Date?
    var dateTo: Date?
    
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        ReferralDataProvider.getRewards(dateFrom: dateFrom, dateTo: dateTo, skip: skip, take: take) { [weak self] (viewModel) in
            if let items = viewModel?.items {
                items.forEach({ self?.viewModels.append(ReferralHistoryTableViewCellViewModel(rewardDetails: $0)) })
            }
            completion(.success)
        } errorCompletion: { _ in }
    }
}

extension ReferralHistoryViewModel {
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [ReferralHistoryTableViewCellViewModel.self]
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        return viewModels[indexPath.row]
    }
}
