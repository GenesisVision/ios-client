//
// BinanceRawPrice.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawPrice: Codable {


    public var symbol: String?

    public var price: Double?

    public var timestamp: Date?
    public init(symbol: String? = nil, price: Double? = nil, timestamp: Date? = nil) { 
        self.symbol = symbol
        self.price = price
        self.timestamp = timestamp
    }

}
