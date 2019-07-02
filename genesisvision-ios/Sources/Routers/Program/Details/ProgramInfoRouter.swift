//
//  ProgramInfoRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum ProgramInfoRouteType {
    case invest(programId: String, programCurrency: CurrencyType)
    case withdraw(programId: String, programCurrency: CurrencyType)
    case fullChart(programDetailsFull: ProgramDetailsFull)
    case manager(managerId: String)
    case editSubscribe(programId: String, signalSubscription: SignalSubscription)
    case subscribe(programId: String, initialDepositCurrency: CurrencyType?, initialDepositAmount: Double?)
    case unsubscribe(programId: String)
    case createAccount(programId: String, programCurrency: CurrencyType, completion: CreateAccountCompletionBlock)
}

class ProgramInfoRouter: Router {
    var programViewController: ProgramViewController!
    
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
        case .editSubscribe(let programId, let signalSubscription):
            editSubscribe(programId, signalSubscription: signalSubscription)
        case .subscribe(let programId, let initialDepositCurrency, let initialDepositAmount):
            subscribe(programId, initialDepositCurrency: initialDepositCurrency, initialDepositAmount: initialDepositAmount)
        case .unsubscribe(let programId):
            unsubscribe(programId)
        case .createAccount(let programId, let programCurrency, let completion):
            createAccount(with: programId, programCurrency: programCurrency, completion: completion)
        }
    }
    
    // MARK: - Private methods
    func invest(with programId: String, programCurrency: CurrencyType) {
        guard let viewController = ProgramInvestViewController.storyboardInstance(.program) else { return }
        
        let router = ProgramInvestRouter(parentRouter: self)
        let viewModel = ProgramInvestViewModel(withRouter: router, programId: programId, programCurrency: programCurrency, detailProtocol: programViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(with programId: String, programCurrency: CurrencyType) {
        guard let viewController = ProgramWithdrawViewController.storyboardInstance(.program) else { return }
        
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
    
    func createAccount(with programId: String, programCurrency: CurrencyType, completion: @escaping CreateAccountCompletionBlock) {
        guard let viewController = CreateAccountViewController.storyboardInstance(.program) else { return }
        
        let viewModel = CreateAccountViewModel(withRouter: self, programId: programId, programCurrency: programCurrency, completion: completion)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func editSubscribe(_ programId: String, signalSubscription: SignalSubscription) {
        guard let viewController = ProgramSubscribeViewController.storyboardInstance(.program) else { return }
        
        let viewModel = ProgramSubscribeViewModel(withRouter: self, programId: programId, signalSubscription: signalSubscription, detailProtocol: programViewController, followType: .follow)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func subscribe(_ programId: String, initialDepositCurrency: CurrencyType?, initialDepositAmount: Double?) {
        guard let viewController = ProgramSubscribeViewController.storyboardInstance(.program) else { return }
        
        let viewModel = ProgramSubscribeViewModel(withRouter: self, programId: programId, initialDepositCurrency: initialDepositCurrency, initialDepositAmount: initialDepositAmount, detailProtocol: programViewController, followType: .follow)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func unsubscribe(_ programId: String) {
        guard let viewController = ProgramSubscribeViewController.storyboardInstance(.program) else { return }
        
        let viewModel = ProgramSubscribeViewModel(withRouter: self, programId: programId, detailProtocol: programViewController, followType: .unfollow)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

