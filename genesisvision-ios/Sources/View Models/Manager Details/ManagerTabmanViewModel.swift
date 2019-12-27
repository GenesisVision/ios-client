//
//  ManagerTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 26/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor
import Tabman

final class ManagerTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    var managerId: String!
    var publicProfile: PublicProfile?

    // MARK: - Init
    init(withRouter router: Router, managerId: String) {
        self.managerId = managerId
        
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0)
        
        title = "Manager Details"
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public methods
    func reloadDetails() {
        if let vc = viewControllers.first as? ManagerInfoViewController, let publicProfile = publicProfile {
            vc.viewModel.updateDetails(with: publicProfile)
        }
    }
    
    func updateDetails(_ publicProfile: PublicProfile) {
        if let vc = viewControllers.first as? ManagerInfoViewController {
            vc.viewModel.updateDetails(with: publicProfile)
        }
    }
    
    func setup(_ viewModel: PublicProfile? = nil) {
        removeAllControllers()
        
        if let viewModel = viewModel {
            self.publicProfile = viewModel
        }
        
        self.items = []
        
        if let router = router as? ManagerTabmanRouter, let publicProfile = publicProfile, let uuid = publicProfile.id?.uuidString {
            
            if let vc = router.getInfo(with: publicProfile) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            let filterModel = FilterModel()
            filterModel.managerId = uuid
    
            if let vc = router.getPrograms(with: filterModel) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            if let vc = router.getFunds(with: filterModel) {
                self.addController(vc)
                self.items?.append(TMBarItem(title: vc.viewModel.title.uppercased()))
            }
            
            reloadPages()
        }
    }
}
