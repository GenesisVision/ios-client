//
//  ListRouterProtocol.swift
//  genesisvision-ios
//
//  Created by George on 09/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ListRouteType {
    case signIn, showProgramDetails(programId: String), showFundDetails(fundId: String), showFilterVC(listViewModel: ListViewModelProtocol, filterModel: FilterModel, filterType: FilterType, sortingType: SortingType)
}

protocol ListRouterProtocol {
    func show(routeType: ListRouteType)
}

extension ListRouterProtocol where Self: Router {
    func show(routeType: ListRouteType) {
        switch routeType {
        case .signIn:
            signInAction()
        case .showProgramDetails(let programId):
            showProgramDetails(with: programId)
        case .showFundDetails(let fundId):
            showFundDetails(with: fundId)
        case .showFilterVC(let listViewModel, let filterModel, let filterType, let sortingType):
            showFilterVC(with: listViewModel, filterModel: filterModel, filterType: filterType, sortingType: sortingType)
        }
    }
}
