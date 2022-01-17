//
//  SocialMediaCollectionViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 20.02.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit

protocol SocialMediaCollectionViewModelDelegate: AnyObject {
    func openSocialFeed(type: SocialMediaFeedCollectionCellType)
    func commentPressed(postId: UUID)
    func sharePressed(post: Post)
    func likePressed(postId: UUID)
    func tagPressed(tag: PostTag)
    func userOwnerPressed(userDetails: ProfilePublic)
    func showPostActions(postActions: [SocialPostAction], postId: UUID, postLink: String)
    func imagePressed(index: Int, imagesUrls: [URL])
    
    func shareIdeasPressed()
    
    func mediaPostPressed(post: MediaPost)
    func moreMediaPressed()
    
    func userPressed(user: UserDetailsList)
    func usersMoreButtonPressed()
    func touchExpandButton()
    func openPost(post: Post)
}

final class SocialMediaCollectionViewModel: CellViewModelWithCollection {
    var type: CellActionType

    var canPullToRefresh: Bool = true
    
    var title: String
    
    enum SectionType {
        case addPost
        case live
        case hot
        case feed
        case media
        case users
    }
    
    var sections: [SectionType] = [.addPost, .live, .hot, .feed, .media, .users]
    
    var viewModels = [CellViewAnyModel]()
    var feedViewModel = [CellViewAnyModel]()
    var mediaViewModel = [CellViewAnyModel]()
    var usersViewModel = [CellViewAnyModel]()
    
    lazy var expandedPostIds = [UUID]()
    
