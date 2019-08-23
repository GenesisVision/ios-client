//
// FundDetailsListStatistic.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class FundDetailsListStatistic: Codable {

    public var balanceGVT: AmountWithCurrency?
    public var balanceSecondary: AmountWithCurrency?
    public var balance: AmountWithCurrency?
    public var profitPercent: Double?
    public var drawdownPercent: Double?
    public var investorsCount: Int?


    
    public init(balanceGVT: AmountWithCurrency?, balanceSecondary: AmountWithCurrency?, balance: AmountWithCurrency?, profitPercent: Double?, drawdownPercent: Double?, investorsCount: Int?) {
        self.balanceGVT = balanceGVT
        self.balanceSecondary = balanceSecondary
        self.balance = balance
        self.profitPercent = profitPercent
        self.drawdownPercent = drawdownPercent
        self.investorsCount = investorsCount
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(balanceGVT, forKey: "balanceGVT")
        try container.encodeIfPresent(balanceSecondary, forKey: "balanceSecondary")
        try container.encodeIfPresent(balance, forKey: "balance")
        try container.encodeIfPresent(profitPercent, forKey: "profitPercent")
        try container.encodeIfPresent(drawdownPercent, forKey: "drawdownPercent")
        try container.encodeIfPresent(investorsCount, forKey: "investorsCount")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        balanceGVT = try container.decodeIfPresent(AmountWithCurrency.self, forKey: "balanceGVT")
        balanceSecondary = try container.decodeIfPresent(AmountWithCurrency.self, forKey: "balanceSecondary")
        balance = try container.decodeIfPresent(AmountWithCurrency.self, forKey: "balance")
        profitPercent = try container.decodeIfPresent(Double.self, forKey: "profitPercent")
        drawdownPercent = try container.decodeIfPresent(Double.self, forKey: "drawdownPercent")
        investorsCount = try container.decodeIfPresent(Int.self, forKey: "investorsCount")
    }
}

