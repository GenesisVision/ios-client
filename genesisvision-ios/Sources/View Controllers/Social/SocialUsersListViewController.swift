//
//  SocialUsersListViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 14.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class SocialUsersListViewController: BaseViewControllerWithTableView {
    
    var viewModel: SocialUsersListViewModel!
    
    override var tableView: UITableView! {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Users"
        setupTableConfiguration()
    }
    
    private func setupHeaderView() {
        let rect = CGRect(x: tableView.frame.minX, y: tableView.frame.minY, width: tableView.width, height: 60)
        let headerView = SearchHeaderView(frame: rect)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.searchFieldDelegate = self
        
        self.view.addSubview(headerView)
        
        headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 50))
    }
    
    private func setupTableConfiguration() {
        tableView.removeFromSuperview()
        tableView = UITableView(frame: .zero, style: tableViewStyle)
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
        
        tableView.roundCorners(with: 10)
        tableView.configure(with: .defaultConfiguration)
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: tableView)
    }
    
    private func setupTableHeaderView() {
        let rect = CGRect(x: tableView.frame.minX, y: tableView.frame.minY, width: 390, height: 50)
        let headerView = SearchHeaderView(frame: rect)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.searchFieldDelegate = self
        tableView.tableHeaderView = headerView
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        viewModel.fetch(true)
    }
    
    override func fetchMore() {
    }
}

extension SocialUsersListViewController: SearchHeaderTextChangedProtocol {
    func textChanged(text: String) {
        guard !text.isEmpty else { return }
    }
}

extension SocialUsersListViewController: BaseTableViewProtocol {
    func didShowInfiniteIndicator(_ value: Bool) {
        showInfiniteIndicator(value: value)
    }
    
    func didReload() {
        DispatchQueue.main.async {
            self.hideAll()
            self.tableView.reloadData()
        }
    }
    
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        guard let userId = (cellViewModel as? SocialUsersListTableViewCellViewModel)?.user.userId?.uuidString else { return }
        viewModel.router.showUserDetails(with: userId)
    }
}


final class SocialUsersListViewModel: ListViewModelWithPaging {
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    typealias CellViewModel = SocialUsersListTableViewCellViewModel
    
    var canFetchMoreResults: Bool = true
    
    var canPullToRefresh: Bool = true
    
    var skip: Int = 0
    
    var viewModels: [CellViewAnyModel] = []
    
    var totalCount: Int = 0
    
    var copyViewModels: [CellViewAnyModel] = []
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SocialUsersListTableViewCellViewModel.self]
    }
    
    var users: [UserDetailsList] = [UserDetailsList]()
    var router: SocialRouter!
    
    weak var delegate: BaseTableViewProtocol?
    
    init(with router: SocialRouter, delegate: BaseTableViewProtocol) {
        self.delegate = delegate
        self.router = router
        fetch(false)
    }
    
    func updateViewModels(_ models: [CellViewAnyModel], refresh: Bool) {
        viewModels = refresh ? models : viewModels + models
        copyViewModels = viewModels
        totalCount = viewModels.count
        if models.count > 0 {
            skip += take()
        }
        
        delegate?.didReload()
    }
    
    func fetch(_ refresh: Bool) {
        if refresh {
            skip = 0
        }
        UsersDataProvider.getList(sorting: nil, tags: nil, skip: skip, take: take()) { [weak self] (viewModel) in
            if let users = viewModel?.items {
                self?.users = users
                
                var models = [SocialUsersListTableViewCellViewModel]()
                users.forEach({ models.append(SocialUsersListTableViewCellViewModel(user: $0, delegate: self)) })
                
                self?.updateViewModels(models, refresh: refresh)
            }
        } errorCompletion: { _ in }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        return viewModels[indexPath.row]
    }
    
    func numberOfRows(in section: Int) -> Int {
        viewModels.count
    }
    
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.none, cellViewModel: viewModels[indexPath.row])
    }
    
    func fetchMore(at indexPath: IndexPath) {
        if numberOfSections() == indexPath.section + 1
            && numberOfRows(in: indexPath.section) - ApiKeys.fetchThreshold == indexPath.row
            && canFetchMoreResults && modelsCount() >= take() {
            fetch(false)
        }

        showInfiniteIndicator(skip < totalCount)
    }
}

extension SocialUsersListViewModel: SocialUsersListTableViewCellDelegate {
    func followPressed(userId: UUID, followed: Bool) {
        followed ?
            SocialDataProvider.unfollow(userId: userId, completion: { _ in })
            : SocialDataProvider.follow(userId: userId, completion: { _ in })
    }
}
