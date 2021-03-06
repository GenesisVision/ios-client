//
// BinanceRawFuturesSymbolPercentPriceFilter.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawFuturesSymbolPercentPriceFilter: Codable {


    public var filterType: BinanceSymbolFilterType?

    public var multiplierUp: Double?

    public var multiplierDown: Double?

    public var multiplierDecimal: Int?
    public init(filterType: BinanceSymbolFilterType? = nil, multiplierUp: Double? = nil, multiplierDown: Double? = nil, multiplierDecimal: Int? = nil) { 
        self.filterType = filterType
        self.multiplierUp = multiplierUp
        self.multiplierDown = multiplierDown
        self.multiplierDecimal = multiplierDecimal
    }

}
