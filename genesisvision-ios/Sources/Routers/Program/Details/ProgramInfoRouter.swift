//
//  ProgramInfoRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum ProgramInfoRouteType {
    case invest(programId: String, programCurrency: CurrencyType), withdraw(programId: String, programCurrency: CurrencyType), fullChart(programDetailsFull: ProgramDetailsFull), manager(managerId: String), subscribe(programId: String, programCurrency: CurrencyType)
}

class ProgramInfoRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramInfoRouteType) {
        switch routeType {
        case .invest(let programId, let programCurrency):
            invest(with: programId, programCurrency: programCurrency)
        case .withdraw(let programId, let programCurrency):
            withdraw(with: programId, programCurrency: programCurrency)
        case .fullChart(let programDetailsFull):
            fullChart(with: programDetailsFull)
        case .manager(let managerId):
            showAssetDetails(with: managerId, assetType: .manager)
        case .subscribe(let programId, let programCurrency):
            subscribe(with: programId, programCurrency: programCurrency)
        }
    }
    
    // MARK: - Private methods
    func invest(with programId: String, programCurrency: CurrencyType) {
        guard let programViewController = parentRouter?.topViewController() as? ProgramViewController,
            let viewController = ProgramInvestViewController.storyboardInstance(.program) else { return }
        
        let router = ProgramInvestRouter(parentRouter: self)
        let viewModel = ProgramInvestViewModel(withRouter: router, programId: programId, programCurrency: programCurrency, detailProtocol: programViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(with programId: String, programCurrency: CurrencyType) {
        guard let programViewController = parentRouter?.topViewController() as? ProgramViewController,
            let viewController = ProgramWithdrawViewController.storyboardInstance(.program) else { return }
        
        let router = ProgramWithdrawRouter(parentRouter: self)
        let viewModel = ProgramWithdrawViewModel(withRouter: router, programId: programId, programCurrency: programCurrency, detailProtocol: programViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func fullChart(with programDetailsFull: ProgramDetailsFull) {
        guard let viewController = ProgramDetailFullChartViewController.storyboardInstance(.program) else { return }
        let router = self.parentRouter?.parentRouter as! ProgramRouter
        let viewModel = ProgramDetailFullChartViewModel(withRouter: router, programDetailsFull: programDetailsFull)
        viewController.viewModel = viewModel
        viewController.modalTransitionStyle = .crossDissolve

        navigationController?.present(viewController: viewController)
    }
    
    func subscribe(with programId: String, programCurrency: CurrencyType) {
        guard let viewController = ProgramSubscribeViewController.storyboardInstance(.program) else { return }
        
        let router = ProgramInvestRouter(parentRouter: self)
        let viewModel = ProgramSubscribeViewModel(withRouter: router, programId: programId, programCurrency: programCurrency)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

