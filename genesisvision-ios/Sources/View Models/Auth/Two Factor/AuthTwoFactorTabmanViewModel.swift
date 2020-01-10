//
//  AuthTwoFactorTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 31/05/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Tabman

final class AuthTwoFactorTabmanViewModel: TabmanViewModel {
    enum TabType: String {
        case howTo = "How to", getKey = "Get key", verify = "Verify"
    }
    var tabTypes: [TabType] = [.howTo, .getKey, .verify]
    var controllers = [TabType : UIViewController]()
    
    // MARK: - Variables
    var sharedKey: String?
    
    // MARK: - Init
    init(withRouter router: Router) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        title = "Enable Two Factor"
        isProgressive = true
        isScrollEnabled = false
        bounces = false
        compresses = true
        
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
        self.dataSource = PageboyDataSource(self)
    }
    
    func getViewController(_ type: TabType) -> UIViewController? {
        guard let router = router as? AuthTwoFactorTabmanRouter else { return nil }
        
        switch type {
        case .howTo:
            guard let saved = controllers[type] else {
                return router.getTutorialVC(with: self)
            }
            
            return saved
        case .getKey:
            guard let saved = controllers[type] else {
                return router.getCreateVC(with: self)
            }
            
            return saved
        case .verify:
            guard let saved = controllers[type] else {
                return router.getConfirmationVC(with: self)
            }
            
            return saved
        }
    }
}

extension AuthTwoFactorTabmanViewModel: TabmanDataSourceProtocol {
    func getCount() -> Int {
        return tabTypes.count
    }
    
    func getItem(_ index: Int) -> TMBarItem? {
        let type = tabTypes[index]
    
        return TMBarItem(title: type.rawValue)
    }
    
    func getViewController(_ index: Int) -> UIViewController? {
        return getViewController(tabTypes[index])
    }
}
