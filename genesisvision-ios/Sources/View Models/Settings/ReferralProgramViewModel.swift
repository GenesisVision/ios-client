//
//  ReferralProgramViewModel.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 08.11.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

final class ReferralProgramViewModel: TabmanViewModel {
    enum TabType: String {
        case info = "Info"
        case friends = "Referral friends"
        case history = "History"
    }
    
    private let tabTypes: [TabType] = [.info, .friends, .history]
    
    private var controllers = [TabType : UIViewController]()
    
    init(with router: Router) {
        super.init(withRouter: router, viewControllersCount: tabTypes.count, defaultPage: 0)
        
        font = UIFont.getFont(.semibold, size: 16)
        
        title = "Referral program"
        
        setViewControllers()
        self.dataSource = PageboyDataSource(self)
    }
    
    private func setViewControllers() {
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
    }
    
    private func getViewController(_ type: TabType) -> UIViewController {
        switch type {
        case .friends:
            return ReferralFriendsViewController()
        case .info:
            return ReferralInfoViewController()
        case .history:
            return ReferralHistoryViewController()
        }
    }
}

extension ReferralProgramViewModel: TabmanDataSourceProtocol {
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
