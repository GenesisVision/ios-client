//
//  SocialFeedCollectionViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 17.12.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

protocol SocialFeedCollectionViewModelDelegate: AnyObject {
    func commentPost(post: Post)
    func sharePost(postId: UUID)
    func tagPressed(tag: PostTag)
    func shareIdeasPressed()
    func userOwnerPressed(userDetails: ProfilePublic)
    func reloadCollectionViewData()
    func reloadCells(cells: [IndexPath])
    func openPost(post: Post)
    func showPostActions(postActions: [SocialPostAction], postId: UUID, postLink: String)
    func imagePressed(index: Int, imagesUrls: [URL])
    func touchExpandButton()
}
//MARK: - Feed Collection ViewModel
final class SocialFeedCollectionViewModel: CellViewModelWithCollection {
    var title: String
    var type: CellActionType
    
    var skip: Int = 0
    var take: Int = 12
    var totalCount: Int = 0
    
    var selectedIndex: Int = 0

    var viewModels = [CellViewAnyModel]()
    
    var addPostViewModel: SocialMediaAddPostCollectionViewCellViewModel?
    var deletedPostViewModels: [SocialFeedDeletedPostCollectionViewCellViewModel] = []
    lazy var expandedPostIds = [UUID]()
    
    enum SectionType {
        case addPost
        case feed
    }
    
