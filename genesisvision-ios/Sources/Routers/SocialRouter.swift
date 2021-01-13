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
        }
    }
    
    private func showSocialFeed() {
        let viewController = SocialMainFeedViewController()
        viewController.viewModel = SocialMainFeedViewModel(withRouter: self)
        viewController.viewModel.title = "Social"
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showAddPost() {
        guard let viewController = NewPostViewController.storyboardInstance(.social) else { return }
        
        let viewModel = NewPostViewModel(sharedPost: nil)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    private func showSharePost(sharedPost: Post) {
        guard let viewController = NewPostViewController.storyboardInstance(.social) else { return }
        
        let viewModel = NewPostViewModel(sharedPost: sharedPost)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}
