//
// BinanceRawOrderBook.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawOrderBook: Codable {


    public var symbol: String?

    public var lastUpdateId: Int64?

    public var bids: [BinanceRawOrderBookEntry]?

    public var asks: [BinanceRawOrderBookEntry]?
    public init(symbol: String? = nil, lastUpdateId: Int64? = nil, bids: [BinanceRawOrderBookEntry]? = nil, asks: [BinanceRawOrderBookEntry]? = nil) { 
        self.symbol = symbol
        self.lastUpdateId = lastUpdateId
        self.bids = bids
        self.asks = asks
    }

}
