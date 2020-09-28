//
//  SocialFeedViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 27.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit


class SocialFeedViewController: BaseViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var viewModel: SocialFeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.fillSuperview(padding: UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0))
        
        tableView.delegate = viewModel.dataSource
        tableView.dataSource = viewModel.dataSource
        tableView.registerNibs(for: viewModel.cellModelsForRegistration)
        tableView.separatorStyle = .none
        tableView.backgroundView = nil
        tableView.backgroundColor = .clear
        setupPullToRefresh(scrollView: tableView)
    }
}


extension SocialFeedViewController: BaseTableViewProtocol {
    func didReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


final class SocialFeedViewModel: ListViewModelWithPaging {

    lazy var dataSource: TableViewDataSource = TableViewDataSource(self)
    
    typealias CellViewModel = SocialFeedTableViewCellViewModel
    
    var canFetchMoreResults: Bool = true
    
    var canPullToRefresh: Bool = true
    
    var skip: Int = 0
    
    var viewModels: [CellViewAnyModel] = []
    
    var totalCount: Int = 0
    
    weak var tableViewDelegate: BaseTableViewProtocol?
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SocialFeedTableViewCellViewModel.self]
    }
    
    enum SocialFeedType {
        case live
        case hot
        case feed
    }
    
    let feedType: SocialFeedType
    
    init(feedType: SocialFeedType, tableViewDelegate: BaseTableViewProtocol) {
        
        self.feedType = feedType
        self.tableViewDelegate = tableViewDelegate
        
        switch feedType {
        case .live:
            fetch { (_) in
            }
        case .hot:
            break
        case .feed:
            break
        }
    }
    
    func modelsCount() -> Int {
        return viewModels.count
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        return viewModels[indexPath.row]
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        
        var models = [CellViewModel]()
        
        SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: nil, skip: skip, take: take()) { [weak self] (postsViewModel) in
            if let viewModel = postsViewModel, let total = postsViewModel?.total {
                viewModel.items?.forEach({ (model) in
                    let viewModel = SocialFeedTableViewCellViewModel(post: model)
                    models.append(viewModel)
                })
                self?.updateViewModels(models, refresh: false, total: total)
            }
            
        } errorCompletion: { _ in }
    }
    
    func updateViewModels(_ models: [CellViewAnyModel], refresh: Bool, total: Int?) {
        totalCount = total ?? 0
        if models.count > 0 {
            skip += take()
        }
        viewModels = refresh ? models : viewModels + models
        tableViewDelegate?.didReload()
    }
}
