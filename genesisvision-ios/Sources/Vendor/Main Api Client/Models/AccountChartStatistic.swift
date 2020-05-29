//
// AccountChartStatistic.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct AccountChartStatistic: Codable {


    public var tradingVolume: Double?

    public var trades: Int?

    public var successTradesPercent: Double?

    public var profitFactor: Double?

    public var balance: Double?

    public var profitPercent: Double?

    public var sharpeRatio: Double?

    public var sortinoRatio: Double?

    public var calmarRatio: Double?

    public var maxDrawdown: Double?
    public init(tradingVolume: Double? = nil, trades: Int? = nil, successTradesPercent: Double? = nil, profitFactor: Double? = nil, balance: Double? = nil, profitPercent: Double? = nil, sharpeRatio: Double? = nil, sortinoRatio: Double? = nil, calmarRatio: Double? = nil, maxDrawdown: Double? = nil) { 
        self.tradingVolume = tradingVolume
        self.trades = trades
        self.successTradesPercent = successTradesPercent
        self.profitFactor = profitFactor
        self.balance = balance
        self.profitPercent = profitPercent
        self.sharpeRatio = sharpeRatio
        self.sortinoRatio = sortinoRatio
        self.calmarRatio = calmarRatio
        self.maxDrawdown = maxDrawdown
    }

}
