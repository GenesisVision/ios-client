//
//  ReferralDataProvider.swift
//  genesisvision-ios
//
//  Created by Ruslan Lukin on 09.11.2020.
//  Copyright © 2020 Genesis Vision. All rights reserved.
//
import Foundation

class ReferralDataProvider: DataProvider {
    
    static func getReferralDetails(currency: Currency? = .usd, completion: @escaping (_ profile: PartnershipDetails?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        PartnershipAPI.getDetails(currency: currency) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getRewards(dateFrom: Date?, dateTo: Date?, skip: Int, take: Int, completion: @escaping (_ profile: RewardDetailsItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        PartnershipAPI.getRewardsHistory(dateFrom: dateFrom, dateTo: dateTo, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
    
    static func getFriends(dateFrom: Date? = nil, dateTo: Date? = nil, skip: Int? = nil, take: Int? = nil, completion: @escaping (_ profile: ReferralFriendItemsViewModel?) -> Void, errorCompletion: @escaping CompletionBlock) {
        
        PartnershipAPI.getReferrals(dateFrom: dateFrom, dateTo: dateTo, skip: skip, take: take) { (viewModel, error) in
            DataProvider().responseHandler(viewModel, error: error, successCompletion: completion, errorCompletion: errorCompletion)
        }
    }
}
