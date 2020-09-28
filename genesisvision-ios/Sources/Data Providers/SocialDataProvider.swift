//
//  SocialDataProvider.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 27.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation

class SocialDataProvider: DataProvider {
    
    static func getFeed(userId: UUID? = nil, tagContentId: UUID? = nil, tagContentIds: [UUID]? = nil, userMode: UserFeedMode? = nil, hashTags: [String]? = nil, mask: String? = nil, showTop: Bool? = nil, showLiked: Bool? = nil, showOnlyUsersPosts: Bool? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ signalTradingEvents: PostItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        SocialAPI.getFeed(userId: userId, tagContentId: tagContentId, tagContentIds: tagContentIds, userMode: userMode, hashTags: hashTags, mask: mask, showTop: showTop, showLiked: showLiked, showOnlyUserPosts: showOnlyUsersPosts, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
        
    }
}
