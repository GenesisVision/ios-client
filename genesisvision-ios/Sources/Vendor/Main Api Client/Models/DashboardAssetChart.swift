//
// DashboardAssetChart.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct DashboardAssetChart: Codable {


    public var assetId: UUID?

    public var color: String?

    public var chart: [SimpleChartPoint]?
    public init(assetId: UUID? = nil, color: String? = nil, chart: [SimpleChartPoint]? = nil) { 
        self.assetId = assetId
        self.color = color
        self.chart = chart
    }

}