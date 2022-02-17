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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollToPage(.at(index: viewModel.getIndexForDefaultTab()), animated: true)
    }
    
    private func setup() {
        dataSource = viewModel.dataSource
        addBarViewSubview()
    }
    
    private func addBarViewSubview() {
        let barFrame = bar.frame
        let width: CGFloat = 150
        let xSpacing: CGFloat = 10
        let ySpacing: CGFloat = 5
        let height: CGFloat = barFrame.maxY - barFrame.minY - 2*ySpacing
        
        let contentView = UIView(frame: CGRect(x: barFrame.maxX - width - xSpacing, y: barFrame.minY + ySpacing, width: width, height: height))
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
        
        contentView.addSubview(label)
        contentView.addSubview(switchButton)
        
        label.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10), size: CGSize(width: 90, height: 0))
        
        switchButton.anchor(top: contentView.topAnchor, leading: nil, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 10), size: CGSize(width: 40, height: 0))
        view.addSubview(contentView)
    }
    
    @objc private func showEventsSwitch(switchButton: UISwitch) {
        let value = switchButton.isOn
        viewModel.showEvents = value
        
        UserDefaults.standard.set(value, forKey: UserDefaultKeys.socialShowEvents)
        
        NotificationCenter.default.post(name: .socialShowEventsSwitchValueChanged, object: nil, userInfo: ["showEvents": value])
    }
    
}

enum SocialMainFeedTabType: String {
    case live = "LIVE"
    case hot = "HOT"
    case feed = "FEED"
}


final class SocialMainFeedViewModel: TabmanViewModel {
    
    var tabTypes: [SocialMainFeedTabType] = [.live, .hot, .feed]
    var hashtags: [String]!
    var controllers = [SocialMainFeedTabType : UIViewController]()
    
    var showEvents: Bool = false {
        didSet {
            controllers.forEach({ ($1 as? SocialFeedViewController)?.viewModel.showOnlyUsersPosts = !showEvents  })
        }
    }
    
    var defaultTab: SocialMainFeedTabType
    
    func getViewController(_ type: SocialMainFeedTabType) -> UIViewController? {
        if let saved = controllers[type] { return saved }
        
        guard let socialRouter = router as? SocialRouter else { return nil }
        
        switch type {
        case .live:
            let viewController = SocialFeedViewController()
            let viewModel = SocialFeedViewModel(feedType: .live, collectionViewDelegate: viewController, router: socialRouter, showEvents: showEvents)
            viewModel.socialCollectionViewModel.hashTags = hashtags
            viewController.viewModel = viewModel
            return viewController
        case .hot:
            let viewController = SocialFeedViewController()
            let viewModel = SocialFeedViewModel(feedType: .hot, collectionViewDelegate: viewController, router: socialRouter, showEvents: showEvents)
            viewModel.socialCollectionViewModel.hashTags = hashtags
            viewController.viewModel = viewModel
            return viewController
        case .feed:
            let viewController = SocialFeedViewController()
            let viewModel = SocialFeedViewModel(feedType: .feed, collectionViewDelegate: viewController, router: socialRouter, showEvents: showEvents)
            viewModel.socialCollectionViewModel.hashTags = hashtags
            viewController.viewModel = viewModel
            return viewController
        }
    }
    
    init(withRouter router: Router, openedTab: SocialMainFeedTabType) {
        self.defaultTab = openedTab
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        self.title = ""
        font = UIFont.getFont(.semibold, size: 16)
        self.dataSource = PageboyDataSource(self)
        self.showEvents = UserDefaults.standard.bool(forKey: UserDefaultKeys.socialShowEvents)
    }
    
    func getIndexForDefaultTab() -> Int {
        return tabTypes.firstIndex(of: defaultTab) ?? 0
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