    var sections: [SectionType] = [.feed]
    var hashTags: [String]!
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
        return [SocialMediaAddPostCollectionViewCellViewModel.self,
                SocialFeedCollectionViewCellViewModel.self,
                SocialFeedDeletedPostCollectionViewCellViewModel.self]
    }
    
    var shouldHightlight: Bool = false
    var shouldUnhightlight: Bool = false
    
    weak var delegate: SocialFeedCollectionViewModelDelegate?
    var showAddPost: Bool
    var feedUserId: UUID?
    
    init(type: CellActionType, title: String, delegate: SocialFeedCollectionViewModelDelegate, showOnlyUsersPosts: Bool = true, showAddPost: Bool = false, userId: UUID? = nil) {
        self.type = type
        self.title = title
        self.delegate = delegate
        self.showOnlyUsersPosts = showOnlyUsersPosts
        self.showAddPost = showAddPost
        self.feedUserId = userId
        
        fetchCanWritePost { canWritePost in
            self.showAddPost = canWritePost
            if canWritePost {
                self.sections.insert(.addPost, at: 0)
                self.addPostViewModel = SocialMediaAddPostCollectionViewCellViewModel(imageUrl: "", delegate: self)
            }
        }
    }
    
    func deletePosts() {
        for item in deletedPostViewModels {
            if let id = item.post._id {
                SocialDataProvider.deletePost(postId: id, completion: { _ in })
            }
        }
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
        
        let profileId = UserDefaults.standard.string(forKey: UserDefaultKeys.profileID)
        
        if profileId != postViewModel.post.author?._id?.uuidString {
            postActions.append(.report(postId: postId))
        }
        
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
        guard let postViewModel = viewModels.first(where: { return ($0 as? SocialFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialFeedCollectionViewCellViewModel else { return }
        deletedPostViewModels.append(SocialFeedDeletedPostCollectionViewCellViewModel(post: postViewModel.post, delegate: self))
        delegate?.reloadCollectionViewData()
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
        let type = sections[indexPath.section]
        
        switch type {
        case .addPost:
            return addPostViewModel
        case .feed:
            if let model = viewModels[indexPath.row] as? SocialFeedCollectionViewCellViewModel {
                if let deletedModel = deletedPostViewModels.first(where: { $0.post._id == model.post._id }) {
                    return deletedModel
                }
                return viewModels[indexPath.row]
            }
            return viewModels[indexPath.row]
        }
    }
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize {
        let type = sections[indexPath.section]
        
        switch type {
        case .addPost:
            return CGSize(width: frame.width, height: 50)
        case .feed:
            let spacing: CGFloat = 0
            if let viewModel = viewModels[safe: indexPath.row] as? SocialFeedCollectionViewCellViewModel {
                if let _ = deletedPostViewModels.first(where: { $0.post._id == viewModel.post._id }) {
                    return CGSize(width: frame.width, height: 70)
                } else {
                    if let _ = expandedPostIds.first(where: { $0 == viewModel.post._id }) {
                        return viewModel.cellSize(spacing: spacing, frame: frame, isExpanded: true)
                    } else {
                        return viewModel.cellSize(spacing: spacing, frame: frame)
                    }
                }
            } else {
                let size: CGFloat = (frame.width - spacing)
                return CGSize(width: size, height: 300)
            }
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
        let type = sections[section]
        
        switch type {
        case .addPost:
            return 1
        case .feed:
            return viewModels.count
        }
        
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func fetch(completion: @escaping CompletionBlock, refresh: Bool? = nil, feedType: SocialFeedType) {
        
        if showAddPost {
            AuthManager.getProfile { [weak self] profile in
                self?.addPostViewModel = SocialMediaAddPostCollectionViewCellViewModel(imageUrl: profile?.logoUrl ?? "", delegate: self)
                self?.delegate?.reloadCollectionViewData()
            } completionError: { _ in
            }
        }
        
        let refresh = refresh ?? false
        let skip = refresh ? 0 : self.skip
        self.feedType = feedType
        
        var models = [SocialFeedCollectionViewCellViewModel]()
        
        switch feedType {
        case .live:
            SocialDataProvider.getFeed(userId: feedUserId, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: hashTags, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: showOnlyUsersPosts, skip: skip, take: take) { [weak self] (postsViewModel) in
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
            SocialDataProvider.getFeed(userId: feedUserId, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: hashTags, mask: nil, showTop: true, showLiked: nil, showOnlyUsersPosts: showOnlyUsersPosts, skip: skip, take: take) { [weak self] (postsViewModel) in
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
            var userMode: UserFeedMode?
            userMode = feedUserId == nil ? .friendsPosts : .profilePosts
            SocialDataProvider.getFeed(userId: feedUserId, tagContentId: nil, tagContentIds: nil, userMode: userMode, hashTags: hashTags, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: showOnlyUsersPosts, skip: skip, take: take) { [weak self] (postsViewModel) in
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
    func fetchCanWritePost(canWritePostComplition : @escaping (Bool)->() ) {
        guard let managerId = self.feedUserId else { return }
        
        UsersDataProvider.get(with: managerId.uuidString, completion: { (viewModel) in
            guard let viewModel = viewModel else { return }
            guard let canWritePost = viewModel.personalDetails?.canWritePost else { return }
            canWritePostComplition(canWritePost)
        }, errorCompletion: { error in
        })
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
    
    func imagePressed(postId: UUID, index: Int, image: ImagesGalleryCollectionViewCellViewModel) {
        guard let postViewModel = viewModels.first(where: { return ($0 as? SocialFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialFeedCollectionViewCellViewModel else {
            return
        }
        
        if let postImages = postViewModel.post.images, !postImages.isEmpty {
            var imagesUrls = [String]()
            
            for postImage in postImages {
                if let resizes = postImage.resizes,
                   resizes.count > 1 {
                    let original = resizes.filter({ $0.quality == .original })
                    let hight = resizes.filter({ $0.quality == .high })
                    let medium = resizes.filter({ $0.quality == .medium })
                    let low = resizes.filter({ $0.quality == .low })
                    
                    if let logoUrl = original.first?.logoUrl {
                        imagesUrls.append(logoUrl)
                        continue
                    } else if let logoUrl = hight.first?.logoUrl {
                        imagesUrls.append(logoUrl)
                        continue
                    } else if let logoUrl = medium.first?.logoUrl {
                        imagesUrls.append(logoUrl)
                        continue
                    } else if let logoUrl = low.first?.logoUrl {
                        imagesUrls.append(logoUrl)
                    }
                } else if let logoUrl = postImage.resizes?.first?.logoUrl {
                    imagesUrls.append(logoUrl)
                }
            }
            
            let index = Int(imagesUrls.firstIndex(of: image.imageUrl) ?? 0)
    
            delegate?.imagePressed(index: index, imagesUrls: imagesUrls.compactMap({ return URL(string: $0) }))
        }
    }
    
    func undoDeletion(postId: UUID) {
    }
    
    func postActionsPressed(postId: UUID, postActions: [SocialPostAction]?, postLink: String?) {
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
        guard let postViewModel = viewModels.first(where: { return ($0 as? SocialFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialFeedCollectionViewCellViewModel else { return }
        delegate?.commentPost(post: postViewModel.post)
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
    
    func imagePressed(imageUrl: URL) {
    }
    
    func touchExpandButton(postId: UUID) {
        expandedPostIds.append(postId)
        delegate?.touchExpandButton()
    }
    
    func isExpandedPost(postId: UUID) -> Bool {
        return expandedPostIds.contains(postId)
    }
    
    func openPost(postId: UUID) {
        guard let postViewModel = viewModels.first(where: { return ($0 as? SocialFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialFeedCollectionViewCellViewModel else { return }
        delegate?.openPost(post: postViewModel.post)
    }
    
}


extension SocialFeedCollectionViewModel: SocialMediaAddPostCollectionViewCellDelegate {
    func shareIdeasButtonPressed() {
        delegate?.shareIdeasPressed()
    }
}

extension SocialFeedCollectionViewModel: SocialFeedDeletedPostCollectionViewCellDelegate {
    func undoButtonPressed(postId: UUID) {
        deletedPostViewModels.removeAll(where: { $0.post._id == postId })
        delegate?.reloadCollectionViewData()
    }
}
