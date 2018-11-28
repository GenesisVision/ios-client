//
//  ListRouterProtocol.swift
//  genesisvision-ios
//
//  Created by George on 09/07/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

enum ListRouteType {
    case signIn
    case showAssetDetails(assetId: String, assetType: AssetType)
    case showAssetList(filterModel: FilterModel, assetType: AssetType)
    case showFilterVC(listViewModel: ListViewModelProtocol, filterModel: FilterModel, filterType: FilterType, sortingType: SortingType)
}

protocol ListRouterProtocol {
    func show(routeType: ListRouteType)
}

extension ListRouterProtocol where Self: Router {
    func show(routeType: ListRouteType) {
        switch routeType {
        case .signIn:
            signInAction()
        case .showAssetDetails(let assetId, let assetType):
            showAssetDetails(with: assetId, assetType: assetType)
        case .showAssetList(let filterModel, let assetType):
            showAssetList(with: filterModel, assetType: assetType)
        case .showFilterVC(let listViewModel, let filterModel, let filterType, let sortingType):
            showFilterVC(with: listViewModel, filterModel: filterModel, filterType: filterType, sortingType: sortingType)
        }
    }
}
