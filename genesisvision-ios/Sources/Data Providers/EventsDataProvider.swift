//
//  EventsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 09.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

class EventsDataProvider: DataProvider {
    static func get(_ assetId: String? = nil, eventLocation: InvestmentEventLocation? = nil, from: Date? = nil, to: Date? = nil, eventType: InvestmentEventType? = nil, assetType: AssetFilterType? = nil, assetsIds: [UUID]? = nil, forceFilterByIds: Bool? = nil, eventGroup: EventGroupType? = nil, skip: Int?, take: Int?, completion: @escaping (InvestmentEventViewModels?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        var uuid: UUID?
        if let assetId = assetId {
            uuid = UUID(uuidString: assetId)
        }
        
        EventsAPI.getEvents(eventLocation: eventLocation, assetId: uuid, from: from, to: to, eventType: eventType, assetType: assetType, assetsIds: assetsIds, forceFilterByIds: forceFilterByIds, eventGroup: eventGroup, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
