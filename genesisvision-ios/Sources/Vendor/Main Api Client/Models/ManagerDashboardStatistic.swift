//
// ManagerDashboardStatistic.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class ManagerDashboardStatistic: Codable {

    public var programBalances: [ProgramBalances]?
    public var investorsCount: Int?
    public var investorsFund: Double?
    public var endOfNextPeriod: EndOfNextPeriod?
    public var totalProfit: Double?
    public var fundChart: [ManagerFundChart]?
    public var profitChart: [ManagerProfitChart]?


    
    public init(programBalances: [ProgramBalances]?, investorsCount: Int?, investorsFund: Double?, endOfNextPeriod: EndOfNextPeriod?, totalProfit: Double?, fundChart: [ManagerFundChart]?, profitChart: [ManagerProfitChart]?) {
        self.programBalances = programBalances
        self.investorsCount = investorsCount
        self.investorsFund = investorsFund
        self.endOfNextPeriod = endOfNextPeriod
        self.totalProfit = totalProfit
        self.fundChart = fundChart
        self.profitChart = profitChart
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(programBalances, forKey: "programBalances")
        try container.encodeIfPresent(investorsCount, forKey: "investorsCount")
        try container.encodeIfPresent(investorsFund, forKey: "investorsFund")
        try container.encodeIfPresent(endOfNextPeriod, forKey: "endOfNextPeriod")
        try container.encodeIfPresent(totalProfit, forKey: "totalProfit")
        try container.encodeIfPresent(fundChart, forKey: "fundChart")
        try container.encodeIfPresent(profitChart, forKey: "profitChart")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        programBalances = try container.decodeIfPresent([ProgramBalances].self, forKey: "programBalances")
        investorsCount = try container.decodeIfPresent(Int.self, forKey: "investorsCount")
        investorsFund = try container.decodeIfPresent(Double.self, forKey: "investorsFund")
        endOfNextPeriod = try container.decodeIfPresent(EndOfNextPeriod.self, forKey: "endOfNextPeriod")
        totalProfit = try container.decodeIfPresent(Double.self, forKey: "totalProfit")
        fundChart = try container.decodeIfPresent([ManagerFundChart].self, forKey: "fundChart")
        profitChart = try container.decodeIfPresent([ManagerProfitChart].self, forKey: "profitChart")
    }
}

