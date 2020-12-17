//
// BinanceRawSymbolMaxPositionFilter.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawSymbolMaxPositionFilter: Codable {


    public var filterType: BinanceSymbolFilterType?

    public var maxPosition: Double?
    public init(filterType: BinanceSymbolFilterType? = nil, maxPosition: Double? = nil) { 
        self.filterType = filterType
        self.maxPosition = maxPosition
    }

}