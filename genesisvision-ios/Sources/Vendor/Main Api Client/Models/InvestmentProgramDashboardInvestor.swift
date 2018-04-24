//
// InvestmentProgramDashboardInvestor.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class InvestmentProgramDashboardInvestor: Codable {

    public enum Currency: String, Codable { 
        case undefined = "Undefined"
        case gvt = "GVT"
        case eth = "ETH"
        case btc = "BTC"
        case ada = "ADA"
        case usd = "USD"
        case eur = "EUR"
    }
    public enum ProfitTotalChange: String, Codable { 
        case unchanged = "Unchanged"
        case up = "Up"
        case down = "Down"
    }
    public var id: UUID?
    public var title: String?
    public var description: String?
    public var level: Int?
    public var logo: String?
    public var balance: Double?
    public var currency: Currency?
    public var investedAmount: Double?
    public var profitFromProgram: Double?
    public var investedTokens: Double?
    public var tradesCount: Int?
    public var investorsCount: Int?
    public var periodDuration: Int?
    public var startOfPeriod: Date?
    public var endOfPeriod: Date?
    public var profitAvg: Double?
    public var profitTotal: Double?
    public var profitAvgPercent: Double?
    public var profitTotalPercent: Double?
    public var profitTotalChange: ProfitTotalChange?
    public var availableInvestment: Double?
    public var feeSuccess: Double?
    public var feeManagement: Double?
    public var isEnabled: Bool?
    public var isArchived: Bool?
    public var chart: [Chart]?
    public var equityChart: [ChartByDate]?
    public var freeTokens: FreeTokens?
    public var manager: ProfilePublicViewModel?
    public var token: Token?
    public var hasNewRequests: Bool?
    public var isHistoryEnable: Bool?
    public var isInvestEnable: Bool?
    public var isWithdrawEnable: Bool?
    public var isOwnProgram: Bool?
    public var isFavorite: Bool?


    
    public init(id: UUID?, title: String?, description: String?, level: Int?, logo: String?, balance: Double?, currency: Currency?, investedAmount: Double?, profitFromProgram: Double?, investedTokens: Double?, tradesCount: Int?, investorsCount: Int?, periodDuration: Int?, startOfPeriod: Date?, endOfPeriod: Date?, profitAvg: Double?, profitTotal: Double?, profitAvgPercent: Double?, profitTotalPercent: Double?, profitTotalChange: ProfitTotalChange?, availableInvestment: Double?, feeSuccess: Double?, feeManagement: Double?, isEnabled: Bool?, isArchived: Bool?, chart: [Chart]?, equityChart: [ChartByDate]?, freeTokens: FreeTokens?, manager: ProfilePublicViewModel?, token: Token?, hasNewRequests: Bool?, isHistoryEnable: Bool?, isInvestEnable: Bool?, isWithdrawEnable: Bool?, isOwnProgram: Bool?, isFavorite: Bool?) {
        self.id = id
        self.title = title
        self.description = description
        self.level = level
        self.logo = logo
        self.balance = balance
        self.currency = currency
        self.investedAmount = investedAmount
        self.profitFromProgram = profitFromProgram
        self.investedTokens = investedTokens
        self.tradesCount = tradesCount
        self.investorsCount = investorsCount
        self.periodDuration = periodDuration
        self.startOfPeriod = startOfPeriod
        self.endOfPeriod = endOfPeriod
        self.profitAvg = profitAvg
        self.profitTotal = profitTotal
        self.profitAvgPercent = profitAvgPercent
        self.profitTotalPercent = profitTotalPercent
        self.profitTotalChange = profitTotalChange
        self.availableInvestment = availableInvestment
        self.feeSuccess = feeSuccess
        self.feeManagement = feeManagement
        self.isEnabled = isEnabled
        self.isArchived = isArchived
        self.chart = chart
        self.equityChart = equityChart
        self.freeTokens = freeTokens
        self.manager = manager
        self.token = token
        self.hasNewRequests = hasNewRequests
        self.isHistoryEnable = isHistoryEnable
        self.isInvestEnable = isInvestEnable
        self.isWithdrawEnable = isWithdrawEnable
        self.isOwnProgram = isOwnProgram
        self.isFavorite = isFavorite
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(title, forKey: "title")
        try container.encodeIfPresent(description, forKey: "description")
        try container.encodeIfPresent(level, forKey: "level")
        try container.encodeIfPresent(logo, forKey: "logo")
        try container.encodeIfPresent(balance, forKey: "balance")
        try container.encodeIfPresent(currency, forKey: "currency")
        try container.encodeIfPresent(investedAmount, forKey: "investedAmount")
        try container.encodeIfPresent(profitFromProgram, forKey: "profitFromProgram")
        try container.encodeIfPresent(investedTokens, forKey: "investedTokens")
        try container.encodeIfPresent(tradesCount, forKey: "tradesCount")
        try container.encodeIfPresent(investorsCount, forKey: "investorsCount")
        try container.encodeIfPresent(periodDuration, forKey: "periodDuration")
        try container.encodeIfPresent(startOfPeriod, forKey: "startOfPeriod")
        try container.encodeIfPresent(endOfPeriod, forKey: "endOfPeriod")
        try container.encodeIfPresent(profitAvg, forKey: "profitAvg")
        try container.encodeIfPresent(profitTotal, forKey: "profitTotal")
        try container.encodeIfPresent(profitAvgPercent, forKey: "profitAvgPercent")
        try container.encodeIfPresent(profitTotalPercent, forKey: "profitTotalPercent")
        try container.encodeIfPresent(profitTotalChange, forKey: "profitTotalChange")
        try container.encodeIfPresent(availableInvestment, forKey: "availableInvestment")
        try container.encodeIfPresent(feeSuccess, forKey: "feeSuccess")
        try container.encodeIfPresent(feeManagement, forKey: "feeManagement")
        try container.encodeIfPresent(isEnabled, forKey: "isEnabled")
        try container.encodeIfPresent(isArchived, forKey: "isArchived")
        try container.encodeIfPresent(chart, forKey: "chart")
        try container.encodeIfPresent(equityChart, forKey: "equityChart")
        try container.encodeIfPresent(freeTokens, forKey: "freeTokens")
        try container.encodeIfPresent(manager, forKey: "manager")
        try container.encodeIfPresent(token, forKey: "token")
        try container.encodeIfPresent(hasNewRequests, forKey: "hasNewRequests")
        try container.encodeIfPresent(isHistoryEnable, forKey: "isHistoryEnable")
        try container.encodeIfPresent(isInvestEnable, forKey: "isInvestEnable")
        try container.encodeIfPresent(isWithdrawEnable, forKey: "isWithdrawEnable")
        try container.encodeIfPresent(isOwnProgram, forKey: "isOwnProgram")
        try container.encodeIfPresent(isFavorite, forKey: "isFavorite")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        id = try container.decodeIfPresent(UUID.self, forKey: "id")
        title = try container.decodeIfPresent(String.self, forKey: "title")
        description = try container.decodeIfPresent(String.self, forKey: "description")
        level = try container.decodeIfPresent(Int.self, forKey: "level")
        logo = try container.decodeIfPresent(String.self, forKey: "logo")
        balance = try container.decodeIfPresent(Double.self, forKey: "balance")
        currency = try container.decodeIfPresent(Currency.self, forKey: "currency")
        investedAmount = try container.decodeIfPresent(Double.self, forKey: "investedAmount")
        profitFromProgram = try container.decodeIfPresent(Double.self, forKey: "profitFromProgram")
        investedTokens = try container.decodeIfPresent(Double.self, forKey: "investedTokens")
        tradesCount = try container.decodeIfPresent(Int.self, forKey: "tradesCount")
        investorsCount = try container.decodeIfPresent(Int.self, forKey: "investorsCount")
        periodDuration = try container.decodeIfPresent(Int.self, forKey: "periodDuration")
        startOfPeriod = try container.decodeIfPresent(Date.self, forKey: "startOfPeriod")
        endOfPeriod = try container.decodeIfPresent(Date.self, forKey: "endOfPeriod")
        profitAvg = try container.decodeIfPresent(Double.self, forKey: "profitAvg")
        profitTotal = try container.decodeIfPresent(Double.self, forKey: "profitTotal")
        profitAvgPercent = try container.decodeIfPresent(Double.self, forKey: "profitAvgPercent")
        profitTotalPercent = try container.decodeIfPresent(Double.self, forKey: "profitTotalPercent")
        profitTotalChange = try container.decodeIfPresent(ProfitTotalChange.self, forKey: "profitTotalChange")
        availableInvestment = try container.decodeIfPresent(Double.self, forKey: "availableInvestment")
        feeSuccess = try container.decodeIfPresent(Double.self, forKey: "feeSuccess")
        feeManagement = try container.decodeIfPresent(Double.self, forKey: "feeManagement")
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: "isEnabled")
        isArchived = try container.decodeIfPresent(Bool.self, forKey: "isArchived")
        chart = try container.decodeIfPresent([Chart].self, forKey: "chart")
        equityChart = try container.decodeIfPresent([ChartByDate].self, forKey: "equityChart")
        freeTokens = try container.decodeIfPresent(FreeTokens.self, forKey: "freeTokens")
        manager = try container.decodeIfPresent(ProfilePublicViewModel.self, forKey: "manager")
        token = try container.decodeIfPresent(Token.self, forKey: "token")
        hasNewRequests = try container.decodeIfPresent(Bool.self, forKey: "hasNewRequests")
        isHistoryEnable = try container.decodeIfPresent(Bool.self, forKey: "isHistoryEnable")
        isInvestEnable = try container.decodeIfPresent(Bool.self, forKey: "isInvestEnable")
        isWithdrawEnable = try container.decodeIfPresent(Bool.self, forKey: "isWithdrawEnable")
        isOwnProgram = try container.decodeIfPresent(Bool.self, forKey: "isOwnProgram")
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: "isFavorite")
    }
}

