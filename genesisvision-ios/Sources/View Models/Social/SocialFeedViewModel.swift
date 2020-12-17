//
//  SocialFeedViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 17.12.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation

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
            fetch { (_) in
            }
        case .feed:
            fetch { (_) in
            }
        }
    }

    func modelsCount() -> Int {
        return viewModels.count
    }

    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        return viewModels[indexPath.row]
    }

    func fetch(completion: @escaping CompletionBlock, refresh: Bool? = nil) {

        let refresh = refresh ?? false
        let skip = refresh ? 0 : self.skip

        var models = [CellViewModel]()

        switch feedType {
        case .live:
            SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: true, skip: skip, take: take() - 2) { [weak self] (postsViewModel) in
                if let viewModel = postsViewModel, let total = postsViewModel?.total {
                    viewModel.items?.forEach({ (model) in
                        let viewModel = SocialFeedTableViewCellViewModel(post: model)
                        models.append(viewModel)
                    })
                    self?.updateViewModels(models, refresh: refresh, total: total)
                }
                completion(.success)
            } errorCompletion: { _ in }
        case .hot:
            SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: true, showLiked: nil, showOnlyUsersPosts: nil, skip: skip, take: take() - 2) { [weak self] (postsViewModel) in
                if let viewModel = postsViewModel, let total = postsViewModel?.total {
                    viewModel.items?.forEach({ (model) in
                        let viewModel = SocialFeedTableViewCellViewModel(post: model)
                        models.append(viewModel)
                    })
                    self?.updateViewModels(models, refresh: refresh, total: total)
                }
                completion(.success)
            } errorCompletion: { _ in }
        case .feed:
            SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: nil, skip: skip, take: take() - 2) { [weak self] (postsViewModel) in
                if let viewModel = postsViewModel, let total = postsViewModel?.total {
                    viewModel.items?.forEach({ (model) in
                        let viewModel = SocialFeedTableViewCellViewModel(post: model)
                        models.append(viewModel)
                    })
                    self?.updateViewModels(models, refresh: refresh, total: total)
                }
                completion(.success)
            } errorCompletion: { _ in }
        }
    }

    func refresh(completion: @escaping CompletionBlock) {

    }

    func fetch() {

    }

    func fetch(_ refresh: Bool) {
        fetch(completion: { (result) in
        }, refresh: refresh)
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