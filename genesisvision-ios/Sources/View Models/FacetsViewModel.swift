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
        
        if let uuid = facet.id?.uuidString {
            filterModel.facetId = uuid
        }
        
        filterModel.isFavorite = filterModel.facetTitle == "Favorites"
        
        guard let sortType = facet.sortType else {
            return router.show(routeType: .showAssetList(filterModel: filterModel, assetType: assetType))
        }
        
        filterModel.sortingModel.sortType = sortType.rawValue
        
        router.show(routeType: .showAssetList(filterModel: filterModel, assetType: assetType))
    }
    func numberOfItems(in section: Int) -> Int {
        return facets?.count ?? 0
    }
    func model(for indexPath: IndexPath) -> FacetCollectionViewCellViewModel? {
        let facet = facets?[indexPath.row]

        let isFavoriteFacet = facet?.id == nil
        let model = FacetCollectionViewCellViewModel(facet: facet, isFavoriteFacet: isFavoriteFacet)
        return model
    }
}
