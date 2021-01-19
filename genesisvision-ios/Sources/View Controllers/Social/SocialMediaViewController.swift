//
//  SocialMediaViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 01.12.2020.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit


class SocialMediaViewController: BaseViewController {
    
    var viewModel: SocialMediaViewModel!
    
    private var mediaFeedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.Cell.headerBg
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        viewModel.fetch { [weak self] (result) in
            switch result {
            case .success:
                self?.reloadData()
            case .failure(errorType: _):
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupCollectionView() {
        view.addSubview(mediaFeedCollectionView)
        
        mediaFeedCollectionView.fillSuperview(padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        
        mediaFeedCollectionView.dataSource = viewModel.socialMediaCollectionViewDataSource
        mediaFeedCollectionView.delegate = viewModel.socialMediaCollectionViewDataSource
        
        if let layout = mediaFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        mediaFeedCollectionView.isScrollEnabled = true
        mediaFeedCollectionView.showsVerticalScrollIndicator = false
        mediaFeedCollectionView.allowsSelection = false
        mediaFeedCollectionView.registerNibs(for: viewModel.socialMediaCollectionViewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: mediaFeedCollectionView)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.mediaFeedCollectionView.reloadData()
        }
    }
    
    private func showNewPostViewController(sharedPost: Post?) {
        guard let sharedPost = sharedPost else {
            viewModel.router.show(routeType: .addPost)
            return
        }
        
        viewModel.router.show(routeType: .sharePost(post: sharedPost))
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            switch result {
            case .success:
                self?.reloadData()
            case .failure(errorType: _):
                break
            }
        }
    }
}

extension SocialMediaViewController: SocialMediaCollectionViewModelDelegate {
    func openSocialFeed(type: SocialMediaFeedCollectionCellType) {
        viewModel.router.show(routeType: .socialFeed)
    }
    
    func commentPressed(postId: UUID) {
    }
    
    func sharePressed(postId: UUID) {
        
        var sharedPost: Post?
        
        SocialDataProvider.getPost(postId: postId) { [weak self] (postModel) in
            sharedPost = postModel
            self?.showNewPostViewController(sharedPost: sharedPost)
        } errorCompletion: { (result) in
            switch result {
            case .success:
                break
            case .failure(errorType: let errorType):
                ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
            }
        }
    }
    
    func likePressed(postId: UUID) {
        SocialDataProvider.getPost(postId: postId) { (post) in
            if let isLiked = post?.personalDetails?.isLiked {
                isLiked ? SocialDataProvider.unlikePost(postId: postId) { _ in } : SocialDataProvider.likePost(postId: postId) { _ in }
            }
        } errorCompletion: { _ in }
    }
    
    func shareIdeasPressed() {
        showNewPostViewController(sharedPost: nil)
    }
    
    func moreMediaPressed() {
        viewModel.router.show(routeType: .mediaPosts)
    }
    
    func mediaPostPressed(post: MediaPost) {
        guard let url = post.url else { return }
        openSafariVC(with: url)
    }
    
    func userPressed(user: UserDetailsList) {
    }
    
    func usersMoreButtonPressed() {
        viewModel.router.show(routeType: .users)
    }
}

protocol SocialMediaCollectionViewModelDelegate: class {
    func openSocialFeed(type: SocialMediaFeedCollectionCellType)
    func commentPressed(postId: UUID)
    func sharePressed(postId: UUID)
    func likePressed(postId: UUID)
    
    func shareIdeasPressed()
    
    func mediaPostPressed(post: MediaPost)
    func moreMediaPressed()
    
    func userPressed(user: UserDetailsList)
    func usersMoreButtonPressed()
}

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
        SocialDataProvider.getFeed(userId: nil, tagContentId: nil, tagContentIds: nil, userMode: nil, hashTags: nil, mask: nil, showTop: nil, showLiked: nil, showOnlyUsersPosts: nil, skip: 0, take: 1) { [weak self] (postsViewModel) in
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
            return CGSize(width: frame.width, height: 300)
        case .media:
            return CGSize(width: frame.width, height: 300)
        case .users:
            return CGSize(width: frame.width, height: 150)
        case .live:
            return CGSize(width: frame.width, height: 300)
        case .hot:
            return CGSize(width: frame.width, height: 300)
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
    func openSocialFeed(type: SocialMediaFeedCollectionCellType) {
        delegate?.openSocialFeed(type: type)
    }
    
    func commentPressed(postId: UUID) {
        delegate?.commentPressed(postId: postId)
    }
    
    func sharePressed(postId: UUID) {
        delegate?.sharePressed(postId: postId)
    }
    
    func likePressed(postId: UUID) {
        delegate?.likePressed(postId: postId)
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
