//
// BinanceRawSymbol.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawSymbol: Codable {


    public var name: String?

    public var status: BinanceRawSymbolStatus?

    public var baseAsset: String?

    public var baseAssetPrecision: Int?

    public var quoteAsset: String?

    public var quoteAssetPrecision: Int?

    public var orderTypes: [BinanceRawOrderType]?

    public var iceBergAllowed: Bool?

    public var isSpotTradingAllowed: Bool?

    public var isMarginTradingAllowed: Bool?

    public var ocoAllowed: Bool?

    public var quoteOrderQuantityMarketAllowed: Bool?

    public var baseCommissionPrecision: Int?

    public var quoteCommissionPrecision: Int?

    public var permissions: [BinanceRawAccountType]?

    public var iceBergPartsFilter: BinanceRawSymbolIcebergPartsFilter?

    public var lotSizeFilter: BinanceRawSymbolLotSizeFilter?

    public var marketLotSizeFilter: BinanceRawSymbolMarketLotSizeFilter?

    public var maxOrdersFilter: BinanceRawSymbolMaxOrdersFilter?

    public var maxAlgorithmicOrdersFilter: BinanceRawSymbolMaxAlgorithmicOrdersFilter?

    public var minNotionalFilter: BinanceRawSymbolMinNotionalFilter?

    public var priceFilter: BinanceRawSymbolPriceFilter?

    public var pricePercentFilter: BinanceRawSymbolPercentPriceFilter?
    public init(name: String? = nil, status: BinanceRawSymbolStatus? = nil, baseAsset: String? = nil, baseAssetPrecision: Int? = nil, quoteAsset: String? = nil, quoteAssetPrecision: Int? = nil, orderTypes: [BinanceRawOrderType]? = nil, iceBergAllowed: Bool? = nil, isSpotTradingAllowed: Bool? = nil, isMarginTradingAllowed: Bool? = nil, ocoAllowed: Bool? = nil, quoteOrderQuantityMarketAllowed: Bool? = nil, baseCommissionPrecision: Int? = nil, quoteCommissionPrecision: Int? = nil, permissions: [BinanceRawAccountType]? = nil, iceBergPartsFilter: BinanceRawSymbolIcebergPartsFilter? = nil, lotSizeFilter: BinanceRawSymbolLotSizeFilter? = nil, marketLotSizeFilter: BinanceRawSymbolMarketLotSizeFilter? = nil, maxOrdersFilter: BinanceRawSymbolMaxOrdersFilter? = nil, maxAlgorithmicOrdersFilter: BinanceRawSymbolMaxAlgorithmicOrdersFilter? = nil, minNotionalFilter: BinanceRawSymbolMinNotionalFilter? = nil, priceFilter: BinanceRawSymbolPriceFilter? = nil, pricePercentFilter: BinanceRawSymbolPercentPriceFilter? = nil) { 
        self.name = name
        self.status = status
        self.baseAsset = baseAsset
        self.baseAssetPrecision = baseAssetPrecision
        self.quoteAsset = quoteAsset
        self.quoteAssetPrecision = quoteAssetPrecision
        self.orderTypes = orderTypes
        self.iceBergAllowed = iceBergAllowed
        self.isSpotTradingAllowed = isSpotTradingAllowed
        self.isMarginTradingAllowed = isMarginTradingAllowed
        self.ocoAllowed = ocoAllowed
        self.quoteOrderQuantityMarketAllowed = quoteOrderQuantityMarketAllowed
        self.baseCommissionPrecision = baseCommissionPrecision
        self.quoteCommissionPrecision = quoteCommissionPrecision
        self.permissions = permissions
        self.iceBergPartsFilter = iceBergPartsFilter
        self.lotSizeFilter = lotSizeFilter
        self.marketLotSizeFilter = marketLotSizeFilter
        self.maxOrdersFilter = maxOrdersFilter
        self.maxAlgorithmicOrdersFilter = maxAlgorithmicOrdersFilter
        self.minNotionalFilter = minNotionalFilter
        self.priceFilter = priceFilter
        self.pricePercentFilter = pricePercentFilter
    }

}
