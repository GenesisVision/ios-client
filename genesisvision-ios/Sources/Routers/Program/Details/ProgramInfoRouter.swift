//
//  ProgramInfoRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum ProgramInfoRouteType {
    case invest(assetId: String, programCurrency: CurrencyType)
    case withdraw(assetId: String, programCurrency: CurrencyType)
    case fullChart(programDetailsFull: ProgramFollowDetailsFull)
    case manager(managerId: String)
    case editSubscribe(assetId: String, signalSubscription: SignalSubscription)
    case subscribe(assetId: String, currency: CurrencyType?, tradingAccountId: UUID?)
    case unsubscribe(assetId: String)
    case createAccount(assetId: String, brokerId: UUID?, leverage: Int?, programCurrency: CurrencyType, completion: CreateAccountCompletionBlock)
}

class ProgramInfoRouter: Router {
    var programViewController: ProgramViewController!
    
    // MARK: - Public methods
    func show(routeType: ProgramInfoRouteType) {
        switch routeType {
        case .invest(let assetId, let programCurrency):
            invest(with: assetId, programCurrency: programCurrency)
        case .withdraw(let assetId, let programCurrency):
            withdraw(with: assetId, programCurrency: programCurrency)
        case .fullChart(let programDetailsFull):
            fullChart(with: programDetailsFull)
        case .manager(let userId):
            showUserDetails(with: userId)
        case .editSubscribe(let assetId, let signalSubscription):
            editSubscribe(assetId, signalSubscription: signalSubscription)
        case .subscribe(let assetId, let currency, let tradingAccountId):
            subscribe(assetId, currency: currency, tradingAccountId: tradingAccountId)
        case .unsubscribe(let assetId):
            unsubscribe(assetId)
        case .createAccount(let assetId, let brokerId, let leverage, let programCurrency, let completion):
            createAccount(with: assetId, brokerId: brokerId, leverage: leverage, programCurrency: programCurrency, completion: completion)
        }
    }
    
    // MARK: - Private methods
    func invest(with assetId: String, programCurrency: CurrencyType) {
        guard let viewController = ProgramInvestViewController.storyboardInstance(.program) else { return }
        
        let router = ProgramInvestRouter(parentRouter: self)
        let viewModel = ProgramInvestViewModel(withRouter: router, assetId: assetId, programCurrency: programCurrency, detailProtocol: programViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(with assetId: String, programCurrency: CurrencyType) {
        guard let viewController = ProgramWithdrawViewController.storyboardInstance(.program) else { return }
        
        let router = ProgramWithdrawRouter(parentRouter: self)
        let viewModel = ProgramWithdrawViewModel(withRouter: router, assetId: assetId, programCurrency: programCurrency, detailProtocol: programViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func fullChart(with programDetailsFull: ProgramFollowDetailsFull) {
        guard let viewController = ProgramDetailFullChartViewController.storyboardInstance(.program) else { return }
        let router = self.parentRouter?.parentRouter as! ProgramRouter
        let viewModel = ProgramDetailFullChartViewModel(withRouter: router, programDetailsFull: programDetailsFull)
        viewController.viewModel = viewModel
        viewController.modalTransitionStyle = .crossDissolve

        navigationController?.present(viewController: viewController)
    }
    
    func createAccount(with assetId: String, brokerId: UUID?, leverage: Int?, programCurrency: CurrencyType, completion: @escaping CreateAccountCompletionBlock) {
        guard let viewController = OldCreateAccountViewController.storyboardInstance(.program) else { return }
        
        let viewModel = OldCreateAccountViewModel(withRouter: self, assetId: assetId, brokerId: brokerId, leverage: leverage, programCurrency: programCurrency, completion: completion)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func editSubscribe(_ assetId: String, signalSubscription: SignalSubscription) {
        guard let viewController = ProgramSubscribeViewController.storyboardInstance(.program) else { return }
        
        let viewModel = ProgramSubscribeViewModel(withRouter: self, assetId: assetId, signalSubscription: signalSubscription, detailProtocol: programViewController, followType: .edit, delegate: viewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func subscribe(_ assetId: String, currency: CurrencyType?, tradingAccountId: UUID?) {
        guard let viewController = ProgramSubscribeViewController.storyboardInstance(.program) else { return }
        
        let viewModel = ProgramSubscribeViewModel(withRouter: self, assetId: assetId, tradingAccountId: tradingAccountId, сurrency: currency, detailProtocol: programViewController, followType: .follow, delegate: viewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func unsubscribe(_ assetId: String) {
        guard let viewController = ProgramSubscribeViewController.storyboardInstance(.program) else { return }
        
        let viewModel = ProgramSubscribeViewModel(withRouter: self, assetId: assetId, detailProtocol: programViewController, followType: .unfollow, delegate: viewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

