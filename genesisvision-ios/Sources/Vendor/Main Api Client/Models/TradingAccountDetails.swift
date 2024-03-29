//
// TradingAccountDetails.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct TradingAccountDetails: Codable {


    public var _id: UUID?

    public var currency: Currency?

    public var login: String?

    public var apiKey: String?

    public var asset: AssetDetails?
    public init(_id: UUID? = nil, currency: Currency? = nil, login: String? = nil, apiKey: String? = nil, asset: AssetDetails? = nil) { 
        self._id = _id
        self.currency = currency
        self.login = login
        self.apiKey = apiKey
        self.asset = asset
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case currency
        case login
        case apiKey
        case asset
    }

}
