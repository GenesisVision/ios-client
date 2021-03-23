//
//  SocialFeedCollectionViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 17.12.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

protocol SocialFeedCollectionViewModelDelegate: class {
    func commentPost(postId: UUID)
    func sharePost(postId: UUID)
    func tagPressed(tag: PostTag)
    func userOwnerPressed(userDetails: ProfilePublic)
    func reloadCollectionViewData()
    func reloadCells(cells: [IndexPath])
    func openPost(post: Post)
    func showPostActions(postActions: [SocialPostAction], postId: UUID, postLink: String)
}

final class SocialFeedCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var skip: Int = 0
    var take: Int = 12
    var totalCount: Int = 0
    
    var selectedIndex: Int = 0

    var viewModels = [CellViewAnyModel]()

    var canPullToRefresh: Bool = true
    var showOnlyUsersPosts: Bool = true
    var feedType: SocialFeedType = .feed
        
    let collectionTopInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionBottomInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionLeftInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionRightInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionLineSpacing: CGFloat = Constants.SystemSizes.Cell.lineSpacing
    let collectionInteritemSpacing: CGFloat = Constants.SystemSizes.Cell.interitemSpacing

    var viewModelsForRegistration: [UITableViewHeaderFooterView.Type] {
        return []
    }

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SocialFeedCollectionViewCellViewModel.self]
    }
    
    var shouldHightlight: Bool = false
    var shouldUnhightlight: Bool = false
    
    weak var delegate: SocialFeedCollectionViewModelDelegate?
    
    init(type: CellActionType, title: String, delegate: SocialFeedCollectionViewModelDelegate, showOnlyUsersPosts: Bool = true) {
        self.type = type
        self.title = title
        self.delegate = delegate
        self.showOnlyUsersPosts = showOnlyUsersPosts
    }
    
    func didSelect(at indexPath: IndexPath) {
        guard let postViewModel = viewModels[safe: indexPath.row] as?  SocialFeedCollectionViewCellViewModel else { return }
        delegate?.openPost(post: postViewModel.post)
    }
    
    func postActionsForPost(postId: UUID) -> [SocialPostAction] {
        var postActions: [SocialPostAction] = []
        
        guard let postViewModel = viewModels.first(where: {
            guard let model = $0 as? SocialFeedCollectionViewCellViewModel, model.post._id == postId else { return false }
            return true
        }) as? SocialFeedCollectionViewCellViewModel, let postId = postViewModel.post._id else { return postActions }
        
        postActions.append(.report(postId: postId))
        
        if let canDelete = postViewModel.post.personalDetails?.canDelete, canDelete {
            postActions.append(.delete(postId: postId))
        }
        
        if let canPin = postViewModel.post.personalDetails?.canPin, canPin, let isPinned = postViewModel.post.isPinned {
            isPinned ? postActions.append(.unpin(postId: postId)) : postActions.append(.pin(postId: postId))
        }
        
        if let canEdit = postViewModel.post.personalDetails?.canEdit, canEdit {
            postActions.append(.edit(postId: postId))
        }
        
        guard let url = postViewModel.post.url else { return postActions }
        
        postActions.append(contentsOf: [.copyLink(postLink: url), .share(postLink: url)])
        
        return postActions
    }
    
    func deletePost(postId: UUID, completion: @escaping CompletionBlock) {
        SocialDataProvider.deletePost(postId: postId, completion: completion)
    }
    
    func pinPost(postId: UUID, completion: @escaping CompletionBlock) {
        guard let postViewModel = viewModels.first(where: { return ($0 as? SocialFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialFeedCollectionViewCellViewModel, let pinned = postViewModel.post.isPinned else { return }

        pinned ? SocialDataProvider.unpin(postId: postId, completion: completion) : SocialDataProvider.pin(postId: postId, completion: completion)
    }
    
    func getRightButtons() -> [UIButton] {
        return []
    }
    
    func getCollectionViewHeight() -> CGFloat {
        return 150
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        return viewModels[indexPath.row]
    }
    
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize {
        let spacing: CGFloat = 0
        if let viewModel = viewModels[safe: indexPath.row] as? SocialFeedCollectionViewCellViewModel {
            return viewModel.cellSize(spacing: spacing, frame: frame)
        } else {
            let size: CGFloat = (frame.width - spacing)
            return CGSize(width: size, height: 300)
        }
    }
    
    func insetForSection(for section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionTopInset, left: 0, bottom: collectionBottomInset, right: 0)
    }
    
    func minimumLineSpacing(for section: Int) -> CGFloat {
        return collectionLineSpacing
    }
    
    func minimumInteritemSpacing(for section: Int) -> CGFloat {
        return collectionInteritemSpacing
    }
    
    func numberOfRows(in section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func fetch(completion: @escaping CompletionBlock, refresh: Bool? = nil, feedType: SocialFeedType) {
        
        let refresh = refresh ?? false
        let skip = refresh ? 0 : self.skip
        self.feedType = feedType
        
        var models = [SocialFeedCollectionViewCellViewModel]()
        
        switch feedType {
        case .live:
            SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: showOnlyUsersPosts, skip: skip, take: take) { [weak self] (postsViewModel) in
                if let viewModel = postsViewModel, let total = postsViewModel?.total {
                    viewModel.items?.forEach({ (model) in
                        let viewModel = SocialFeedCollectionViewCellViewModel(post: model, cellDelegate: self)
                        models.append(viewModel)
                    })
                    self?.updateViewModels(models, refresh: refresh, total: total)
                }
                completion(.success)
            } errorCompletion: { _ in }
        case .hot:
            SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: true, showLiked: nil, showOnlyUsersPosts: showOnlyUsersPosts, skip: skip, take: take) { [weak self] (postsViewModel) in
                if let viewModel = postsViewModel, let total = postsViewModel?.total {
                    viewModel.items?.forEach({ (model) in
                        let viewModel = SocialFeedCollectionViewCellViewModel(post: model, cellDelegate: self)
                        models.append(viewModel)
                    })
                    self?.updateViewModels(models, refresh: refresh, total: total)
                }
                completion(.success)
            } errorCompletion: { _ in }
        case .feed:
            SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: .friendsPosts, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: showOnlyUsersPosts, skip: skip, take: take) { [weak self] (postsViewModel) in
                if let viewModel = postsViewModel, let total = postsViewModel?.total {
                    viewModel.items?.forEach({ (model) in
                        let viewModel = SocialFeedCollectionViewCellViewModel(post: model, cellDelegate: self)
                        models.append(viewModel)
                    })
                    self?.updateViewModels(models, refresh: refresh, total: total)
                }
                completion(.success)
            } errorCompletion: { _ in }
        }
    }
    
    func fetchMore() {
        fetch(completion: { [weak self] (result) in
            switch result {
            case .success:
                self?.delegate?.reloadCollectionViewData()
            case .failure(errorType: _):
                break
            }
        }, refresh: false, feedType: feedType)
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        
    }
    
    func updateViewModels(_ models: [CellViewAnyModel], refresh: Bool, total: Int?) {
        totalCount = total ?? 0
        if models.count > 0 {
            skip += take
        }
        viewModels = refresh ? models : viewModels + models
    }
}

