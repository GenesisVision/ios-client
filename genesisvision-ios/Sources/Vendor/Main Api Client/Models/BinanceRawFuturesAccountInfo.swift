//
// BinanceRawFuturesAccountInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct BinanceRawFuturesAccountInfo: Codable {


    public var canDeposit: Bool?

    public var canTrade: Bool?

    public var canWithdraw: Bool?

    public var feeTier: Int?

    public var maxWithdrawAmount: Double?

    public var totalInitialMargin: Double?

    public var totalMaintMargin: Double?

    public var totalMarginBalance: Double?

    public var totalOpenOrderInitialMargin: Double?

    public var totalPositionInitialMargin: Double?

    public var totalUnrealizedProfit: Double?

    public var totalWalletBalance: Double?

    public var totalCrossWalletBalance: Double?

    public var totalCrossUnPnl: Double?

    public var availableBalance: Double?

    public var updateTime: Date?

    public var assets: [BinanceRawFuturesAccountAsset]?

    public var positions: [BinanceRawFuturesPositionInfo]?
    public init(canDeposit: Bool? = nil, canTrade: Bool? = nil, canWithdraw: Bool? = nil, feeTier: Int? = nil, maxWithdrawAmount: Double? = nil, totalInitialMargin: Double? = nil, totalMaintMargin: Double? = nil, totalMarginBalance: Double? = nil, totalOpenOrderInitialMargin: Double? = nil, totalPositionInitialMargin: Double? = nil, totalUnrealizedProfit: Double? = nil, totalWalletBalance: Double? = nil, totalCrossWalletBalance: Double? = nil, totalCrossUnPnl: Double? = nil, availableBalance: Double? = nil, updateTime: Date? = nil, assets: [BinanceRawFuturesAccountAsset]? = nil, positions: [BinanceRawFuturesPositionInfo]? = nil) { 
        self.canDeposit = canDeposit
        self.canTrade = canTrade
        self.canWithdraw = canWithdraw
        self.feeTier = feeTier
        self.maxWithdrawAmount = maxWithdrawAmount
        self.totalInitialMargin = totalInitialMargin
        self.totalMaintMargin = totalMaintMargin
        self.totalMarginBalance = totalMarginBalance
        self.totalOpenOrderInitialMargin = totalOpenOrderInitialMargin
        self.totalPositionInitialMargin = totalPositionInitialMargin
        self.totalUnrealizedProfit = totalUnrealizedProfit
        self.totalWalletBalance = totalWalletBalance
        self.totalCrossWalletBalance = totalCrossWalletBalance
        self.totalCrossUnPnl = totalCrossUnPnl
        self.availableBalance = availableBalance
        self.updateTime = updateTime
        self.assets = assets
        self.positions = positions
    }

}
