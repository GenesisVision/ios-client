//
// CoinsTrade.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct CoinsTrade: Codable {


    public var date: Date?

    public var soldAmount: Double?

    public var soldAsset: BasePlatformAsset?

    public var boughtAmount: Double?

    public var boughtAsset: BasePlatformAsset?

    public var price: Double?

    public var commission: Double?

    public var commissionCurrency: String?
    public init(date: Date? = nil, soldAmount: Double? = nil, soldAsset: BasePlatformAsset? = nil, boughtAmount: Double? = nil, boughtAsset: BasePlatformAsset? = nil, price: Double? = nil, commission: Double? = nil, commissionCurrency: String? = nil) { 
        self.date = date
        self.soldAmount = soldAmount
        self.soldAsset = soldAsset
        self.boughtAmount = boughtAmount
        self.boughtAsset = boughtAsset
        self.price = price
        self.commission = commission
        self.commissionCurrency = commissionCurrency
    }

}
