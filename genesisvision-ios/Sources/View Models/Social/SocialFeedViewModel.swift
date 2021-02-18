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
    
    var showOnlyUsersPosts: Bool = false {
        didSet {
            socialCollectionViewModel.showOnlyUsersPosts = showOnlyUsersPosts
        }
    }
    
    let feedType: SocialFeedType
    let socialRouter: SocialRouter

    init(feedType: SocialFeedType, collectionViewDelegate: SocialFeedCollectionViewModelDelegate, router: SocialRouter) {
        self.feedType = feedType
        self.socialRouter = router
        socialCollectionViewModel = SocialFeedCollectionViewModel(type: .social, title: "", delegate: collectionViewDelegate)
        socialCollectionViewDataSource = CollectionViewDataSource(socialCollectionViewModel)
    }
    
    func fetch(completion: @escaping CompletionBlock, refresh: Bool? = nil) {
        socialCollectionViewModel.fetch(completion: completion, refresh: refresh, feedType: feedType)
    }
}
