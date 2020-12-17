//
// BinanceRawRecentTrade.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawRecentTrade: Codable {


    public var orderId: Int64?

    public var price: Double?

    public var baseQuantity: Double?

    public var quoteQuantity: Double?

    public var tradeTime: Date?

    public var buyerIsMaker: Bool?

    public var isBestMatch: Bool?
    public init(orderId: Int64? = nil, price: Double? = nil, baseQuantity: Double? = nil, quoteQuantity: Double? = nil, tradeTime: Date? = nil, buyerIsMaker: Bool? = nil, isBestMatch: Bool? = nil) { 
        self.orderId = orderId
        self.price = price
        self.baseQuantity = baseQuantity
        self.quoteQuantity = quoteQuantity
        self.tradeTime = tradeTime
        self.buyerIsMaker = buyerIsMaker
        self.isBestMatch = isBestMatch
    }

}