//
//  SocialMediaListViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 15.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

class SocialMediaListViewController: BaseViewControllerWithTableView {
    
    var viewModel: SocialMediaListViewModel!
    
    override var tableView: UITableView! {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Media"
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
        tableView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        
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
        viewModel.fetch(true)
    }
    
    override func fetchMore() {
    }
}

extension SocialMediaListViewController: SearchHeaderTextChangedProtocol {
    func textChanged(text: String) {
        guard !text.isEmpty else { return }
    }
}

extension SocialMediaListViewController: BaseTableViewProtocol {
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
        guard let mediaPost = cellViewModel as? SocialMediaListTableViewCellViewModel,
              let postUrl = mediaPost.mediaPost.url else { return }
        
        openSafariVC(with: postUrl)
    }
}


final class SocialMediaListViewModel: ListViewModelWithPaging {
    
    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    typealias CellViewModel = SocialMediaListTableViewCellViewModel
    
    var canFetchMoreResults: Bool = true
    
    var canPullToRefresh: Bool = true
    
    var skip: Int = 0
    
    var viewModels: [CellViewAnyModel] = []
    
    var totalCount: Int = 0
    
    var copyViewModels: [CellViewAnyModel] = []
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SocialMediaListTableViewCellViewModel.self]
    }
    
    var posts: [MediaPost] = [MediaPost]()
    
    weak var delegate: BaseTableViewProtocol?
    
    init(delegate: BaseTableViewProtocol) {
        self.delegate = delegate
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
        
        SocialDataProvider.getMedia { [weak self] (viewModel) in
            if let mediaPosts = viewModel?.items {
                self?.posts = mediaPosts
                
                var models = [SocialMediaListTableViewCellViewModel]()
                
                mediaPosts.forEach({ models.append(SocialMediaListTableViewCellViewModel(mediaPost: $0)) })
                
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

