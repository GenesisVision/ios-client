//
//  TournamentRouter.swift
//  genesisvision-ios
//
//  Created by George Shaginyan on 11.02.18.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum TournamentRouteType {
    case showDetail(investmentProgramId: String), getDetail(investmentProgramId: String)
}

class TournamentRouter: Router {
    
    // MARK: - Public methods
    func show(routeType: TournamentRouteType) {
        switch routeType {
        case .getDetail(let investmentProgramId):
            getDetailViewController(with: investmentProgramId)
        case .showDetail(let investmentProgramId):
            showProgramDetail(with: investmentProgramId)
        }
    }
}

