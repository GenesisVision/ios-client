//
//  ProgramDetailRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum ProgramDetailRouteType {
    case invest(investmentProgramId: String, currency: String, availableToInvest: Double), withdraw(investmentProgramId: String, investedTokens: Double, currency: String), fullChart(investmentProgramDetails: InvestmentProgramDetails)
}

class ProgramDetailRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramDetailRouteType) {
        switch routeType {
        case .invest(let investmentProgramId, let currency, let availableToInvest):
            invest(with: investmentProgramId, currency: currency, availableToInvest: availableToInvest)
        case .withdraw(let investmentProgramId, let investedTokens, let currency):
            withdraw(with: investmentProgramId, investedTokens: investedTokens, currency: currency)
        case .fullChart(let investmentProgramDetails):
            fullChart(with: investmentProgramDetails)
        }
    }
    
    // MARK: - Private methods
    func invest(with investmentProgramId: String, currency: String, availableToInvest: Double) {
        guard let programDetailProtocol = parentRouter?.topViewController() as? ProgramDetailsTabmanViewController,
            let viewController = ProgramInvestViewController.storyboardInstance(name: .program) else { return }
        
        let router = ProgramInvestRouter(parentRouter: self)
        let viewModel = ProgramInvestViewModel(withRouter: router, investmentProgramId: investmentProgramId, currency: currency, availableToInvest: availableToInvest, programDetailProtocol: programDetailProtocol)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(with investmentProgramId: String, investedTokens: Double, currency: String) {
        guard let programDetailProtocol = parentRouter?.topViewController() as? ProgramDetailsTabmanViewController,
            let viewController = ProgramWithdrawViewController.storyboardInstance(name: .program) else { return }
        
        let router = ProgramWithdrawRouter(parentRouter: self)
        let viewModel = ProgramWithdrawViewModel(withRouter: router, investmentProgramId: investmentProgramId, investedTokens: investedTokens, currency: currency, programDetailProtocol: programDetailProtocol)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func fullChart(with investmentProgramDetails: InvestmentProgramDetails) {
        guard let viewController = ProgramDetailFullChartViewController.storyboardInstance(name: .program) else { return }
        let router = ProgramDetailFullChartRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = ProgramDetailFullChartViewModel(withRouter: router, investmentProgramDetails: investmentProgramDetails)
        viewController.viewModel = viewModel
        viewController.modalTransitionStyle = .crossDissolve

        navigationController?.present(viewController: viewController)
    }
}

