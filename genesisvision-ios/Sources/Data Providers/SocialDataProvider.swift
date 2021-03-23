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
    
    static func likePost(postId: UUID, completion: @escaping CompletionBlock) {
        
        SocialAPI.likePost(_id: postId) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func unlikePost(postId: UUID, completion: @escaping CompletionBlock) {
        
        SocialAPI.unlikePost(_id: postId) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func getPost(postId: UUID, completion: @escaping (_ post: Post?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        SocialAPI.getPost(_id: postId.uuidString) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func rePost(model: RePost?, completion: @escaping CompletionBlock) {
        SocialAPI.rePost(body: model) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func addPost(model: NewPost?, completion: @escaping CompletionBlock) {
        SocialAPI.addPost(body: model) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func getMedia(completion: @escaping (_ signalTradingEvents: MediaPostItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        SocialAPI.getSocialMedia { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func unfollow(userId: UUID, completion: @escaping CompletionBlock) {
        SocialAPI.unfollowUser(userId: userId) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func follow(userId: UUID, completion: @escaping CompletionBlock) {
        SocialAPI.followUser(userId: userId) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func deletePost(postId: UUID, completion: @escaping CompletionBlock) {
        SocialAPI.deletePost(_id: postId) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func report(on postId: String, reason: String?, text: String?, completion: @escaping CompletionBlock) {
        SocialAPI.spamReport(_id: postId, reason: reason, text: text) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func pin(postId: UUID, completion: @escaping CompletionBlock) {
        SocialAPI.pinPost(_id: postId) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
    
    static func unpin(postId: UUID, completion: @escaping CompletionBlock) {
        SocialAPI.unpinPost(_id: postId) { (viewModel, error) in
            DataProvider().responseHandler(error, completion: completion)
        }
    }
}
