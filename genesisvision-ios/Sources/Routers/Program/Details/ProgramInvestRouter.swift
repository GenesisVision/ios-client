//
//  ProgramInvestRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 21.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramInvestRouteType {
    case investmentRequested(investedAmount: Double)
}

class ProgramInvestRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramInvestRouteType) {
        switch routeType {
        case .investmentRequested(let investedAmount):
            investmentRequested(investedAmount: investedAmount)
        }
    }
    
    // MARK: - Private methods
    private func investmentRequested(investedAmount: Double) {
        guard let viewController = InfoViewController.storyboardInstance(.auth) else { return }
        let router = Router(parentRouter: self, navigationController: navigationController)
        viewController.viewModel = ProgramInvestSuccessViewModel(withRouter: router, investedAmount: investedAmount)
        present(viewController: viewController)
    }
}