    let collectionTopInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionBottomInset: CGFloat = Constants.SystemSizes.Cell.horizontalMarginValue
    let collectionLeftInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionRightInset: CGFloat = Constants.SystemSizes.Cell.verticalMarginValue
    let collectionLineSpacing: CGFloat = Constants.SystemSizes.Cell.lineSpacing
    let collectionInteritemSpacing: CGFloat = Constants.SystemSizes.Cell.interitemSpacing
    
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [SocialMediaAddPostCollectionViewCellViewModel.self,
                SocialMediaFeedCollectionViewCellViewModel.self,
                SocialMediaCollectionViewCellViewModel.self,
                SocialMediaUsersCollectionViewCellViewModel.self]
    }
    
    weak var delegate: SocialMediaCollectionViewModelDelegate?
    
    init(type: CellActionType, title: String, delegate: SocialMediaCollectionViewModelDelegate) {
        self.type = type
        self.title = title
        self.delegate = delegate
    }
    
    func postActionsForPost(postId: UUID) -> [SocialPostAction] {
        var postActions: [SocialPostAction] = []
        
        guard let postViewModel = feedViewModel.first(where: {
            guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.post._id == postId else { return false }
            return true
        }) as? SocialMediaFeedCollectionViewCellViewModel, let postId = postViewModel.post._id else { return postActions }
        
        postActions.append(.report(postId: postId))
        
        if let canDelete = postViewModel.post.personalDetails?.canDelete, canDelete {
            postActions.append(.delete(postId: postId))
        }
        
        if let canEdit = postViewModel.post.personalDetails?.canEdit, canEdit {
            postActions.append(.edit(postId: postId))
        }
        
        guard let url = postViewModel.post.url else { return postActions }
        
        postActions.append(contentsOf: [.copyLink(postLink: url), .share(postLink: url)])
        
        return postActions
    }
    
    func fetch(completion: @escaping CompletionBlock) {
        
        AuthManager.getProfile { [weak self] (viewModel) in
            var imageUrl = ""
            if let url = viewModel?.logoUrl {
                imageUrl = url
            }
            let firstCellViewModel = SocialMediaAddPostCollectionViewCellViewModel(imageUrl: imageUrl, delegate: self)
            self?.viewModels.removeAll(where: { $0 is SocialMediaAddPostCollectionViewCellViewModel })
            self?.viewModels.insert(firstCellViewModel, at: 0)
            
            self?.fetchSocialFeeds(completion: completion)
        } completionError: { [weak self] _ in
            self?.fetchSocialFeeds(completion: completion)
        }
    }
    
    
    func fetchSocialFeeds(completion: @escaping CompletionBlock) {
        
        //live
        SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: true, skip: 0, take: 1) { [weak self] (postsViewModel) in
            if let post = postsViewModel?.items?.first {
                let viewModel = SocialMediaFeedCollectionViewCellViewModel(type: .live, post: post, cellDelegate: self)
                
                self?.feedViewModel.removeAll(where: { guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel else { return false }
                    return model.type == .live
                })
                self?.feedViewModel.append(viewModel)
            }
        } errorCompletion: { _ in
            completion(.failure(errorType: .apiError(message: "")))
        }
        
        //hot
        SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: true, showLiked: nil, showOnlyUsersPosts: nil, skip: 0, take: 1) { [weak self] (postsViewModel) in
            if let post = postsViewModel?.items?.first {
                let viewModel = SocialMediaFeedCollectionViewCellViewModel(type: .hot, post: post, cellDelegate: self)
                
                self?.feedViewModel.removeAll(where: { guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel else { return false }
                    return model.type == .hot
                })
                self?.feedViewModel.append(viewModel)
            }
        } errorCompletion: { _ in
            completion(.failure(errorType: .apiError(message: "")))
        }
        
        //feed
        SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: .friendsPosts, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: nil, skip: 0, take: 1) { [weak self] (postsViewModel) in
            if let post = postsViewModel?.items?.first {
                let viewModel = SocialMediaFeedCollectionViewCellViewModel(type: .feed, post: post, cellDelegate: self)
                
                self?.feedViewModel.removeAll(where: { guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel else { return false }
                    return model.type == .feed
                })
                self?.feedViewModel.append(viewModel)
            }
            completion(.success)
            self?.fetchMedia(completion: completion)
        } errorCompletion: { _ in
            completion(.failure(errorType: .apiError(message: "")))
        }
        
    }
    
    func fetchMedia(completion: @escaping CompletionBlock) {
        SocialDataProvider.getMedia { [weak self] (viewModel) in
            if let posts = viewModel?.items {
                let viewModel = SocialMediaCollectionViewCellViewModel(items: posts, cellDelegate: self)
                self?.mediaViewModel = []
                self?.mediaViewModel.append(viewModel)
            }
            completion(.success)
            self?.fetchUsers(completion: completion)
        } errorCompletion: { _ in
            completion(.failure(errorType: .apiError(message: "")))
        }

    }
    
    func fetchUsers(completion: @escaping CompletionBlock) {
        UsersDataProvider.getList(sorting: .byActivityDesc, tags: nil, skip: 0, take: 10) { [weak self] (viewModel) in
            if let users = viewModel?.items {
                let viewModel = SocialMediaUsersCollectionViewCellViewModel(items: users, cellDelegate: self)
                self?.usersViewModel = []
                self?.usersViewModel.append(viewModel)
            }
            completion(.success)
        } errorCompletion: { _ in
            completion(.failure(errorType: .apiError(message: "")))
        }
    }
    
    func deletePost(postId: UUID, completion: @escaping CompletionBlock) {
        SocialDataProvider.deletePost(postId: postId, completion: completion)
    }
    
    func model(for indexPath: IndexPath) -> CellViewAnyModel? {
        let type = sections[indexPath.section]
        
        switch type {
        case .addPost:
            return viewModels.first{ $0 is SocialMediaAddPostCollectionViewCellViewModel }
        case .feed:
            return feedViewModel.first(where: { guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.type == .feed else { return false }
                return true
            })
        case .media:
            return mediaViewModel.first
        case .users:
            return usersViewModel.first
        case .live:
            return feedViewModel.first(where: { guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.type == .live else { return false }
                return true
            })
        case .hot:
            return feedViewModel.first(where: { guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.type == .hot else { return false }
                return true
            })
        }
    }
    
    func sizeForItem(at indexPath: IndexPath, frame: CGRect) -> CGSize {
        let type = sections[indexPath.section]
        
        switch type {
        case .addPost:
            return CGSize(width: frame.width, height: 50)
        case .feed:
            let spacing: CGFloat = 0
            if let viewModel = feedViewModel.first(where: { guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.type == .feed else { return false }
                return true
            }) as? SocialMediaFeedCollectionViewCellViewModel {
                return viewModel.cellSize(spacing: spacing, frame: frame)
            } else {
                let size: CGFloat = (frame.width - spacing)
                return CGSize(width: size, height: 300)
            }
        case .media:
            return CGSize(width: frame.width, height: 300)
        case .users:
            return CGSize(width: frame.width, height: 150)
        case .live:
            let spacing: CGFloat = 0
            if let viewModel = feedViewModel.first(where: { guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.type == .live else { return false }
                return true
            }) as? SocialMediaFeedCollectionViewCellViewModel {
                return viewModel.cellSize(spacing: spacing, frame: frame)
            } else {
                let size: CGFloat = (frame.width - spacing)
                return CGSize(width: size, height: 300)
            }
        case .hot:
            let spacing: CGFloat = 0
            if let viewModel = feedViewModel.first(where: { guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.type == .hot else { return false }
                return true
            }) as? SocialMediaFeedCollectionViewCellViewModel {
                return viewModel.cellSize(spacing: spacing, frame: frame)
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
        return collectionLineSpacing*2
    }
    
    func minimumInteritemSpacing(for section: Int) -> CGFloat {
        return collectionInteritemSpacing
    }
    
    func numberOfRows(in section: Int) -> Int {
        let type = sections[section]
        
        switch type {
        case .addPost:
            return viewModels.count
        case .feed:
            guard let _ = feedViewModel.first(where: {
                guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.type == .feed else { return false }
                return true
            }) as? SocialMediaFeedCollectionViewCellViewModel else {
                return 0
            }
            return 1
        case .media:
            return mediaViewModel.count
        case .users:
            return usersViewModel.count
        case .live:
            guard let _ = feedViewModel.first(where: {
                guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.type == .live else { return false }
                return true
            }) as? SocialMediaFeedCollectionViewCellViewModel else {
                return 0
            }
            return 1
        case .hot:
            guard let _ = feedViewModel.first(where: {
                guard let model = $0 as? SocialMediaFeedCollectionViewCellViewModel, model.type == .hot else { return false }
                return true
            }) as? SocialMediaFeedCollectionViewCellViewModel else {
                return 0
            }
            return 1
        }
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
}

extension SocialMediaCollectionViewModel: SocialMediaAddPostCollectionViewCellDelegate {
    func shareIdeasButtonPressed() {
        delegate?.shareIdeasPressed()
    }
}

extension SocialMediaCollectionViewModel: SocialMediaFeedCollectionViewCellDelegate {
    
    func imagePressed(postId: UUID, index: Int, image: ImagesGalleryCollectionViewCellViewModel) {
        guard let postViewModel = viewModels.first(where: { return ($0 as? SocialFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialFeedCollectionViewCellViewModel else {
            return
        }
        
        if let postImages = postViewModel.post.images, !postImages.isEmpty {
            var imagesUrls: [String: PostImageResize?] = [:]
            
            for postImage in postImages {
                if let resizes = postImage.resizes,
                   resizes.count > 1 {
                    let original = resizes.filter({ $0.quality == .original })
                    let hight = resizes.filter({ $0.quality == .high })
                    let medium = resizes.filter({ $0.quality == .medium })
                    let low = resizes.filter({ $0.quality == .low })
                    
                    if let logoUrl = original.first?.logoUrl {
                        imagesUrls[logoUrl] = original.first
                        continue
                    } else if let logoUrl = hight.first?.logoUrl {
                        imagesUrls[logoUrl] = hight.first
                        continue
                    } else if let logoUrl = medium.first?.logoUrl {
                        imagesUrls[logoUrl] = medium.first
                        continue
                    } else if let logoUrl = low.first?.logoUrl {
                        imagesUrls[logoUrl] = low.first
                    }
                } else if let logoUrl = postImage.resizes?.first?.logoUrl {
                    imagesUrls[logoUrl] = postImage.resizes?.first
                }
            }
            
            let onlyImagesUrls = imagesUrls.map({ $0.key })
            let index = Int(onlyImagesUrls.firstIndex(of: image.imageUrl) ?? 0)
            delegate?.imagePressed(index: index, imagesUrls: onlyImagesUrls.compactMap({ return URL(string: $0) }))
        }
    }
    
    func postActionsPressed(postId: UUID) {
        let postActions = postActionsForPost(postId: postId)
        var postLink: String = ""

        if let postViewModel = feedViewModel.first(where: { return ($0 as? SocialMediaFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialMediaFeedCollectionViewCellViewModel, let url = postViewModel.post.url {
            postLink = ApiKeys.socialPostsPath + url }
        delegate?.showPostActions(postActions: postActions, postId: postId, postLink: postLink)
    }
    
    func userOwnerPressed(postId: UUID) {
        guard let postViewModel = feedViewModel.first(where: { return ($0 as? SocialMediaFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialMediaFeedCollectionViewCellViewModel,
        let userDetails = postViewModel.post.author else { return }
        delegate?.userOwnerPressed(userDetails: userDetails)
    }
    
    func tagPressed(tag: PostTag) {
        delegate?.tagPressed(tag: tag)
    }
    
    func openSocialFeed(type: SocialMediaFeedCollectionCellType) {
        delegate?.openSocialFeed(type: type)
    }
    
    func commentPressed(postId: UUID) {
        delegate?.commentPressed(postId: postId)
    }
    
    func sharePressed(postId: UUID) {
        guard let postViewModel = feedViewModel.first(where: { return ($0 as? SocialMediaFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialMediaFeedCollectionViewCellViewModel else { return }
        delegate?.sharePressed(post: postViewModel.post)
    }
    
    func likePressed(postId: UUID) {
        delegate?.likePressed(postId: postId)
    }
    func touchExpandButton(postId: UUID) {
        expandedPostIds.append(postId)
        delegate?.touchExpandButton()
    }
    func isExpandedPost(postId: UUID) -> Bool {
        return expandedPostIds.contains(postId)
    }
    func openPost(postId: UUID) {
        guard let postViewModel = feedViewModel.first(where: { return ($0 as? SocialMediaFeedCollectionViewCellViewModel)?.post._id == postId }) as? SocialMediaFeedCollectionViewCellViewModel else { return }
        delegate?.openPost(post: postViewModel.post)
    }
}

extension SocialMediaCollectionViewModel: SocialMediaCollectionViewCellDelegate {
    func mediaPostSelected(post: MediaPost) {
        delegate?.mediaPostPressed(post: post)
    }
    
    func moreMediaPressed() {
        delegate?.moreMediaPressed()
    }
}

extension SocialMediaCollectionViewModel: SocialMediaUsersCollectionViewCellDelegate {
    func userPressed(user: UserDetailsList) {
        delegate?.userPressed(user: user)
    }
    
    func usersMoreButtonPressed() {
        delegate?.usersMoreButtonPressed()
    }
}
