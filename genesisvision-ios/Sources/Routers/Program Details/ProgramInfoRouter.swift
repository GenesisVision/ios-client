//
//  ProgramInfoRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum ProgramInfoRouteType {
    case invest(programId: String), withdraw(programId: String), fullChart(programDetailsFull: ProgramDetailsFull), manager(managerId: String)
}

class ProgramInfoRouter: Router {
    // MARK: - Public methods
    func show(routeType: ProgramInfoRouteType) {
        switch routeType {
        case .invest(let programId):
            invest(with: programId)
        case .withdraw(let programId):
            withdraw(with: programId)
        case .fullChart(let programDetailsFull):
            fullChart(with: programDetailsFull)
        case .manager(let managerId):
            manager(with: managerId)
        }
    }
    
    // MARK: - Private methods
    func invest(with programId: String) {
        guard let programViewController = parentRouter?.topViewController() as? ProgramViewController,
            let viewController = ProgramInvestViewController.storyboardInstance(name: .program) else { return }
        
        let router = ProgramInvestRouter(parentRouter: self)
        let viewModel = ProgramInvestViewModel(withRouter: router, programId: programId, programDetailProtocol: programViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func manager(with managerId: String) {
        guard let viewController = ManagerViewController.storyboardInstance(name: .manager) else { return }
        
        let router = ManagerRouter(parentRouter: self, navigationController: navigationController, managerViewController: viewController)
        let viewModel = ManagerViewModel(withRouter: router, managerId: managerId, managerViewController: viewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(with programId: String) {
        guard let programViewController = parentRouter?.topViewController() as? ProgramViewController,
            let viewController = ProgramWithdrawViewController.storyboardInstance(name: .program) else { return }
        
        let router = ProgramWithdrawRouter(parentRouter: self)
        let viewModel = ProgramWithdrawViewModel(withRouter: router, programId: programId, programDetailProtocol: programViewController)
        viewController.viewModel = viewModel
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

