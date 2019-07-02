//
// WalletData.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class WalletData: Codable {

    public enum Currency: String, Codable { 
        case undefined = "Undefined"
        case gvt = "GVT"
        case eth = "ETH"
        case btc = "BTC"
        case ada = "ADA"
        case usdt = "USDT"
        case xrp = "XRP"
        case bch = "BCH"
        case ltc = "LTC"
        case doge = "DOGE"
        case bnb = "BNB"
        case usd = "USD"
        case eur = "EUR"
    }
    public enum CurrencyCcy: String, Codable { 
        case undefined = "Undefined"
        case gvt = "GVT"
        case eth = "ETH"
        case btc = "BTC"
        case ada = "ADA"
        case usdt = "USDT"
        case xrp = "XRP"
        case bch = "BCH"
        case ltc = "LTC"
        case doge = "DOGE"
        case bnb = "BNB"
        case usd = "USD"
        case eur = "EUR"
    }
    public var id: UUID?
    public var title: String?
    public var logo: String?
    public var rateToGVT: Double?
    public var isDepositEnabled: Bool?
    public var isWithdrawalEnabled: Bool?
    public var withdrawalCommission: Double?
    public var depositAddress: String?
    public var currency: Currency?
    public var available: Double?
    public var invested: Double?
    public var pending: Double?
    public var total: Double?
    public var currencyCcy: CurrencyCcy?
    public var availableCcy: Double?
    public var investedCcy: Double?
    public var pendingCcy: Double?
    public var totalCcy: Double?


    
    public init(id: UUID?, title: String?, logo: String?, rateToGVT: Double?, isDepositEnabled: Bool?, isWithdrawalEnabled: Bool?, withdrawalCommission: Double?, depositAddress: String?, currency: Currency?, available: Double?, invested: Double?, pending: Double?, total: Double?, currencyCcy: CurrencyCcy?, availableCcy: Double?, investedCcy: Double?, pendingCcy: Double?, totalCcy: Double?) {
        self.id = id
        self.title = title
        self.logo = logo
        self.rateToGVT = rateToGVT
        self.isDepositEnabled = isDepositEnabled
        self.isWithdrawalEnabled = isWithdrawalEnabled
        self.withdrawalCommission = withdrawalCommission
        self.depositAddress = depositAddress
        self.currency = currency
        self.available = available
        self.invested = invested
        self.pending = pending
        self.total = total
        self.currencyCcy = currencyCcy
        self.availableCcy = availableCcy
        self.investedCcy = investedCcy
        self.pendingCcy = pendingCcy
        self.totalCcy = totalCcy
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(title, forKey: "title")
        try container.encodeIfPresent(logo, forKey: "logo")
        try container.encodeIfPresent(rateToGVT, forKey: "rateToGVT")
        try container.encodeIfPresent(isDepositEnabled, forKey: "isDepositEnabled")
        try container.encodeIfPresent(isWithdrawalEnabled, forKey: "isWithdrawalEnabled")
        try container.encodeIfPresent(withdrawalCommission, forKey: "withdrawalCommission")
        try container.encodeIfPresent(depositAddress, forKey: "depositAddress")
        try container.encodeIfPresent(currency, forKey: "currency")
        try container.encodeIfPresent(available, forKey: "available")
        try container.encodeIfPresent(invested, forKey: "invested")
        try container.encodeIfPresent(pending, forKey: "pending")
        try container.encodeIfPresent(total, forKey: "total")
        try container.encodeIfPresent(currencyCcy, forKey: "currencyCcy")
        try container.encodeIfPresent(availableCcy, forKey: "availableCcy")
        try container.encodeIfPresent(investedCcy, forKey: "investedCcy")
        try container.encodeIfPresent(pendingCcy, forKey: "pendingCcy")
        try container.encodeIfPresent(totalCcy, forKey: "totalCcy")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        id = try container.decodeIfPresent(UUID.self, forKey: "id")
        title = try container.decodeIfPresent(String.self, forKey: "title")
        logo = try container.decodeIfPresent(String.self, forKey: "logo")
        rateToGVT = try container.decodeIfPresent(Double.self, forKey: "rateToGVT")
        isDepositEnabled = try container.decodeIfPresent(Bool.self, forKey: "isDepositEnabled")
        isWithdrawalEnabled = try container.decodeIfPresent(Bool.self, forKey: "isWithdrawalEnabled")
        withdrawalCommission = try container.decodeIfPresent(Double.self, forKey: "withdrawalCommission")
        depositAddress = try container.decodeIfPresent(String.self, forKey: "depositAddress")
        currency = try container.decodeIfPresent(Currency.self, forKey: "currency")
        available = try container.decodeIfPresent(Double.self, forKey: "available")
        invested = try container.decodeIfPresent(Double.self, forKey: "invested")
        pending = try container.decodeIfPresent(Double.self, forKey: "pending")
        total = try container.decodeIfPresent(Double.self, forKey: "total")
        currencyCcy = try container.decodeIfPresent(CurrencyCcy.self, forKey: "currencyCcy")
        availableCcy = try container.decodeIfPresent(Double.self, forKey: "availableCcy")
        investedCcy = try container.decodeIfPresent(Double.self, forKey: "investedCcy")
        pendingCcy = try container.decodeIfPresent(Double.self, forKey: "pendingCcy")
        totalCcy = try container.decodeIfPresent(Double.self, forKey: "totalCcy")
    }
}

