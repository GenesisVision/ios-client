//
// BinanceRawFuturesPositionInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawFuturesPositionInfo: Codable {


    public var maxNotional: Double?

    public var initialMargin: Double?

    public var maintMargin: Double?

    public var positionInitialMargin: Double?

    public var openOrderInitialMargin: Double?

    public var isolated: Bool?

    public var quantity: Double?

    public var updateTime: Date?

    public var symbol: String?

    public var entryPrice: Double?

    public var leverage: Int?

    public var unrealizedPnl: Double?

    public var positionSide: BinancePositionSide?
    public init(maxNotional: Double? = nil, initialMargin: Double? = nil, maintMargin: Double? = nil, positionInitialMargin: Double? = nil, openOrderInitialMargin: Double? = nil, isolated: Bool? = nil, quantity: Double? = nil, updateTime: Date? = nil, symbol: String? = nil, entryPrice: Double? = nil, leverage: Int? = nil, unrealizedPnl: Double? = nil, positionSide: BinancePositionSide? = nil) { 
        self.maxNotional = maxNotional
        self.initialMargin = initialMargin
        self.maintMargin = maintMargin
        self.positionInitialMargin = positionInitialMargin
        self.openOrderInitialMargin = openOrderInitialMargin
        self.isolated = isolated
        self.quantity = quantity
        self.updateTime = updateTime
        self.symbol = symbol
        self.entryPrice = entryPrice
        self.leverage = leverage
        self.unrealizedPnl = unrealizedPnl
        self.positionSide = positionSide
    }

}