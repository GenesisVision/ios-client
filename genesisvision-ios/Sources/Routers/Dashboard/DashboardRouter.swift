//
//  DashboardRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum DashboardRouteType {
    case showProgramDetail(investmentProgramId: String), invest(investmentProgramId: String), withdraw(investmentProgramId: String, investedTokens: Double), programList
}

class DashboardRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: DashboardRouteType) {
        switch routeType {
        case .showProgramDetail(let investmentProgramId):
            showProgramDetail(with: investmentProgramId)
        case .invest(let investmentProgramId):
            invest(with: investmentProgramId)
        case .withdraw(let investmentProgramId, let investedTokens):
            withdraw(with: investmentProgramId, investedTokens: investedTokens)
        case .programList:
            showProgramList()
        }
    }
    
    // MARK: - Private methods
    private func showProgramList() {
        changeTab(withParentRouter: self, to: .programList)
    }
}
