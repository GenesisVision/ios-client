//
// ProgramProfitPercentCharts.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

/** For programs and follows */
public struct ProgramProfitPercentCharts: Codable {


    public var statistic: ProgramChartStatistic?

    public var charts: [SimpleChart]?
    public init(statistic: ProgramChartStatistic? = nil, charts: [SimpleChart]? = nil) { 
        self.statistic = statistic
        self.charts = charts
    }

}
