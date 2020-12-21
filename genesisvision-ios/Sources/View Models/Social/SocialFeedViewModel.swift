//
//  SocialFeedViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 17.12.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation

enum SocialFeedType {
    case live
    case hot
    case feed
}

final class SocialFeedViewModel {
    
    var socialCollectionViewModel: SocialFeedCollectionViewModel!
    var socialCollectionViewDataSource: CollectionViewDataSource!

    let feedType: SocialFeedType

    init(feedType: SocialFeedType) {

        self.feedType = feedType
        socialCollectionViewModel = SocialFeedCollectionViewModel(type: .social, title: "")
        socialCollectionViewDataSource = CollectionViewDataSource(socialCollectionViewModel)
    }
    
    func fetch(completion: @escaping CompletionBlock, refresh: Bool? = nil) {
        socialCollectionViewModel.fetch(completion: completion, refresh: refresh, feedType: feedType)
    }

//    func fetch(completion: @escaping CompletionBlock, refresh: Bool? = nil) {
//
//        let refresh = refresh ?? false
//        let skip = refresh ? 0 : self.skip
//
//        var models = [CellViewModel]()
//
//        switch feedType {
//        case .live:
//            SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: true, skip: skip, take: take() - 2) { [weak self] (postsViewModel) in
//                if let viewModel = postsViewModel, let total = postsViewModel?.total {
//                    viewModel.items?.forEach({ (model) in
//                        let viewModel = SocialFeedTableViewCellViewModel(post: model)
//                        models.append(viewModel)
//                    })
//                    self?.updateViewModels(models, refresh: refresh, total: total)
//                }
//                completion(.success)
//            } errorCompletion: { _ in }
//        case .hot:
//            SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: true, showLiked: nil, showOnlyUsersPosts: nil, skip: skip, take: take() - 2) { [weak self] (postsViewModel) in
//                if let viewModel = postsViewModel, let total = postsViewModel?.total {
//                    viewModel.items?.forEach({ (model) in
//                        let viewModel = SocialFeedTableViewCellViewModel(post: model)
//                        models.append(viewModel)
//                    })
//                    self?.updateViewModels(models, refresh: refresh, total: total)
//                }
//                completion(.success)
//            } errorCompletion: { _ in }
//        case .feed:
//            SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: nil, skip: skip, take: take() - 2) { [weak self] (postsViewModel) in
//                if let viewModel = postsViewModel, let total = postsViewModel?.total {
//                    viewModel.items?.forEach({ (model) in
//                        let viewModel = SocialFeedCollectionViewCellViewModel(post: model)
//                        models.append(viewModel)
//                    })
//                    self?.updateViewModels(models, refresh: refresh, total: total)
//                }
//                completion(.success)
//            } errorCompletion: { _ in }
//        }
//    }

//    func refresh(completion: @escaping CompletionBlock) {
//
//    }
//
//    func fetch() {
//
//    }
//
//    func fetch(_ refresh: Bool) {
//        fetch(completion: { (result) in
//        }, refresh: refresh)
//    }
//
//    func updateViewModels(_ models: [CellViewAnyModel], refresh: Bool, total: Int?) {
//        totalCount = total ?? 0
//        if models.count > 0 {
//            skip += take()
//        }
//        viewModels = refresh ? models : viewModels + models
//        tableViewDelegate?.didReload()
//    }
}
