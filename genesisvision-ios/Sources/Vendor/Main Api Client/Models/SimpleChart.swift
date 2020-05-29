//
// SimpleChart.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct SimpleChart: Codable {


    public var currency: Currency?

    public var color: String?

    public var chart: [SimpleChartPoint]?
    public init(currency: Currency? = nil, color: String? = nil, chart: [SimpleChartPoint]? = nil) { 
        self.currency = currency
        self.color = color
        self.chart = chart
    }

}
