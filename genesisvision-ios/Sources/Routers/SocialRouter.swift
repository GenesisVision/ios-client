//
//  SocialRouter.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 05.01.2021.
//  Copyright © 2021 Genesis Vision. All rights reserved.
//

import UIKit


enum SocialRouteType {
    case socialFeed(tabType: SocialMainFeedTabType)
    case addPost
    case sharePost(post: Post?)
    case openPost(post: Post)
    case users
    case mediaPosts
    case reportPost(postId: UUID)
}


class SocialRouter: Router {
    
    var socialMediaViewController: SocialMediaViewController?
    
    func show(routeType: SocialRouteType) {
        switch routeType {
        case .socialFeed(let tabType):
            showSocialFeed(tabType: tabType)
        case .addPost:
            showAddPost()
        case .sharePost(let post):
            showSharePost(sharedPost: post)
        case .users:
            showUsersList()
        case .mediaPosts:
            showMediaList()
        case .openPost(let post):
            showPost(post: post)
        case .reportPost(let postId):
            showPostReport(postId: postId)
        }
    }
    
    private func showSocialFeed(tabType: SocialMainFeedTabType) {
        let viewController = SocialMainFeedViewController()
        viewController.viewModel = SocialMainFeedViewModel(withRouter: self, openedTab: tabType)
        viewController.viewModel.title = "Social"
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showAddPost() {
        guard let viewController = SocialNewPostViewController.storyboardInstance(.social) else { return }
        viewController.viewModel = SocialNewPostViewModel(sharedPost: nil)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showSharePost(sharedPost: Post?) {
        guard let viewController = SocialNewPostViewController.storyboardInstance(.social) else { return }
        viewController.viewModel = SocialNewPostViewModel(sharedPost: sharedPost)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showUsersList() {
        let viewController = SocialUsersListViewController()
        viewController.viewModel = SocialUsersListViewModel(with: self, delegate: viewController)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showMediaList() {
        let viewController = SocialMediaListViewController()
        viewController.viewModel = SocialMediaListViewModel(delegate: viewController)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showPost(post: Post) {
        let viewController = SocialPostViewController()
        viewController.viewModel = SocialPostViewModel(postId: nil, post: post)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showPostReport(postId: UUID) {
        let viewController = SocialPostReportViewController()
        viewController.viewModel = SocialPostReportViewModel(postId: postId)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
