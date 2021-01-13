//
//  MainSocialPageViewController.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 23.08.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class SocialMainFeedViewController: BaseTabmanViewController<SocialMainFeedViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        dataSource = viewModel.dataSource
    }
    
}



final class SocialMainFeedViewModel: TabmanViewModel {
    
    enum TabType: String {
        case live = "LIVE"
        case hot = "HOT"
        case feed = "FEED"
    }
    
    var tabTypes: [TabType] = [.live, .hot, .feed]
    
    var controllers = [TabType : UIViewController]()
    
    func getViewController(_ type: TabType) -> UIViewController? {
        if let saved = controllers[type] { return saved }
        
        switch type {
        case .live:
            let viewController = SocialFeedViewController()
            let viewModel = SocialFeedViewModel(feedType: .live, collectionViewDelegate: viewController)
            viewController.viewModel = viewModel
            return viewController
        case .hot:
            let viewController = SocialFeedViewController()
            let viewModel = SocialFeedViewModel(feedType: .hot, collectionViewDelegate: viewController)
            viewController.viewModel = viewModel
            return viewController
        case .feed:
            let viewController = SocialFeedViewController()
            let viewModel = SocialFeedViewModel(feedType: .feed, collectionViewDelegate: viewController)
            viewController.viewModel = viewModel
            return viewController
        }
    }
    
    init(withRouter router: Router) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        self.title = ""
        font = UIFont.getFont(.semibold, size: 16)
        self.dataSource = PageboyDataSource(self)
    }
}

extension SocialMainFeedViewModel: TabmanDataSourceProtocol {
    func getCount() -> Int {
        return tabTypes.count
    }
    
    func getItem(_ index: Int) -> TMBarItem? {
        let type = tabTypes[index]
        return TMBarItem(title: type.rawValue)
    }
    
    func getViewController(_ index: Int) -> UIViewController? {
        if let tabType = tabTypes[safe: index] {
            return getViewController(tabType)
        } else {
            return nil
        }
    }
}
