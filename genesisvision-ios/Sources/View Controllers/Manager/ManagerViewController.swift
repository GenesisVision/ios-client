//
//  ManagerViewController.swift
//  genesisvision-ios
//
//  Created by George on 26/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit
import Tabman

class ManagerViewController: BaseTabmanViewController<ManagerViewModel> {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgressHUD()
        setup()
        viewModel.fetch { [weak self] (result) in
            self?.hideHUD()
            self?.reloadData()
            self?.title = self?.viewModel.title
        }
    }
    
    // MARK: - Private methods
    private func setupUI() {
        
    }
    
    private func setup() {
        navigationItem.title = viewModel.title
        
        dataSource = viewModel.dataSource
        
        setupUI()
    }
}

extension ManagerViewController: ReloadDataProtocol {
    func didReloadData() {
        
    }
}
final class ManagerViewModel: TabmanViewModel {
    enum TabType: String {
        case info = "Info"
        case programs = "Programs"
        case follows = "Follows"
        case funds = "Funds"
    }
    var tabTypes: [TabType] = [.info, .programs, .follows, .funds]
    var controllers = [TabType : UIViewController]()
    
    // MARK: - Variables
    var managerId: String?
    
    var publicProfile: PublicProfile? {
        didSet {
            guard let publicProfile = publicProfile else { return }
            title = publicProfile.username ?? ""
        }
    }
    
    weak var reloadDataProtocol: ReloadDataProtocol?
    
    // MARK: - Init
    init(withRouter router: Router, managerId: String? = nil) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        self.managerId = managerId
        self.title = ""
        
        font = UIFont.getFont(.semibold, size: 16)
        
        self.tabTypes.forEach({ controllers[$0] = getViewController($0) })
        self.dataSource = PageboyDataSource(self)
    }
    
    func getViewController(_ type: TabType) -> UIViewController? {
        if let saved = controllers[type] { return saved }
        
        guard let router = router as? ManagerRouter, let managerId = self.managerId else { return nil }
        
        switch type {
        case .info:
            return router.getInfo(with: managerId)
        case .programs:
            let filterModel = FilterModel()
            filterModel.managerId = managerId
            return router.getPrograms(with: filterModel)
        case .follows:
            let filterModel = FilterModel()
            filterModel.managerId = managerId
            return router.getFollows(with: filterModel)
        case .funds:
            let filterModel = FilterModel()
            filterModel.managerId = managerId
            return router.getFunds(with: filterModel)
        }
    }
}
extension ManagerViewModel: TabmanDataSourceProtocol {
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
// MARK: - Actions
extension ManagerViewModel {
    func fetch(_ completion: @escaping CompletionBlock) {
        guard let managerId = self.managerId else { return }
        
        UsersDataProvider.get(with: managerId, completion: { [weak self] (viewModel) in
            guard let viewModel = viewModel else { return }
            self?.publicProfile = viewModel
            completion(.success)
        }, errorCompletion: completion)
    }
}
