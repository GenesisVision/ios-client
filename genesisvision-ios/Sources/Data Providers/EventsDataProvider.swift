//
//  EventsDataProvider.swift
//  genesisvision-ios
//
//  Created by George on 09.12.2019.
//  Copyright © 2019 Genesis Vision. All rights reserved.
//

import Foundation

class EventsDataProvider: DataProvider {
    static func get(_ assetId: String? = nil, eventLocation: EventsAPI.EventLocation_getEvents? = nil, from: Date? = nil, to: Date? = nil, eventType: EventsAPI.EventType_getEvents? = nil, assetType: EventsAPI.AssetType_getEvents? = nil, assetsIds: [UUID]? = nil, forceFilterByIds: Bool? = nil, eventGroup: EventsAPI.EventGroup_getEvents? = nil, skip: Int?, take: Int?, completion: @escaping (InvestmentEventViewModels?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        var uuid: UUID?
        if let assetId = assetId {
            uuid = UUID(uuidString: assetId)
        }
        
        guard let authorization = AuthManager.authorizedToken else { return errorCompletion(.failure(errorType: .apiError(message: nil))) }
        
        EventsAPI.getEvents(authorization: authorization, eventLocation: eventLocation, assetId: uuid, from: from, to: to, eventType: eventType, assetType: assetType, assetsIds: assetsIds, forceFilterByIds: forceFilterByIds, eventGroup: eventGroup, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
