//
//  AccountInfoRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 13.01.20.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import Foundation

enum AccountInfoRouteType {
    case invest(assetId: String, accountCurrency: CurrencyType)
    case withdraw(assetId: String, accountCurrency: CurrencyType)
    
    case createProgram(assetId: String, completion: CreateAccountCompletionBlock)
    case createFollow(assetId: String, completion: CreateAccountCompletionBlock)
    
    case showSubscriptionDetails(assetId: String, signalSubscription: SignalSubscription)
}

class AccountInfoRouter: Router {
    var accountViewController: AccountViewController!
    
    // MARK: - Public methods
    func show(routeType: AccountInfoRouteType) {
        switch routeType {
        case .invest(let assetId, let accountCurrency):
            invest(assetId, accountCurrency: accountCurrency)
        case .withdraw(let assetId, let accountCurrency):
            withdraw(assetId, accountCurrency: accountCurrency)
        
        case .showSubscriptionDetails(let assetId, let signalSubscription):
            showSubscriptionDetails(assetId, signalSubscription: signalSubscription)
        
        case .createProgram(let assetId, let completion):
            createProgram(assetId, completion: completion)
        case .createFollow(let assetId, let completion):
            createFollow(assetId, completion: completion)
        }
    }
    
    // MARK: - Private methods
    func invest(_ assetId: String, accountCurrency: CurrencyType) {
        guard let viewController = ProgramInvestViewController.storyboardInstance(.program) else { return }
        
        let router = ProgramInvestRouter(parentRouter: self)
        let viewModel = ProgramInvestViewModel(withRouter: router, assetId: assetId, programCurrency: accountCurrency, detailProtocol: accountViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func withdraw(_ assetId: String, accountCurrency: CurrencyType) {
        guard let viewController = ProgramWithdrawViewController.storyboardInstance(.program) else { return }
        
        let router = ProgramWithdrawRouter(parentRouter: self)
        let viewModel = ProgramWithdrawViewModel(withRouter: router, assetId: assetId, programCurrency: accountCurrency, detailProtocol: accountViewController)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func createProgram(_ assetId: String, completion: @escaping CreateAccountCompletionBlock) {
        guard let viewController = MakeProgramViewController.storyboardInstance(.dashboard) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func createFollow(_ assetId: String, completion: @escaping CreateAccountCompletionBlock) {
        guard let viewController = MakeSignalViewController.storyboardInstance(.dashboard) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showSubscriptionDetails(_ assetId: String, signalSubscription: SignalSubscription) {
        
    }
}

