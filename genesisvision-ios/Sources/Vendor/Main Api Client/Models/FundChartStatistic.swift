//
// FundChartStatistic.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct FundChartStatistic: Codable {


    public var investors: Int?

    public var creationDate: Date?

    public var balance: Double?

    public var profitPercent: Double?

    public var sharpeRatio: Double?

    public var sortinoRatio: Double?

    public var calmarRatio: Double?

    public var maxDrawdown: Double?
    public init(investors: Int? = nil, creationDate: Date? = nil, balance: Double? = nil, profitPercent: Double? = nil, sharpeRatio: Double? = nil, sortinoRatio: Double? = nil, calmarRatio: Double? = nil, maxDrawdown: Double? = nil) { 
        self.investors = investors
        self.creationDate = creationDate
        self.balance = balance
        self.profitPercent = profitPercent
        self.sharpeRatio = sharpeRatio
        self.sortinoRatio = sortinoRatio
        self.calmarRatio = calmarRatio
        self.maxDrawdown = maxDrawdown
    }

}