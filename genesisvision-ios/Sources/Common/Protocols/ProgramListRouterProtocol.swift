//
//  ProgramListRouterProtocol.swift
//  genesisvision-ios
//
//  Created by George on 09/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ProgramListRouteType {
    case signIn, showProgramDetails(programId: String), showFilterVC(programListViewModel: ProgramListViewModel), showTournamentVC(tournamentTotalRounds: Int, tournamentCurrentRound: Int)
}

protocol ProgramListRouterProtocol {
    func show(routeType: ProgramListRouteType)
}

extension ProgramListRouterProtocol where Self: Router {
    func show(routeType: ProgramListRouteType) {
        switch routeType {
        case .showProgramDetails(let programId):
            showProgramDetails(with: programId)
        default:
            break
        }
    }
}
