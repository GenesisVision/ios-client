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
    
    private func showAssetViewController(assetDetails: PostAssetDetailsWithPrices) {
        guard let assetId = assetDetails._id?.uuidString, let assetType = assetDetails.assetType else { return }
        viewModel.router.showAssetDetails(with: assetId, assetType: assetType)
    }
    
    private func showImagesViewController(index: Int, imagesUrls: [URL]) {
        viewModel.router.show(routeType: .showImages(index: index, imagesUrls: imagesUrls, images: []))
    }
    
    private func showUserProfileViewController(userDetails: ProfilePublic) {
        guard let userId = userDetails._id?.uuidString else { return }
        viewModel.router.showUserDetails(with: userId)
    }
    
    private func showPost(post: Post) {
        viewModel.router.show(routeType: .openPost(post: post))
    }
    
}

extension SocialMediaViewController: SocialPostActionsMenuPresenable {
    func actionSelected(action: SocialPostAction) {
        switch action {
//        case .edit(postId: _):
//            break
        case .edit(let postId):
            viewModel.router.show(routeType: .editPost(postId: postId))
        case .share(let postLink):
            viewModel.router.share(postLink)
        case .copyLink(postLink: let postLink):
            UIPasteboard.general.string = postLink
            showBottomSheet(.success, title: "Your post link was copied to the clipboard successfully")
        case .delete(let postId):
            viewModel.deletePost(postId: postId) { [weak self] (result) in
                switch result {
                case .success:
                    self?.viewModel.fetch { [weak self] (result) in
                        switch result {
                        case .success:
                            self?.reloadData()
                        case .failure(errorType: _):
                            break
                        }
                    }
                case .failure(errorType: let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        case .report(let postId):
            viewModel.router.show(routeType: .reportPost(postId: postId))
        case .pin(postId: _):
            break
        case .unpin(postId: _):
            break
        }
    }
}

extension SocialMediaViewController: SocialMediaCollectionViewModelDelegate {
    
    func imagePressed(index: Int, imagesUrls: [URL]) {
        showImagesViewController(index: index, imagesUrls: imagesUrls)
    }
    
    func showPostActions(postActions: [SocialPostAction], postId: UUID, postLink: String) {
        showPostMenu(actions: postActions, postId: postId, postLink: postLink)
    }
    
    func userOwnerPressed(userDetails: ProfilePublic) {
        showUserProfileViewController(userDetails: userDetails)
    }
    
    func tagPressed(tag: PostTag) {
        guard let tagType = tag.type else { return }
        switch tagType {
        case .program:
            guard let assetDetails = tag.assetDetails else { return }
            showAssetViewController(assetDetails: assetDetails)
        case .fund:
            guard let assetDetails = tag.assetDetails else { return }
            showAssetViewController(assetDetails: assetDetails)
        case .follow:
            guard let assetDetails = tag.assetDetails else { return }
            showAssetViewController(assetDetails: assetDetails)
        case .user:
            guard let userDetails = tag.userDetails else { return }
            showUserProfileViewController(userDetails: userDetails)
        case .asset:
            break
        case .event:
            break
        case .url:
            guard let url = tag.link?.url else { return }
            openSafariVC(with: url)
        default:
            break
        }
    }
    
    func openSocialFeed(type: SocialMediaFeedCollectionCellType) {
        switch type {
        case .feed:
            viewModel.router.show(routeType: .socialFeed(tabType: .feed))
        case .hot:
            viewModel.router.show(routeType: .socialFeed(tabType: .hot))
        case .live:
            viewModel.router.show(routeType: .socialFeed(tabType: .live))
        }
    }
    
    func commentPressed(postId: UUID) {
    }
    
    func sharePressed(post: Post) {
        showNewPostViewController(sharedPost: post)
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
    
    func touchExpandButton() {
        reloadData()
    }
    
    func openPost(post: Post) {
        showPost(post: post)
    }
}