extension SocialFeedCollectionViewModel: SocialFeedCollectionViewCellDelegate {
    func postActionsPressed(postId: UUID) {
        let postActions = postActionsForPost(postId: postId)
        var postLink: String = ""

        if let postViewModel = viewModels.first(where: { return ($0 as? SocialFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialFeedCollectionViewCellViewModel, let url = postViewModel.post.url {
            postLink = ApiKeys.socialPostsPath + url }
        
        
        delegate?.showPostActions(postActions: postActions, postId: postId, postLink: postLink)
    }
    
    func userOwnerPressed(postId: UUID) {
        guard let postViewModel = viewModels.first(where: {return ($0 as? SocialFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialFeedCollectionViewCellViewModel, let userDetails = postViewModel.post.author else {
            return
        }
        delegate?.userOwnerPressed(userDetails: userDetails)
    }
    
    func commentTouched(postId: UUID) {
        delegate?.commentPost(postId: postId)
    }
    
    func likeTouched(postId: UUID) {
        guard let _ = viewModels.first(where: {return ($0 as? SocialFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialFeedCollectionViewCellViewModel else {
            return
        }
        
        SocialDataProvider.getPost(postId: postId) { (post) in
            if let isLiked = post?.personalDetails?.isLiked {
                isLiked ? SocialDataProvider.unlikePost(postId: postId) { _ in } : SocialDataProvider.likePost(postId: postId) { _ in }
            }
        } errorCompletion: { _ in }
    }
    
    func shareTouched(postId: UUID) {
        delegate?.sharePost(postId: postId)
    }
    
    func tagPressed(tag: PostTag) {
        delegate?.tagPressed(tag: tag)
    }
}

