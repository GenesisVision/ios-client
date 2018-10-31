//
//  ManagerTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 26/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit.UIColor

final class ManagerTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    var managerId: String!
    var managerProfileDetails: ManagerProfileDetails?

    // MARK: - Init
    init(withRouter router: Router, managerId: String, tabmanViewModelDelegate: TabmanViewModelDelegate) {
        self.managerId = managerId
        
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        title = "Manager Details"
        backgroundColor = UIColor.Cell.bg
    }
    
    // MARK: - Public methods
    func reloadDetails() {
        if let vc = viewControllers.first as? ManagerInfoViewController, let managerProfileDetails = managerProfileDetails {
            vc.viewModel.updateDetails(with: managerProfileDetails)
        }
    }
    
    func updateDetails(_ managerProfileDetails: ManagerProfileDetails) {
        if let vc = viewControllers.first as? ManagerInfoViewController {
            vc.viewModel.updateDetails(with: managerProfileDetails)
        }
    }
    
    func setup(_ viewModel: ManagerProfileDetails? = nil) {
        removeAllControllers()
        
        if let viewModel = viewModel {
            self.managerProfileDetails = viewModel
        }
        
        if let router = router as? ManagerTabmanRouter, let managerProfileDetails = managerProfileDetails {
            if let vc = router.getInfo(with: managerProfileDetails) {
                self.addController(vc)
                self.addItem(vc.viewModel.title.uppercased())
            }
            
            if let managerId = managerProfileDetails.managerProfile?.id?.uuidString, let programs = router.getPrograms(with: managerId), let funds = router.getFunds(with: managerId) {
                
                self.addController(funds)
                self.addItem(funds.viewModel.title.uppercased())
                
                self.addController(programs)
                self.addItem(programs.viewModel.title.uppercased())
            }
            
            reloadPages()
        }
    }
}
