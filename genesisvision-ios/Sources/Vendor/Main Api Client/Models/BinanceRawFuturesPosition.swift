//
// BinanceRawFuturesPosition.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawFuturesPosition: Codable {


    public var entryPrice: Double?

    public var marginType: BinanceFuturesMarginType?

    public var isAutoAddMargin: Bool?

    public var isolatedMargin: Double?

    public var leverage: Int?

    public var liquidationPrice: Double?

    public var markPrice: Double?

    public var maxNotionalValue: String?

    public var quantity: Double?

    public var symbol: String?

    public var unrealizedPnL: Double?

    public var positionSide: BinancePositionSide?
    public init(entryPrice: Double? = nil, marginType: BinanceFuturesMarginType? = nil, isAutoAddMargin: Bool? = nil, isolatedMargin: Double? = nil, leverage: Int? = nil, liquidationPrice: Double? = nil, markPrice: Double? = nil, maxNotionalValue: String? = nil, quantity: Double? = nil, symbol: String? = nil, unrealizedPnL: Double? = nil, positionSide: BinancePositionSide? = nil) { 
        self.entryPrice = entryPrice
        self.marginType = marginType
        self.isAutoAddMargin = isAutoAddMargin
        self.isolatedMargin = isolatedMargin
        self.leverage = leverage
        self.liquidationPrice = liquidationPrice
        self.markPrice = markPrice
        self.maxNotionalValue = maxNotionalValue
        self.quantity = quantity
        self.symbol = symbol
        self.unrealizedPnL = unrealizedPnL
        self.positionSide = positionSide
    }

}
