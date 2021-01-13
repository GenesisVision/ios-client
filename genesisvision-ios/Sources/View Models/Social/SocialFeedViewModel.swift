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

    init(feedType: SocialFeedType, collectionViewDelegate: SocialFeedCollectionViewModelProtocol) {

        self.feedType = feedType
        socialCollectionViewModel = SocialFeedCollectionViewModel(type: .social, title: "", delegate: collectionViewDelegate)
        socialCollectionViewDataSource = CollectionViewDataSource(socialCollectionViewModel)
    }
    
    func fetch(completion: @escaping CompletionBlock, refresh: Bool? = nil) {
        socialCollectionViewModel.fetch(completion: completion, refresh: refresh, feedType: feedType)
    }
}
