//
//  ListRouterProtocol.swift
//  genesisvision-ios
//
//  Created by George on 09/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ListRouteType {
    case signIn, showProgramDetails(programId: String), showFundDetails(fundId: String), showFilterVC(programListViewModel: ProgramListViewModel)
}

protocol ListRouterProtocol {
    func show(routeType: ListRouteType)
}

extension ListRouterProtocol where Self: Router {
    func show(routeType: ListRouteType) {
        switch routeType {
        case .showProgramDetails(let programId):
            showProgramDetails(with: programId)
        case .showFundDetails(let fundId):
            showFundDetails(with: fundId)
        default:
            break
        }
    }
}
