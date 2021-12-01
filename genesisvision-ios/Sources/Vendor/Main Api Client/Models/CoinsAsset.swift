//
// CoinsAsset.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct CoinsAsset: Codable {


    public var _id: UUID?

    public var name: String?

    public var asset: String?

    public var _description: String?

    public var logoUrl: String?

    public var color: String?

    public var url: String?

    public var provider: AssetProvider?

    public var price: Double?

    public var change24Percent: Double?

    public var totalVolume: Double?

    public var marketCap: Double?

    public var details: AssetInfo?

    public var chart: TickerChart?

    public var isFavorite: Bool?

    public var isTransferred: Bool?

    public var oefAssetId: UUID?

    public var amount: Double?

    public var averagePrice: Double?

    public var profitCurrent: Double?

    public var total: Double?
    public init(_id: UUID? = nil, name: String? = nil, asset: String? = nil, _description: String? = nil, logoUrl: String? = nil, color: String? = nil, url: String? = nil, provider: AssetProvider? = nil, price: Double? = nil, change24Percent: Double? = nil, totalVolume: Double? = nil, marketCap: Double? = nil, details: AssetInfo? = nil, chart: TickerChart? = nil, isFavorite: Bool? = nil, isTransferred: Bool? = nil, oefAssetId: UUID? = nil, amount: Double? = nil, averagePrice: Double? = nil, profitCurrent: Double? = nil, total: Double? = nil) { 
        self._id = _id
        self.name = name
        self.asset = asset
        self._description = _description
        self.logoUrl = logoUrl
        self.color = color
        self.url = url
        self.provider = provider
        self.price = price
        self.change24Percent = change24Percent
        self.totalVolume = totalVolume
        self.marketCap = marketCap
        self.details = details
        self.chart = chart
        self.isFavorite = isFavorite
        self.isTransferred = isTransferred
        self.oefAssetId = oefAssetId
        self.amount = amount
        self.averagePrice = averagePrice
        self.profitCurrent = profitCurrent
        self.total = total
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case name
        case asset
        case _description = "description"
        case logoUrl
        case color
        case url
        case provider
        case price
        case change24Percent
        case totalVolume
        case marketCap
        case details
        case chart
        case isFavorite
        case isTransferred
        case oefAssetId
        case amount
        case averagePrice
        case profitCurrent
        case total
    }

}
