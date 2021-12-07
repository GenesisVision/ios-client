//
//  SocialMediaViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 20.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import Foundation

final class SocialMediaViewModel {
    
    var socialMediaCollectionViewModel: SocialMediaCollectionViewModel!
    var socialMediaCollectionViewDataSource: CollectionViewDataSource!
    var router: SocialRouter!
    
    init(router: SocialRouter, socialMediaCollectionViewModelDelegate: SocialMediaCollectionViewModelDelegate) {
        socialMediaCollectionViewModel = SocialMediaCollectionViewModel(type: .social, title: "", delegate: socialMediaCollectionViewModelDelegate)
        socialMediaCollectionViewDataSource = CollectionViewDataSource(socialMediaCollectionViewModel)
        self.router = router
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        socialMediaCollectionViewModel.fetch(completion: completion)
    }
    
    func deletePost(postId: UUID, completion: @escaping CompletionBlock) {
        socialMediaCollectionViewModel.deletePost(postId: postId, completion: completion)
    }
}
