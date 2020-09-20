//
// DashboardTradingAssetBrokerDetails.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct DashboardTradingAssetBrokerDetails: Codable {


    public var _id: UUID?

    public var logoUrl: String?

    public var name: String?

    public var type: BrokerTradeServerType?
    public init(_id: UUID? = nil, logoUrl: String? = nil, name: String? = nil, type: BrokerTradeServerType? = nil) { 
        self._id = _id
        self.logoUrl = logoUrl
        self.name = name
        self.type = type
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case logoUrl
        case name
        case type
    }

}