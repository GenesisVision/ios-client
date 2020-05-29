//
// MakeTradingAccountSignalProvider.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct MakeTradingAccountSignalProvider: Codable {


    public var _id: UUID?

    public var volumeFee: Double?

    public var successFee: Double?

    public var title: String?

    public var _description: String?

    public var logo: String?
    public init(_id: UUID? = nil, volumeFee: Double? = nil, successFee: Double? = nil, title: String? = nil, _description: String? = nil, logo: String? = nil) { 
        self._id = _id
        self.volumeFee = volumeFee
        self.successFee = successFee
        self.title = title
        self._description = _description
        self.logo = logo
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case volumeFee
        case successFee
        case title
        case _description = "description"
        case logo
    }

}
