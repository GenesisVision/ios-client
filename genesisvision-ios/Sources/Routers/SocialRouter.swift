//
//  SocialRouter.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 05.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit


enum SocialRouteType {
    case socialFeed
    case addPost
    case sharePost(post: Post)
    case users
    case mediaPosts
}


class SocialRouter: Router {
    
    var socialMediaViewController: SocialMediaViewController?
    
    func show(routeType: SocialRouteType) {
        switch routeType {
        case .socialFeed:
            showSocialFeed()
        case .addPost:
            showAddPost()
        case .sharePost(let post):
            showSharePost(sharedPost: post)
        case .users:
            showUsersList()
        case .mediaPosts:
            showMediaList()
        }
    }
    
    private func showSocialFeed() {
        let viewController = SocialMainFeedViewController()
        viewController.viewModel = SocialMainFeedViewModel(withRouter: self)
        viewController.viewModel.title = "Social"
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showAddPost() {
        guard let viewController = NewPostViewController.storyboardInstance(.social) else { return }
        viewController.viewModel = NewPostViewModel(sharedPost: nil)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showSharePost(sharedPost: Post) {
        guard let viewController = NewPostViewController.storyboardInstance(.social) else { return }
        viewController.viewModel = NewPostViewModel(sharedPost: sharedPost)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showUsersList() {
        let viewController = SocialUsersListViewController()
        viewController.viewModel = SocialUsersListViewModel(delegate: viewController)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showMediaList() {
        let viewController = SocialMediaListViewController()
        viewController.viewModel = SocialMediaListViewModel(delegate: viewController)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
