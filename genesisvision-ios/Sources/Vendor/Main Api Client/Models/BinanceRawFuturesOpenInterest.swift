//
// BinanceRawFuturesOpenInterest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawFuturesOpenInterest: Codable {


    public var symbol: String?

    public var openInterest: Double?

    public var timestamp: Date?
    public init(symbol: String? = nil, openInterest: Double? = nil, timestamp: Date? = nil) { 
        self.symbol = symbol
        self.openInterest = openInterest
        self.timestamp = timestamp
    }

}