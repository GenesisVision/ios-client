//
//  SocialFeedViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 27.09.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import Foundation
import UIKit


class SocialFeedViewController: BaseViewController {
    
    var viewModel: SocialFeedViewModel!
    
    private var socialFeedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Social"
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetch { [weak self] (result) in
            self?.hideAll()
            self?.reloadData()
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(socialFeedCollectionView)
        
        socialFeedCollectionView.fillSuperview(padding: UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0))
        
        socialFeedCollectionView.dataSource = viewModel.socialCollectionViewDataSource
        socialFeedCollectionView.delegate = viewModel.socialCollectionViewDataSource
        
        if let layout = socialFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        socialFeedCollectionView.isScrollEnabled = true
        socialFeedCollectionView.showsHorizontalScrollIndicator = false
        socialFeedCollectionView.indicatorStyle = .black
        socialFeedCollectionView.allowsSelection = false
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
    
    private func showAssetViewController(assetDetails: PostAssetDetailsWithPrices) {
        guard let assetId = assetDetails._id?.uuidString, let assetType = assetDetails.assetType else { return }
        viewModel.socialRouter.showAssetDetails(with: assetId, assetType: assetType)
    }
    
    private func showUserProfileViewController(userDetails: ProfilePublic) {
        guard let userId = userDetails._id?.uuidString else { return }
        viewModel.socialRouter.showUserDetails(with: userId)
    }
}

extension SocialFeedViewController: SocialFeedCollectionViewModelDelegate {
    
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
        default:
            break
        }
    }
}
