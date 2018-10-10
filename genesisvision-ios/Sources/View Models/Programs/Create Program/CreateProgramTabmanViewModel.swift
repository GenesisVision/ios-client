//
//  CreateProgramTabmanViewModel.swift
//  genesisvision-ios
//
//  Created by George on 10/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

final class CreateProgramTabmanViewModel: TabmanViewModel {
    // MARK: - Variables
    var brokersViewModel: BrokersInfo?
    
    // MARK: - Init
    init(withRouter router: Router, tabmanViewModelDelegate: TabmanViewModelDelegate) {
        super.init(withRouter: router, viewControllersCount: 1, defaultPage: 0, tabmanViewModelDelegate: tabmanViewModelDelegate)
        
        title = "Create Program"
        isProgressive = true
        isScrollEnabled = false
    }
    
    override func initializeViewControllers() {
        setup()
        getBrokers()
    }
    
    // MARK: - Private methods
    private func setup() {
        if let router = router as? CreateProgramTabmanRouter {
            if let vc = router.getCreateProgramFirstVC(with: self) {
                addController(vc)
//                addItem(vc.viewModel.title)
            }
            
            if let vc = router.getCreateProgramSecondVC(with: self, brokersViewModel: brokersViewModel) {
                addController(vc)
//                addItem(vc.viewModel.title)
            }
            
            if let vc = router.getCreateProgramThirdVC(with: self) {
                addController(vc)
//                addItem(vc.viewModel.title)
            }
            
            reloadPages()
        }
    }
    
    private func reloadDetails() {
//        if let vc = viewControllers[1] as? CreateProgramSecondViewController, let brokersViewModel = brokersViewModel {
//            vc.viewModel.brokersViewModel = brokersViewModel
//        }
    }
    
    private func getBrokers() {
        BrokersDataProvider.getBrokers(completion: { [weak self] (viewModel) in
            self?.brokersViewModel = viewModel
            self?.reloadDetails()
        }) { (result) in }
    }
}

