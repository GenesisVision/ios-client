//
//  AssetsPageboyViewControllerDataSource.swift
//  genesisvision-ios
//
//  Created by George on 17/09/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class AssetsPageboyViewControllerDataSource: BasePageboyViewControllerDataSource {
    // MARK: - Private methods
    internal override func setup(router: Router, showFacets: Bool) {
        guard let programListViewController = getProgramList(with: router, filterModel: FilterModel(), showFacets: showFacets),
            let fundListViewController = getFundList(with: router, filterModel: FilterModel(), showFacets: showFacets),
            let followListViewController = getFollowList(with: router, filterModel: FilterModel(), showFacets: showFacets)
            else { return }
        
        controllers = [followListViewController, fundListViewController, programListViewController]
    }
    
    func getProgramList(with router: Router, filterModel: FilterModel? = nil, showFacets: Bool) -> ProgramListViewController? {
        guard let viewController = ProgramListViewController.storyboardInstance(.assets) else { return nil }
        router.programsViewController = viewController
        let listRouter = ListRouter(parentRouter: router)
        listRouter.currentController = viewController
        let viewModel =
            ListViewModel(withRouter: listRouter, reloadDataProtocol: viewController, filterModel: filterModel, showFacets: showFacets, assetType: .program)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    func getFundList(with router: Router, filterModel: FilterModel? = nil, showFacets: Bool) -> FundListViewController? {
        guard let viewController = FundListViewController.storyboardInstance(.assets) else { return nil }
        router.fundsViewController = viewController
        let listRouter = ListRouter(parentRouter: router)
        listRouter.currentController = viewController
        let viewModel = ListViewModel(withRouter: listRouter, reloadDataProtocol: viewController, filterModel: filterModel, showFacets: showFacets, assetType: .fund)
        let weeklyChallangeViewModel = WeeklyChallangeTableViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        viewController.topTableViewModel = weeklyChallangeViewModel
        
        return viewController
    }
    
    func getFollowList(with router: Router, filterModel: FilterModel? = nil, showFacets: Bool) -> ProgramListViewController? {
        guard let viewController = ProgramListViewController.storyboardInstance(.assets) else { return nil }
        router.followsViewController = viewController
        let listRouter = ListRouter(parentRouter: router)
        listRouter.currentController = viewController
        let viewModel =
            ListViewModel(withRouter: listRouter, reloadDataProtocol: viewController, filterModel: filterModel, showFacets: showFacets, assetType: .follow)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
