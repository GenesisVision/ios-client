//
//  SocialFollowersViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 03.03.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class SocialFollowersViewController: BaseViewControllerWithTableView {
    
    var viewModel: SocialFollowersViewModel!
    
    override var tableView: UITableView! {
        didSet {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = viewModel.title
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
    
    override func pullToRefresh() {
        super.pullToRefresh()
        viewModel.fetch(true)
    }
}

extension SocialFollowersViewController: BaseTableViewProtocol {
    
    func didReload() {
        DispatchQueue.main.async {
            self.hideAll()
            self.tableView.reloadData()
        }
    }
    
    func didSelect(_ type: CellActionType, cellViewModel: CellViewAnyModel?) {
        guard let userId = (cellViewModel as? SocialFollowListTableViewCellViewModel)?.follow._id?.uuidString else { return }
        viewModel.router.showUserDetails(with: userId)
    }
}

final class SocialFollowersViewModel: ListViewModelWithPaging {
    
    enum SocialFollowListType {
        case followers
        case following
    }
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    typealias CellViewModel = SocialFollowListTableViewCellViewModel
    
    var canFetchMoreResults: Bool = false
    
    var canPullToRefresh: Bool = true
    
    var skip: Int = 0
    
    var viewModels: [CellViewAnyModel] = []
    
    var totalCount: Int = 0
    
    var copyViewModels: [CellViewAnyModel] = []
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SocialFollowListTableViewCellViewModel.self]
    }
    var users: [ProfilePublicShort] = [ProfilePublicShort]()
    var router: Router!
    var title: String = ""
    
    weak var delegate: BaseTableViewProtocol?
    
    private let userId: UUID
    private let followType: SocialFollowListType
    
    init(with router: Router, delegate: BaseTableViewProtocol, userId: UUID, followType: SocialFollowListType) {
        self.delegate = delegate
        self.router = router
        self.userId = userId
        self.followType = followType
        title = followType == .followers ? "Followers" : "Following"
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
        
        UsersDataProvider.getUserProfileFollowDetails(with: userId.uuidString) { [weak self] (viewModel) in
            if let viewModel = viewModel, let followType = self?.followType {
                switch followType {
                case .followers:
                    self?.users = viewModel.followers ?? []
                case .following:
                    self?.users = viewModel.following ?? []
                }
                
                var models = [SocialFollowListTableViewCellViewModel]()
                self?.users.forEach({ models.append(SocialFollowListTableViewCellViewModel(follow: $0, delegate: self)) })
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
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.none, cellViewModel: viewModels[indexPath.row])
    }
    
    func fetchMore(at indexPath: IndexPath) {
        if numberOfSections() == indexPath.section + 1
            && numberOfRows(in: indexPath.section) - ApiKeys.fetchThreshold == indexPath.row
            && canFetchMoreResults && modelsCount() >= take() {
            fetch(false)
        }
    }
}

extension SocialFollowersViewModel: SocialFollowListTableViewCellDelegate {
    func followPressed(userId: UUID, followed: Bool) {
        followed ?
            SocialDataProvider.unfollow(userId: userId, completion: { _ in })
            : SocialDataProvider.follow(userId: userId, completion: { _ in })
    }
}
