//
//  ProgramDetailRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum ProgramDetailRouteType {
    case invest(programId: String, currency: String, availableToInvest: Double), withdraw(programId: String, investedTokens: Double, currency: String), fullChart(programDetailsFull: ProgramDetailsFull)
}

class ProgramDetailRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramDetailRouteType) {
        switch routeType {
        case .invest(let programId, let currency, let availableToInvest):
            invest(with: programId, currency: currency, availableToInvest: availableToInvest)
        case .withdraw(let programId, let investedTokens, let currency):
            withdraw(with: programId, investedTokens: investedTokens, currency: currency)
        case .fullChart(let programDetailsFull):
            fullChart(with: programDetailsFull)
        }
    }
    
    // MARK: - Private methods
    func invest(with programId: String, currency: String, availableToInvest: Double) {
        guard let programDetailProtocol = parentRouter?.topViewController() as? ProgramDetailsTabmanViewController,
            let viewController = ProgramInvestViewController.storyboardInstance(name: .program) else { return }
        
        let router = ProgramInvestRouter(parentRouter: self)
        let viewModel = ProgramInvestViewModel(withRouter: router, programId: programId, currency: currency, availableToInvest: availableToInvest, programDetailProtocol: programDetailProtocol)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(with programId: String, investedTokens: Double, currency: String) {
        guard let programDetailProtocol = parentRouter?.topViewController() as? ProgramDetailsTabmanViewController,
            let viewController = ProgramWithdrawViewController.storyboardInstance(name: .program) else { return }
        
        let router = ProgramWithdrawRouter(parentRouter: self)
        let viewModel = ProgramWithdrawViewModel(withRouter: router, programId: programId, investedTokens: investedTokens, currency: currency, programDetailProtocol: programDetailProtocol)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func fullChart(with programDetailsFull: ProgramDetailsFull) {
        guard let viewController = ProgramDetailFullChartViewController.storyboardInstance(name: .program) else { return }
        let router = ProgramDetailFullChartRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramDetailFullChartViewModel(withRouter: router, programDetailsFull: programDetailsFull)
        viewController.viewModel = viewModel
        viewController.modalTransitionStyle = .crossDissolve

        navigationController?.present(viewController: viewController)
    }
}

