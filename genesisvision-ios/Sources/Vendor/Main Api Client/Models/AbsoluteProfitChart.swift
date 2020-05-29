//
// AbsoluteProfitChart.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct AbsoluteProfitChart: Codable {


    public var profit: Double?

    public var chart: [SimpleChartPoint]?
    public init(profit: Double? = nil, chart: [SimpleChartPoint]? = nil) { 
        self.profit = profit
        self.chart = chart
    }

}
