//
//  DashboardRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum DashboardRouteType {
    case showProgramDetail(investmentProgramId: String), invest(investmentProgramId: String, currency: String, availableToInvest: Double), withdraw(investmentProgramId: String, investedTokens: Double, currency: String), programList
}

class DashboardRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: DashboardRouteType) {
        switch routeType {
        case .showProgramDetail(let investmentProgramId):
            showProgramDetail(with: investmentProgramId)
        case .invest(let investmentProgramId, let currency, let availableToInvest):
            invest(with: investmentProgramId, currency: currency, availableToInvest: availableToInvest)
        case .withdraw(let investmentProgramId, let investedTokens, let currency):
            withdraw(with: investmentProgramId, investedTokens: investedTokens, currency: currency)
        case .programList:
            showProgramList()
        }
    }
    
    // MARK: - Private methods
    private func showProgramList() {
        changeTab(withParentRouter: self, to: .programList)
    }
}
