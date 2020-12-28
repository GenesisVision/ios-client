//
//  FacetsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 17.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import UIKit

final class FacetsViewModel: ListViewModelProtocolWithFacets {
    var facets: [AssetFacet]?
    
    var router: ListRouterProtocol!
    var facetsDelegateManager = FacetsDelegateManager()
    
    var assetType: AssetType = .program
    
    init(withRouter router: ListRouterProtocol, facets: [AssetFacet]? = nil, assetType: AssetType) {
        self.router = router
        self.facets = facets
        self.assetType = assetType
        self.facetsDelegateManager.dataSource = self
    }
    
    /// Return view models for registration cell Nib files
    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [FacetCollectionViewCellViewModel.self]
    }
    func didSelectFacet(at indexPath: IndexPath) {
        guard let facets = facets, !facets.isEmpty else {
            return
        }
        
        let facet = facets[indexPath.row]
        
        let filterModel = FilterModel()
        
        if let facetTitle = facet.title {
            filterModel.facetTitle = facetTitle
        }
        
        if let facetSorting = facet.sorting {
            filterModel.facetSorting = facetSorting
        }
        
        if let uuid = facet._id?.uuidString {
            filterModel.facetId = uuid
        }
        
        filterModel.isFavorite = filterModel.facetTitle == "Favorites"
        
        guard let sortType = facet.sortType else {
            return router.show(routeType: .showAssetList(filterModel: filterModel, assetType: assetType))
        }
        
        filterModel.sortingModel.sortType = sortType.rawValue
        
        if let facetSortType = facet.sortType {
            switch facetSortType {
            case .new:
                switch assetType {
                case ._none:
                    filterModel.sortingModel.selectedSorting = ProgramsFilterSorting.byNewDesc
                case .program:
                    filterModel.sortingModel.selectedSorting = ProgramsFilterSorting.byNewDesc
                case .fund:
                    filterModel.sortingModel.selectedSorting = FundsFilterSorting.byNewDesc
                case .follow:
                    filterModel.sortingModel.selectedSorting = FollowFilterSorting.byNewDesc
                }
            case .top:
                switch assetType {
                case ._none:
                    filterModel.sortingModel.selectedSorting = ProgramsFilterSorting.byProfitDesc
                case .program:
                    filterModel.sortingModel.selectedSorting = ProgramsFilterSorting.byProfitDesc
                case .fund:
                    filterModel.sortingModel.selectedSorting = FundsFilterSorting.byProfitDesc
                case .follow:
                    filterModel.sortingModel.selectedSorting = FollowFilterSorting.byProfitDesc
                }
            case .weeklyTop:
                switch assetType {
                case ._none:
                    filterModel.sortingModel.selectedSorting = ProgramsFilterSorting.byProfitDesc
                case .program:
                    filterModel.sortingModel.selectedSorting = ProgramsFilterSorting.byProfitDesc
                case .fund:
                    filterModel.sortingModel.selectedSorting = FundsFilterSorting.byProfitDesc
                case .follow:
                    filterModel.sortingModel.selectedSorting = FollowFilterSorting.byProfitDesc
                }
            case .popular:
                switch assetType {
                case ._none:
                    filterModel.sortingModel.selectedSorting = ProgramsFilterSorting.byInvestorsDesc
                case .program:
                    filterModel.sortingModel.selectedSorting = ProgramsFilterSorting.byInvestorsDesc
                case .fund:
                    filterModel.sortingModel.selectedSorting = FundsFilterSorting.byInvestorsDesc
                case .follow:
                    filterModel.sortingModel.selectedSorting = FollowFilterSorting.bySubscribersDesc
                }
            case .toLevelUp:
                break
            case .mostReliable:
                break
            case .trading:
                break
            case .investing:
                break
            case .aum:
                break
            case .fundsChallenge:
                break
            }
        }
        
        if let facetTimeFrame = facet.timeframe {
            switch facetTimeFrame {
            case .day:
                filterModel.dateRangeModel = .init(dateRangeType: .day, dateFrom: Date().removeDays(1), dateTo: Date())
            case .week:
                filterModel.dateRangeModel = .init(dateRangeType: .week, dateFrom: Date().removeDays(7), dateTo: Date())
            case .month:
                filterModel.dateRangeModel = .init(dateRangeType: .month, dateFrom: Date().removeMonths(1), dateTo: Date())
            case .threeMonths:
                filterModel.dateRangeModel = .init(dateRangeType: .custom, dateFrom: Date().removeMonths(3), dateTo: Date())
            case .year:
                filterModel.dateRangeModel = .init(dateRangeType: .year, dateFrom: Date().removeYears(1), dateTo: Date())
            case .allTime:
                filterModel.dateRangeModel = .init(dateRangeType: .all, dateFrom: Date().removeYears(20), dateTo: Date())
            }
        }
        
        router.show(routeType: .showAssetList(filterModel: filterModel, assetType: assetType))
    }
    func numberOfItems(in section: Int) -> Int {
        return facets?.count ?? 0
    }
    func model(for indexPath: IndexPath) -> FacetCollectionViewCellViewModel? {
        let facet = facets?[indexPath.row]

        let isFavoriteFacet = facet?._id == nil
        let model = FacetCollectionViewCellViewModel(facet: facet, isFavoriteFacet: isFavoriteFacet)
        return model
    }
}
