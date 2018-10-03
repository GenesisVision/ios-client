//
//  WalletRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum WalletRouteType {
    case withdraw, deposit, showProgramDetails(programId: String), showFilterVC(walletControllerViewModel: WalletControllerViewModel), programList
}

class WalletRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: WalletRouteType) {
        switch routeType {
        case .withdraw:
            withdraw()
        case .deposit:
            deposit()
        case .showProgramDetails(let programId):
            showProgramDetails(with: programId)
        case .showFilterVC(let walletControllerViewModel):
            showFilterVC(with: walletControllerViewModel)
        case .programList:
            showProgramList()
        }
    }
    
    // MARK: - Private methods
    private func showProgramList() {
        changeTab(withParentRouter: self, to: .programList)
    }
    
    private func withdraw() {
        guard let vc = topViewController() else { return }
        
        guard let viewController = WalletWithdrawViewController.storyboardInstance(name: .wallet) else { return }
        let router = WalletWithdrawRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = WalletWithdrawViewModel(withRouter: router, walletProtocol: vc as! WalletProtocol)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func deposit() {
        guard let viewController = WalletDepositViewController.storyboardInstance(name: .wallet) else { return }
        let router = WalletDepositRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = WalletDepositViewModel(withRouter: router)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showFilterVC(with walletControllerViewModel: WalletControllerViewModel) {
        guard let viewController = WalletFilterViewController.storyboardInstance(name: .wallet) else { return }
        let router = WalletFilterRouter(parentRouter: self, navigationController: navigationController)
        let viewModel = WalletFilterViewModel(withRouter: router, walletControllerViewModel: walletControllerViewModel)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
