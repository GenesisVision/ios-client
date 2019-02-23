//
// MultiWalletExternalTransaction.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class MultiWalletExternalTransaction: Codable {

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
    public enum ModelType: String, Codable { 
        case all = "All"
        case deposit = "Deposit"
        case withdrawal = "Withdrawal"
    }
    public var id: UUID?
    public var currency: Currency?
    public var logo: String?
    public var date: Date?
    public var amount: Double?
    public var type: ModelType?
    public var status: String?
    public var isEnableActions: Bool?
    public var statusUrl: String?


    
    public init(id: UUID?, currency: Currency?, logo: String?, date: Date?, amount: Double?, type: ModelType?, status: String?, isEnableActions: Bool?, statusUrl: String?) {
        self.id = id
        self.currency = currency
        self.logo = logo
        self.date = date
        self.amount = amount
        self.type = type
        self.status = status
        self.isEnableActions = isEnableActions
        self.statusUrl = statusUrl
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(currency, forKey: "currency")
        try container.encodeIfPresent(logo, forKey: "logo")
        try container.encodeIfPresent(date, forKey: "date")
        try container.encodeIfPresent(amount, forKey: "amount")
        try container.encodeIfPresent(type, forKey: "type")
        try container.encodeIfPresent(status, forKey: "status")
        try container.encodeIfPresent(isEnableActions, forKey: "isEnableActions")
        try container.encodeIfPresent(statusUrl, forKey: "statusUrl")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        id = try container.decodeIfPresent(UUID.self, forKey: "id")
        currency = try container.decodeIfPresent(Currency.self, forKey: "currency")
        logo = try container.decodeIfPresent(String.self, forKey: "logo")
        date = try container.decodeIfPresent(Date.self, forKey: "date")
        amount = try container.decodeIfPresent(Double.self, forKey: "amount")
        type = try container.decodeIfPresent(ModelType.self, forKey: "type")
        status = try container.decodeIfPresent(String.self, forKey: "status")
        isEnableActions = try container.decodeIfPresent(Bool.self, forKey: "isEnableActions")
        statusUrl = try container.decodeIfPresent(String.self, forKey: "statusUrl")
    }
}

