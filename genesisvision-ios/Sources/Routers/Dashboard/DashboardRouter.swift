//
//  DashboardRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 26.01.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum DashboardRouteType {
    case showProgramDetails(investmentProgramId: String), programList
}

class DashboardRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: DashboardRouteType) {
        switch routeType {
        case .showProgramDetails(let investmentProgramId):
            showProgramDetails(with: investmentProgramId)
        case .programList:
            showProgramList()
        }
    }
    
    // MARK: - Private methods
    private func showProgramList() {
        changeTab(withParentRouter: self, to: .programList)
    }
}
