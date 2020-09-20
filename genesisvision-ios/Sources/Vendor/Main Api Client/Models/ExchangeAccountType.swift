//
// ExchangeAccountType.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct ExchangeAccountType: Codable {


    public var _id: UUID?

    public var name: String?

    public var _description: String?

    public var type: BrokerTradeServerType?

    public var currencies: [String]?

    public var minimumDepositsAmount: [String:Double]?

    public var isKycRequired: Bool?

    public var isCountryNotUSRequired: Bool?

    public var isSignalsAvailable: Bool?

    public var isDepositRequired: Bool?
    public init(_id: UUID? = nil, name: String? = nil, _description: String? = nil, type: BrokerTradeServerType? = nil, currencies: [String]? = nil, minimumDepositsAmount: [String:Double]? = nil, isKycRequired: Bool? = nil, isCountryNotUSRequired: Bool? = nil, isSignalsAvailable: Bool? = nil, isDepositRequired: Bool? = nil) { 
        self._id = _id
        self.name = name
        self._description = _description
        self.type = type
        self.currencies = currencies
        self.minimumDepositsAmount = minimumDepositsAmount
        self.isKycRequired = isKycRequired
        self.isCountryNotUSRequired = isCountryNotUSRequired
        self.isSignalsAvailable = isSignalsAvailable
        self.isDepositRequired = isDepositRequired
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case name
        case _description = "description"
        case type
        case currencies
        case minimumDepositsAmount
        case isKycRequired
        case isCountryNotUSRequired
        case isSignalsAvailable
        case isDepositRequired
    }

}