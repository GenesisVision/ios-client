//
// WalletInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class WalletInfo: Codable {

    public enum Currency: String, Codable { 
        case undefined = "Undefined"
        case gvt = "GVT"
        case eth = "ETH"
        case btc = "BTC"
        case ada = "ADA"
        case usdt = "USDT"
        case usd = "USD"
        case eur = "EUR"
    }
    public var currency: Currency?
    public var address: String?
    public var rateToGVT: Double?
    public var description: String?
    public var logo: String?


    
    public init(currency: Currency?, address: String?, rateToGVT: Double?, description: String?, logo: String?) {
        self.currency = currency
        self.address = address
        self.rateToGVT = rateToGVT
        self.description = description
        self.logo = logo
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(currency, forKey: "currency")
        try container.encodeIfPresent(address, forKey: "address")
        try container.encodeIfPresent(rateToGVT, forKey: "rateToGVT")
        try container.encodeIfPresent(description, forKey: "description")
        try container.encodeIfPresent(logo, forKey: "logo")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        currency = try container.decodeIfPresent(Currency.self, forKey: "currency")
        address = try container.decodeIfPresent(String.self, forKey: "address")
        rateToGVT = try container.decodeIfPresent(Double.self, forKey: "rateToGVT")
        description = try container.decodeIfPresent(String.self, forKey: "description")
        logo = try container.decodeIfPresent(String.self, forKey: "logo")
    }
}

