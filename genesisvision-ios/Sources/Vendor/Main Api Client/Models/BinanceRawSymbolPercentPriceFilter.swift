//
// BinanceRawSymbolPercentPriceFilter.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawSymbolPercentPriceFilter: Codable {


    public var filterType: BinanceRawSymbolFilterType?

    public var multiplierUp: Double?

    public var multiplierDown: Double?

    public var averagePriceMinutes: Int?
    public init(filterType: BinanceRawSymbolFilterType? = nil, multiplierUp: Double? = nil, multiplierDown: Double? = nil, averagePriceMinutes: Int? = nil) { 
        self.filterType = filterType
        self.multiplierUp = multiplierUp
        self.multiplierDown = multiplierDown
        self.averagePriceMinutes = averagePriceMinutes
    }

}
