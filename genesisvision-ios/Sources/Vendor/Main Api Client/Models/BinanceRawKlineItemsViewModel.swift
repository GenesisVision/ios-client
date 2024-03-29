//
// BinanceRawKlineItemsViewModel.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawKlineItemsViewModel: Codable {


    public var items: [BinanceRawKline]?

    public var total: Int?
    public init(items: [BinanceRawKline]? = nil, total: Int? = nil) { 
        self.items = items
        self.total = total
    }

}
