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
    
    var showOnlyUsersPosts: Bool = true {
        didSet {
            socialCollectionViewModel.showOnlyUsersPosts = showOnlyUsersPosts
        }
    }
    
    let showEventsButton: Bool
    
    let feedType: SocialFeedType
    let socialRouter: SocialRouter

    init(feedType: SocialFeedType, collectionViewDelegate: SocialFeedCollectionViewModelDelegate, router: SocialRouter, showEvents: Bool = false, showAddPost: Bool = false, showEventsButton: Bool = false) {
        self.feedType = feedType
        self.socialRouter = router
        self.showOnlyUsersPosts = !showEvents
        self.showEventsButton = showEventsButton
        
        socialCollectionViewModel = SocialFeedCollectionViewModel(type: .social, title: "", delegate: collectionViewDelegate, showOnlyUsersPosts: !showEvents, showAddPost: showAddPost)
        socialCollectionViewDataSource = CollectionViewDataSource(socialCollectionViewModel)
    }
    
    func fetch(completion: @escaping CompletionBlock, refresh: Bool? = nil) {
        socialCollectionViewModel.fetch(completion: completion, refresh: refresh, feedType: feedType)
    }
    
    func deletePost(postId: UUID, completion: @escaping CompletionBlock) {
        socialCollectionViewModel.deletePost(postId: postId, completion: completion)
    }
    
    func pinPost(postId: UUID, completion: @escaping CompletionBlock) {
        socialCollectionViewModel.pinPost(postId: postId, completion: completion)
    }
}
