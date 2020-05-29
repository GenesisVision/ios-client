//
// FundBalanceChart.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct FundBalanceChart: Codable {


    public var balance: Double?

    public var color: String?

    public var chart: [BalanceChartPoint]?
    public init(balance: Double? = nil, color: String? = nil, chart: [BalanceChartPoint]? = nil) { 
        self.balance = balance
        self.color = color
        self.chart = chart
    }

}
