//
//  InvestmentProgramListRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramRouteType {
    case openProgram(programModel: InvestmentProgramViewModel), signIn, showProgramDetail(traderEntity: InvestmentProgramEntity)
}

class InvestmentProgramListRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: ProgramRouteType) {
        switch routeType {
        case .openProgram(let programModel):
            openProgram(programModel: programModel)
        case .signIn:
            signInAction()
        case .showProgramDetail(let investmentProgramEntity):
            showProgramDetail(with: investmentProgramEntity)
        }
    }
    
    // MARK: - Private methods
    private func openProgram(programModel: InvestmentProgramViewModel) {
        print(programModel)
    }
    
    private func signInAction() {
        guard let viewController = SignInViewController.storyboardInstance(name: .auth) else { return }
        viewController.viewModel = SignInViewModel(withRouter: SignInRouter(navigationController: navigationController))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showProgramDetail(with traderEntity: InvestmentProgramEntity) {
        guard let viewController = TraderViewController.storyboardInstance(name: .traders) else { return }
        viewController.viewModel = ProgramDetailViewModel(withRouter: ProgramDetailRouter(navigationController: navigationController))
        viewController.traderEntity = traderEntity
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
