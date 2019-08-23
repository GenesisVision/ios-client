//
// BrokerAccountType.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



open class BrokerAccountType: Codable {

    public enum ModelType: String, Codable { 
        case undefined = "Undefined"
        case metaTrader4 = "MetaTrader4"
        case metaTrader5 = "MetaTrader5"
        case ninjaTrader = "NinjaTrader"
        case ctrader = "cTrader"
        case rumus = "Rumus"
        case metastock = "Metastock"
        case idex = "IDEX"
        case huobi = "Huobi"
        case exante = "Exante"
        case binanceExchange = "BinanceExchange"
    }
    public var id: UUID?
    public var name: String?
    public var description: String?
    public var type: ModelType?
    public var leverages: [Int]?
    public var currencies: [String]?
    public var minimumDepositsAmount: [String:Double]?
    public var isForex: Bool?
    public var isSignalsAvailable: Bool?


    
    public init(id: UUID?, name: String?, description: String?, type: ModelType?, leverages: [Int]?, currencies: [String]?, minimumDepositsAmount: [String:Double]?, isForex: Bool?, isSignalsAvailable: Bool?) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.leverages = leverages
        self.currencies = currencies
        self.minimumDepositsAmount = minimumDepositsAmount
        self.isForex = isForex
        self.isSignalsAvailable = isSignalsAvailable
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(name, forKey: "name")
        try container.encodeIfPresent(description, forKey: "description")
        try container.encodeIfPresent(type, forKey: "type")
        try container.encodeIfPresent(leverages, forKey: "leverages")
        try container.encodeIfPresent(currencies, forKey: "currencies")
        try container.encodeIfPresent(minimumDepositsAmount, forKey: "minimumDepositsAmount")
        try container.encodeIfPresent(isForex, forKey: "isForex")
        try container.encodeIfPresent(isSignalsAvailable, forKey: "isSignalsAvailable")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        id = try container.decodeIfPresent(UUID.self, forKey: "id")
        name = try container.decodeIfPresent(String.self, forKey: "name")
        description = try container.decodeIfPresent(String.self, forKey: "description")
        type = try container.decodeIfPresent(ModelType.self, forKey: "type")
        leverages = try container.decodeIfPresent([Int].self, forKey: "leverages")
        currencies = try container.decodeIfPresent([String].self, forKey: "currencies")
        minimumDepositsAmount = try container.decodeIfPresent([String:Double].self, forKey: "minimumDepositsAmount")
        isForex = try container.decodeIfPresent(Bool.self, forKey: "isForex")
        isSignalsAvailable = try container.decodeIfPresent(Bool.self, forKey: "isSignalsAvailable")
    }
}

