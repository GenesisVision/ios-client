//
//  SocialFeedViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 27.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Feed ViewControler
class SocialFeedViewController: BaseViewController {
    
    var viewModel: SocialFeedViewModel!
    
    private let showEventsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private var socialFeedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionView()
        setupShowEventsView()
    }
    
    private func setup() {
        title = "Social"
        NotificationCenter.default.addObserver(self, selector: #selector(updateShowEventsValue), name: .socialShowEventsSwitchValueChanged, object: nil)
    }
    
    @objc private func updateShowEventsValue(notification: Notification) {
        guard let value = notification.userInfo?["showEvents"] as? Bool else { return }
        
        viewModel.showOnlyUsersPosts = !value
        
        viewModel.fetch(completion: { [weak self] (result) in
            self?.hideAll()
            self?.reloadData()
        }, refresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            self?.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.socialCollectionViewModel.deletePosts()
    }
    
    private func setupShowEventsView() {
        let label = TitleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Show events"
        let switchButton = UISwitch()
        switchButton.isEnabled = true
        switchButton.isOn = UserDefaults.standard.bool(forKey: UserDefaultKeys.socialShowEvents)
        switchButton.onTintColor = UIColor.primary
        switchButton.thumbTintColor = UIColor.Cell.switchThumbTint
        switchButton.tintColor = UIColor.Cell.switchTint
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.addTarget(self, action: #selector(showEventsSwitch), for: .valueChanged)
        
        showEventsView.addSubview(label)
        showEventsView.addSubview(switchButton)
        
        
        label.anchorCenter(centerY: switchButton.centerYAnchor, centerX: nil)
        label.anchor(top: nil, leading: nil, bottom: nil, trailing: switchButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: 90, height: 0))
        
        switchButton.anchorCenter(centerY: showEventsView.centerYAnchor, centerX: nil)
        switchButton.anchor(top: nil, leading: nil, bottom: nil, trailing: showEventsView.trailingAnchor, size: CGSize(width: 60, height: 0))
    }
    
    @objc private func showEventsSwitch(switchButton: UISwitch) {
        let value = switchButton.isOn
        viewModel.showOnlyUsersPosts = !value
        
        viewModel.fetch(completion: { [weak self] (result) in
            self?.hideAll()
            self?.reloadData()
        }, refresh: true)
    }
    
    private func setupCollectionView() {
        view.addSubview(socialFeedCollectionView)
        view.addSubview(showEventsView)
        
        if viewModel.showEventsButton {
            showEventsView.anchor(top: view.topAnchor,
                                  leading: nil,
                                  bottom: nil,
                                  trailing: view.trailingAnchor,
                                  padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 10), size: CGSize(width: 150, height: 45))
            socialFeedCollectionView.anchor(top: showEventsView.bottomAnchor,
                                            leading: view.leadingAnchor,
                                            bottom: view.bottomAnchor,
                                            trailing: view.trailingAnchor,
                                            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            showEventsView.isHidden = false
        } else {
            socialFeedCollectionView.fillSuperview(padding: UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0))
        }
        

        
        socialFeedCollectionView.dataSource = viewModel.socialCollectionViewDataSource
        socialFeedCollectionView.delegate = viewModel.socialCollectionViewDataSource
        
        if let layout = socialFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        socialFeedCollectionView.isScrollEnabled = true
        socialFeedCollectionView.showsVerticalScrollIndicator = false
        socialFeedCollectionView.allowsSelection = true
        socialFeedCollectionView.registerNibs(for: viewModel.socialCollectionViewModel.cellModelsForRegistration)
        
        setupPullToRefresh(scrollView: socialFeedCollectionView)
    }
    
    override func pullToRefresh() {
        super.pullToRefresh()
        
        viewModel.fetch(completion: { [weak self] (result) in
            self?.hideAll()
            self?.reloadData()
        }, refresh: true)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.socialFeedCollectionView.reloadData()
        }
    }
    
    private func showNewPostViewController(sharedPost: Post?) {
        viewModel.socialRouter.show(routeType:  .sharePost(post: sharedPost))
    }
    
    private func showImagesViewController(index: Int, imagesUrls: [URL]) {
        viewModel.socialRouter.show(routeType: .showImages(index: index, imagesUrls: imagesUrls, images: []))
    }
    
    private func showAssetViewController(assetDetails: PostAssetDetailsWithPrices) {
        guard let assetId = assetDetails._id?.uuidString, let assetType = assetDetails.assetType else { return }
        viewModel.socialRouter.showAssetDetails(with: assetId, assetType: assetType)
    }
    
    private func showUserProfileViewController(userDetails: ProfilePublic) {
        guard let userId = userDetails._id?.uuidString else { return }
        viewModel.socialRouter.showUserDetails(with: userId)
    }
    
    private func showPost(post: Post) {
        viewModel.socialRouter.show(routeType: .openPost(post: post))
    }
}

extension SocialFeedViewController: SocialPostActionsMenuPresenable {
    func actionSelected(action: SocialPostAction) {
        switch action {
        case .edit(let postId):
            viewModel.socialRouter.show(routeType: .editPost(postId: postId))
        case .share(let postLink):
            viewModel.socialRouter.share(postLink)
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
            viewModel.socialRouter.show(routeType: .reportPost(postId: postId))
        case .pin(let postId):
            viewModel.pinPost(postId: postId) { [weak self] (result) in
                switch result {
                case .success:
                    self?.pullToRefresh()
                case .failure(errorType: let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        case .unpin(let postId):
            viewModel.pinPost(postId: postId) { [weak self] (result) in
                switch result {
                case .success:
                    self?.pullToRefresh()
                case .failure(errorType: let errorType):
                    ErrorHandler.handleError(with: errorType, viewController: self, hud: true)
                }
            }
        }
    }
}

extension SocialFeedViewController: SocialFeedCollectionViewModelDelegate {
    func imagePressed(index: Int, imagesUrls: [URL]) {
        showImagesViewController(index: index, imagesUrls: imagesUrls)
    }
    
    func shareIdeasPressed() {
        showNewPostViewController(sharedPost: nil)
    }
    
    func reloadCells(cells: [IndexPath]) {
        socialFeedCollectionView.reloadItems(at: cells)
    }
    
    func showPostActions(postActions: [SocialPostAction], postId: UUID, postLink: String) {
        showPostMenu(actions: postActions, postId: postId, postLink: postLink)
    }
    
    func openPost(post: Post) {
        showPost(post: post)
    }
    
    func reloadCollectionViewData() {
        reloadData()
    }
    
    func userOwnerPressed(userDetails: ProfilePublic) {
        showUserProfileViewController(userDetails: userDetails)
    }
    
    func commentPost(postId: UUID) {
    }
    
    func sharePost(postId: UUID) {
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
    
    func touchExpandButton() {
        reloadData()
    }
}
