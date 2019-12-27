//
//  EventsViewModel.swift
//  genesisvision-ios
//
//  Created by George on 16/10/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import UIKit

class EventListViewModel: ListViewModelWithPaging {
    var viewModels = [CellViewAnyModel]()
    var title = "Events"
    var canPullToRefresh: Bool = true

    var cellModelsForRegistration: [CellViewAnyModel.Type] {
        return [PortfolioEventTableViewCellViewModel.self]
    }
    var from: Date?
    var to: Date?
    
    var canFetchMoreResults: Bool = true
    var totalCount: Int = 0
    var skip: Int = 0
    
    var assetId: String?
    var assetType: AssetType = .program
    
    lazy var currency = selectedPlatformCurrency
    
    private let errorCompletion: ((CompletionResult) -> Void) = { (result) in
       print(result)
    }
    var router: Router?
    weak var delegate: BaseTableViewProtocol?
    init(_ router: Router?, delegate: BaseTableViewProtocol?) {
        self.delegate = delegate
        self.router = router
    }
    
    func fetch(_ refresh: Bool = false) {
        if refresh {
            skip = 0
        }
        var models = [PortfolioEventTableViewCellViewModel]()
        
        let assetType = EventsAPI.AssetType_getEvents(rawValue: self.assetType.rawValue)
        EventsDataProvider.get(assetId, eventLocation: assetId == nil ? .eventsAll : .asset, from: from, to: to, eventType: .all, assetType: assetType, assetsIds: nil, forceFilterByIds: nil, eventGroup: .none, skip: skip, take: take(), completion: { [weak self] (model) in
            guard let model = model else { return }
            model.events?.forEach({ (event) in
                let viewModel = PortfolioEventTableViewCellViewModel(event: event)
                models.append(viewModel)
            })
            self?.updateViewModels(models, refresh: refresh, total: model.total)
        }, errorCompletion: errorCompletion)
    }
    
    func updateViewModels(_ models: [CellViewAnyModel], refresh: Bool, total: Int?) {
        totalCount = total ?? 0
        skip += take()
        viewModels = refresh ? models : viewModels + models
        delegate?.didReload()
    }
    
    func didSelect(at indexPath: IndexPath) {
        delegate?.didSelect(.tradingEvents, cellViewModel: model(at: indexPath))
    }
    func didSelectEvent(at assetId: String, assetType: AssetType) {
        router?.showAssetDetails(with: assetId, assetType: assetType)
    }
    func showInfiniteIndicator(_ value: Bool) {
        delegate?.didShowInfiniteIndicator(value)
    }
    
    
}
