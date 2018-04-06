//
//  ProgramInvestRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramInvestRouteType {
    case investmentRequested
}

class ProgramInvestRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramInvestRouteType) {
        switch routeType {
        case .investmentRequested:
            investmentRequested()
        }
    }
    
    // MARK: - Private methods
    private func investmentRequested() {
        guard let viewController = InfoViewController.storyboardInstance(name: .auth) else { return }
        let router = Router(parentRouter: self, navigationController: navigationController)
        childRouters.append(router)
        viewController.viewModel = ProgramInvestSuccessViewModel(withRouter: router)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
